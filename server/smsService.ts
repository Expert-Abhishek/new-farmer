// Removed fast2sms library dependency - using direct fetch instead
import { db } from "./db";
import { smsVerifications } from "@shared/schema";
import { eq, and, gte, lt, sql } from "drizzle-orm";
import dotenv from "dotenv";
dotenv.config();

interface Fast2SmsConfig {
  apiKey: string;
  senderId?: string;
}

class SmsService {
  private apiKey: string;
  private senderId: string;

  constructor() {
    this.apiKey = process.env.FAST2SMS_API_KEY || "";
    this.senderId = process.env.FAST2SMS_SENDER_ID || "FSTSMS";

    if (!this.apiKey) {
      console.warn("Fast2SMS API key is not configured. SMS functionality will be disabled.");
    } else {
      console.log("Fast2SMS service initialized successfully");
    }
  }

  /**
   * Generate a 6-digit OTP
   */
  private generateOTP(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  /**
   * Validate Indian mobile number format
   */
  private validateMobileNumber(mobile: string): boolean {
    // Indian mobile number: 10 digits starting with 6-9
    const indianMobileRegex = /^[6-9]\d{9}$/;
    return indianMobileRegex.test(mobile);
  }

  /**
   * Format mobile number for international SMS
   */
  private formatMobileNumber(mobile: string): string {
    if (mobile.startsWith("+91")) return mobile;
    if (mobile.startsWith("91")) return `+${mobile}`;
    return `+91${mobile}`;
  }

  /**
   * Send OTP via SMS
   */
  // async sendOTP(
  //   mobile: string,
  //   purpose:
  //     | "registration"
  //     | "password_reset"
  //     | "account_deletion"
  //     | "change_email"
  // ): Promise<{ success: boolean; message: string }> {
  //   try {
  //     // Validate mobile number
  //     if (!this.validateMobileNumber(mobile)) {
  //       return {
  //         success: false,
  //         message:
  //           "Invalid mobile number format. Please enter a valid 10-digit Indian mobile number.",
  //       };
  //     }

  //     // Generate OTP
  //     const otp = this.generateOTP();
  //     const expiresAt = new Date();
  //     expiresAt.setMinutes(expiresAt.getMinutes() + 10); // OTP expires in 10 minutes

  //     // Store OTP in database
  //     await db.insert(smsVerifications).values({
  //       mobile,
  //       otp,
  //       purpose,
  //       expiresAt,
  //       verified: false,
  //     });

  //     // Format phone number
  //     const formattedMobile = this.formatMobileNumber(mobile);

  //     // Send SMS
  //     // const message =
  //     //   purpose === "registration"
  //     //     ? `Your Harvest Direct registration OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`
  //     //     : `Your Harvest Direct password reset OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`;
  //     // abhi
  //     const messages: Record<string, string> = {
  //       registration: `Your Harvest Direct registration OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
  //       password_reset: `Your Harvest Direct password reset OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
  //       account_deletion: `Your Harvest Direct account deletion OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
  //     };
  //     const message =
  //       messages[purpose] ||
  //       `Your Harvest Direct OTP is: ${otp}. Valid for 10 minutes.`;
  //     await this.client.messages.create({
  //       body: message,
  //       from: this.fromPhoneNumber,
  //       to: formattedMobile,
  //     });

  //     return {
  //       success: true,
  //       message: "OTP sent successfully to your mobile number.",
  //     };
  //   } catch (error) {
  //     console.error("Error sending SMS:", error);
  //     return {
  //       success: false,
  //       message: "Failed to send OTP. Please try again.",
  //     };
  //   }
  // }
  // abhi
  async sendOTP(
    mobile: string,
    purpose:
      | "registration"
      | "password_reset"
      | "account_deletion"
      | "change_email"
      | "change_number"
  ): Promise<{ success: boolean; message: string }> {
    try {
      // Check if Fast2SMS is configured
      if (!this.apiKey) {
        return {
          success: false,
          message: "SMS service is not configured. Please contact administrator.",
        };
      }

      // ✅ Validate mobile
      if (!this.validateMobileNumber(mobile)) {
        return {
          success: false,
          message:
            "Invalid mobile number format. Please enter a valid 10-digit Indian mobile number.",
        };
      }

      const otp = this.generateOTP();
      const expiresAt = new Date();
      expiresAt.setMinutes(expiresAt.getMinutes() + 10); // Valid for 10 minutes

      // ✅ Store OTP in DB
      await db.insert(smsVerifications).values({
        mobile,
        otp,
        purpose,
        expiresAt,
        verified: false,
      });

      // ✅ Send SMS
      const messages: Record<string, string> = {
        registration: `Your Harvest Direct registration OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
        password_reset: `Your Harvest Direct password reset OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
        account_deletion: `Your Harvest Direct account deletion OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
        change_email: `Your Harvest Direct email change OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
        change_number: `Your Harvest Direct mobile number change OTP is: ${otp}. Valid for 10 minutes. Do not share this code.`,
      };

      const message = messages[purpose] || `Your OTP is: ${otp}`;

      // Send SMS using Fast2SMS direct API call
      const fast2smsUrl = "https://www.fast2sms.com/dev/bulkV2";
      const requestBody = {
        variables_values: otp, // Only the OTP numeric value (up to 8 digits)
        route: "otp", // For OTP Message use "otp"
        numbers: mobile, // Mobile number as string
        flash: "0" // 0 for normal SMS, 1 for flash SMS
      };

      const response = await fetch(fast2smsUrl, {
        method: "POST",
        headers: {
          "authorization": this.apiKey,
          "content-type": "application/json"
        },
        body: JSON.stringify(requestBody)
      });

      const responseData = await response.json();
      console.log("Fast2SMS response:", responseData);

      // Check if Fast2SMS API call was successful
      if (responseData.return === true || responseData.status_code === 200) {
        return {
          success: true,
          message: "OTP sent successfully to your mobile number.",
        };
      } else {
        // Handle specific Fast2SMS error codes
        let errorMessage = "Failed to send OTP. Please try again.";
        
        if (responseData.status_code === 996) {
          errorMessage = "SMS service requires website verification. Please contact admin.";
          console.error("Fast2SMS Error: Website verification required for OTP API");
        } else if (responseData.status_code === 402) {
          errorMessage = "SMS configuration error. Please contact admin.";
          console.error("Fast2SMS Error: Message text missing or invalid format");
        } else if (responseData.status_code === 408) {
          errorMessage = "SMS service configuration error. Please contact admin.";
          console.error("Fast2SMS Error: Invalid route specified");
        }
        
        return {
          success: false,
          message: errorMessage,
        };
      }
    } catch (error) {
      console.error("Error sending SMS:", error);
      return {
        success: false,
        message: "Failed to send OTP. Please try again.",
      };
    }
  }

  /**
   * Verify OTP
   */
  async verifyOTP(
    mobile: string,
    otp: string,
    purpose:
      | "registration"
      | "password_reset"
      | "account_deletion"
      | "change_email"
      | "change_number"
  ): Promise<{ success: boolean; message: string }> {
    try {
      const now = new Date();

      // Find valid OTP
      const verification = await db
        .select()
        .from(smsVerifications)
        .where(
          and(
            eq(smsVerifications.mobile, mobile),
            eq(smsVerifications.otp, otp),
            eq(smsVerifications.purpose, purpose),
            eq(smsVerifications.verified, false),
            gte(smsVerifications.expiresAt, now)
          )
        )
        .limit(1);

      if (verification.length === 0) {
        return {
          success: false,
          message: "Invalid or expired OTP. Please request a new one.",
        };
      }

      // Mark OTP as verified
      await db
        .update(smsVerifications)
        .set({ verified: true })
        .where(eq(smsVerifications.id, verification[0].id));

      return {
        success: true,
        message: "OTP verified successfully.",
      };
    } catch (error) {
      console.error("Error verifying OTP:", error);
      return {
        success: false,
        message: "Failed to verify OTP. Please try again.",
      };
    }
  }

  /**
   * Clean up expired OTP records
   */
  async cleanupExpiredOTPs(): Promise<void> {
    try {
      await db
        .delete(smsVerifications)
        .where(lt(smsVerifications.expiresAt, sql`NOW()`));
    } catch (error) {
      console.error("Error cleaning up expired OTPs:", error);
    }
  }
}

export const smsService = new SmsService();
