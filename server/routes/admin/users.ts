import { Router } from "express";

import {
  getUsers,
  updateUserStatus,
  toggleUserCodAccess,
  updateUserDetails,
} from "../../controllers/admin/users";
import { authenticateAdmin } from "server/admin";

const router = Router();

// Get all users with pagination and filters
router.get("/", authenticateAdmin, getUsers);

// Update user status (email verified)
router.put("/:id", authenticateAdmin, updateUserStatus);

// Toggle COD access for user
router.patch("/:id/cod-access", authenticateAdmin, toggleUserCodAccess);

// Update user email and password
router.patch("/:id/details", authenticateAdmin, updateUserDetails);

export default router;
