import { Request, Response } from "express";
import { eq, like, or, desc, asc, sql } from "drizzle-orm";
import bcrypt from "bcrypt";
import { db } from "../../db";
import { users, orders } from "../../../shared/schema";
import { EmailService } from "../../emailService";
import { siteSettings } from "../../../shared/schema";

// Initialize EmailService
const getSiteSettings = async () => {
  return await db.select().from(siteSettings);
};
const emailService = new EmailService(getSiteSettings);

export const getUsers = async (req: Request, res: Response) => {
  try {
    const {
      page = "1",
      limit = "10",
      search = "",
      status = "all",
      codAccess = "all",
      sort = "createdAt",
      order = "desc",
    } = req.query;

    const pageNum = parseInt(page as string);
    const limitNum = parseInt(limit as string);
    const offset = (pageNum - 1) * limitNum;

    // Build where conditions
    const conditions = [];

    if (search) {
      conditions.push(
        or(
          like(users.name, `%${search}%`),
          like(users.email, `%${search}%`)
        )
      );
    }

    if (status === "active") {
      conditions.push(eq(users.emailVerified, true));
    } else if (status === "blocked") {
      conditions.push(eq(users.emailVerified, false));
    }

    if (codAccess === "enabled") {
      conditions.push(eq(users.codEnabled, true));
    } else if (codAccess === "disabled") {
      conditions.push(eq(users.codEnabled, false));
    }

    // Get users with order statistics
    const usersQuery = db
      .select({
        id: users.id,
        name: users.name,
        email: users.email,
        role: users.role,
        emailVerified: users.emailVerified,
        mobileVerified: users.mobileVerified,
        codEnabled: users.codEnabled,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
        orders: sql<number>`COALESCE(COUNT(${orders.id}), 0)`.as("orders"),
        totalSpent: sql<number>`COALESCE(SUM(${orders.total}), 0)`.as("totalSpent"),
      })
      .from(users)
      .leftJoin(orders, eq(users.id, orders.userId))
      .where(conditions.length > 0 ? sql`${conditions.join(" AND ")}` : undefined)
      .groupBy(users.id)
      .orderBy(
        order === "desc" 
          ? desc(users[sort as keyof typeof users] || users.createdAt)
          : asc(users[sort as keyof typeof users] || users.createdAt)
      )
      .limit(limitNum)
      .offset(offset);

    const usersList = await usersQuery;

    // Get total count for pagination
    const totalResult = await db
      .select({ count: sql<number>`COUNT(*)`.as("count") })
      .from(users)
      .where(conditions.length > 0 ? sql`${conditions.join(" AND ")}` : undefined);

    const total = totalResult[0]?.count || 0;
    const totalPages = Math.ceil(total / limitNum);

    res.json({
      users: usersList.map(user => ({
        ...user,
        orders: Number(user.orders) || 0,
        totalSpent: Number(user.totalSpent) || 0,
      })),
      pagination: {
        total,
        page: pageNum,
        limit: limitNum,
        totalPages,
      },
    });
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({ message: "Failed to fetch users" });
  }
};

export const updateUserStatus = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { emailVerified } = req.body;

    const userId = parseInt(id);
    if (isNaN(userId)) {
      return res.status(400).json({ message: "Invalid user ID" });
    }

    // Update user status
    await db
      .update(users)
      .set({ 
        emailVerified,
        updatedAt: new Date(),
      })
      .where(eq(users.id, userId));

    res.json({ 
      message: `User ${emailVerified ? "activated" : "deactivated"} successfully`,
    });
  } catch (error) {
    console.error("Error updating user status:", error);
    res.status(500).json({ message: "Failed to update user status" });
  }
};

export const toggleUserCodAccess = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { codEnabled } = req.body;

    const userId = parseInt(id);
    if (isNaN(userId)) {
      return res.status(400).json({ message: "Invalid user ID" });
    }

    await db
      .update(users)
      .set({ 
        codEnabled,
        updatedAt: new Date(),
      })
      .where(eq(users.id, userId));

    res.json({ 
      message: `COD access ${codEnabled ? "enabled" : "disabled"} successfully`,
    });
  } catch (error) {
    console.error("Error toggling COD access:", error);
    res.status(500).json({ message: "Failed to toggle COD access" });
  }
};

export const updateUserDetails = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { email, password } = req.body;

    const userId = parseInt(id);
    if (isNaN(userId)) {
      return res.status(400).json({ message: "Invalid user ID" });
    }

    // Validate email
    if (!email || !email.trim()) {
      return res.status(400).json({ message: "Email is required" });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ message: "Invalid email format" });
    }

    // Validate password if provided
    if (password && password.length < 6) {
      return res.status(400).json({ 
        message: "Password must be at least 6 characters long" 
      });
    }

    if (password) {
      const specialCharRegex = /[!@#$%^&*(),.?":{}|<>]/;
      if (!specialCharRegex.test(password)) {
        return res.status(400).json({ 
          message: "Password must contain at least 1 special character" 
        });
      }
    }

    // Get current user data
    const currentUser = await db
      .select()
      .from(users)
      .where(eq(users.id, userId))
      .limit(1);

    if (!currentUser.length) {
      return res.status(404).json({ message: "User not found" });
    }

    const user = currentUser[0];
    const oldEmail = user.email;

    // Check if email is already taken by another user
    if (email !== oldEmail) {
      const existingUser = await db
        .select()
        .from(users)
        .where(eq(users.email, email))
        .limit(1);

      if (existingUser.length > 0) {
        return res.status(400).json({ message: "Email already exists" });
      }
    }

    // Prepare update data
    const updateData: any = {
      email,
      updatedAt: new Date(),
    };

    let hashedPassword = null;
    if (password) {
      hashedPassword = await bcrypt.hash(password, 10);
      updateData.password = hashedPassword;
    }

    // Update user in database
    await db
      .update(users)
      .set(updateData)
      .where(eq(users.id, userId));

    // Send email notifications
    try {
      if (email !== oldEmail) {
        await emailService.sendAdminEmailUpdateNotification(
          { ...user, email }, // Pass user with new email
          oldEmail,
          email
        );
      }

      if (password) {
        await emailService.sendAdminPasswordUpdateNotification(
          { ...user, email }, // Pass user with potentially new email
          password // Send the plain password in email
        );
      }
    } catch (emailError) {
      console.error("Error sending notification emails:", emailError);
      // Don't fail the request if email fails, just log it
    }

    res.json({ 
      message: "User details updated successfully",
      emailChanged: email !== oldEmail,
      passwordChanged: !!password,
    });
  } catch (error) {
    console.error("Error updating user details:", error);
    res.status(500).json({ message: "Failed to update user details" });
  }
};
