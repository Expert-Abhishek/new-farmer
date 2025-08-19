# Harvest Direct: Farm-to-Table E-commerce Platform

## Overview

Harvest Direct is a full-stack e-commerce platform connecting consumers directly with traditional farmers. Its primary purpose is to enable the purchase of authentic, preservative-free products like coffee, spices, and grains, while showcasing the stories behind traditional farming methods. The platform aims to provide a seamless and secure shopping experience, including features like SMS OTP verification for user registration and password changes.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

The application employs a client-server architecture.

### Frontend
- **Framework**: React.js
- **UI Kit**: shadcn/ui (built on Radix UI)
- **Styling**: Tailwind CSS
- **State Management**: React Query for server state, React Context for local state (e.g., CartContext)
- **Routing**: Wouter
- **Form Handling**: React Hook Form and Zod for validation
- **Animations**: Framer Motion

Core frontend components include pages for Home, Product Detail, All Products, All Farmers, and Checkout, along with reusable UI components, a Cart system, ProductCard, FarmerCard, and a consistent layout.

### Backend
- **Framework**: Express.js
- **ORM**: Drizzle ORM (configured for PostgreSQL)
- **Data Storage**: PostgreSQL database with Neon hosting for production data
- **API Routes**: Handles CRUD operations for products, farmer information retrieval, shopping cart actions, and shipping services
- **Data Schemas**: Defined for Products, Farmers, Cart, Testimonials, Newsletter subscriptions, and Orders
- **Authentication**: Includes SMS OTP verification for registration and password changes, integrating with Twilio
- **Admin Functionality**: Features for managing orders and processing order cancellation requests
- **Shipping Integration**: India Post API integration for real-time shipping rates, tracking, and COD services

### System Design Choices
- **Deployment**: Configured for deployment on Replit, supporting both development and production environments.
- **Data Flow**: Supports product browsing with caching, shopping cart management with local state and server synchronization, and a secure checkout process with form validation.
- **Security**: Implements SMS OTP verification with expiration, mobile number validation, secure password hashing (bcrypt), and authentication middleware for sensitive operations.
- **User Experience**: Focuses on intuitive interfaces, proper error handling, loading states, and mobile responsiveness.

## External Dependencies

### Frontend
- React
- React DOM
- Tailwind CSS
- shadcn/ui (Radix UI)
- React Query
- Wouter
- Framer Motion
- React Hook Form
- Zod

### Backend
- Express.js
- Drizzle ORM
- Vite (for development and building)
- Twilio API (for SMS OTP services)
- PostgreSQL (database, configured)
- India Post API (for shipping and tracking services)
- Razorpay (for payment processing)

## Recent Updates (August 19, 2025)

### Dynamic Logo System Integration (Latest - COMPLETED)
- **Dynamic Logo System**: Implemented complete dynamic logo upload system through admin site settings
- **Admin Upload Interface**: Logo can be uploaded via Admin > Settings with file upload or URL entry
- **User Navigation**: Logo displays dynamically from site settings in main website navigation (fallback to static logo)
- **Admin Interface**: Logo displays dynamically in admin layout header with proper scaling (h-8)
- **Site Context Integration**: Uses existing SiteContext for real-time logo updates across both interfaces
- **Automatic Updates**: Logo changes in admin settings immediately reflect in both user and admin navigation
- **Fallback System**: Gracefully falls back to default logo if no custom logo is uploaded
- **Brand Consistency**: Site name also updates dynamically from settings across all interfaces

### Mobile Number Change Security Fix (Latest - COMPLETED)  
- **Security Flow Fixed**: Corrected OTP verification to check against old/current number instead of new number
- **Backend Logic**: Updated `/api/auth/change-number` endpoint to verify OTP with `user.mobile` (old number)
- **UI Messages**: Fixed frontend messages to correctly show "OTP sent to current number" 
- **User Experience**: Updated toast notifications and instruction text to reflect correct security flow
- **Working Process**: 1) Enter new number → 2) OTP sent to current number → 3) Verify with current number → 4) Update to new number

### Email Verification System for Email Changes (COMPLETED)
- **Complete Email-Based Verification**: Successfully migrated change email functionality from SMS OTP to email verification
- **Database Implementation**: Created `emailChangeVerifications` table with secure token management and 1-hour expiration
- **Nodemailer Integration**: Implemented comprehensive email verification using nodemailer SMTP service with professional email templates
- **Site Branding Update**: Successfully updated all references from "Harvest Direct" to "Freshly Rooted" in database and email templates
- **Security Flow**: Email verification sent to current email address before allowing email changes, preventing unauthorized changes
- **Frontend Implementation**: Updated ChangeEmailUser component to use email verification workflow instead of SMS OTP
- **Verification Page**: Created dedicated email verification page at `/verify-email-change` with proper content display and error handling
- **User Experience**: Added comprehensive UI with loading states, success/error indicators, and clear user feedback
- **Token Security**: 1-hour expiration for verification tokens with proper cleanup and URL generation
- **Production Ready**: Fully functional email change system with proper error handling, user feedback, and automatic redirection

## Recent Updates (August 19, 2025)

### SMS Service Migration from Twilio to Fast2SMS (Latest)
- **Complete Migration**: Successfully migrated from Twilio to Fast2SMS for all OTP services
- **DLT Route Implementation**: Implemented Fast2SMS DLT route with proper parameters (route=dlt, sender_id=FSYRTD, message=195093)
- **Direct API Integration**: Uses GET requests with query parameters as required by Fast2SMS DLT API
- **Successful SMS Delivery**: Confirmed working SMS delivery with response: "SMS sent successfully" and request tracking
- **Correct Parameter Format**: Uses variables_values with pipe separator (e.g., "123456|") for OTP values
- **Service Features**: Supports all OTP purposes (registration, password reset, account deletion, email/mobile change)
- **Environment Setup**: FAST2SMS_API_KEY properly configured for DLT route
- **Enhanced Logging**: Added service initialization and detailed response logging for debugging
- **Comprehensive Error Handling**: Handles all Fast2SMS response codes with user-friendly messages
- **Production Ready**: SMS service fully functional and tested with live API responses

### Previous Updates (August 16, 2025)

### Category and Subcategory Validation System (Latest)
- **Separate Entity Validation**: Categories and subcategories are treated as completely separate entities
- **Category Uniqueness**: Only prevents duplicate names among main categories (case-insensitive)
- **Subcategory Uniqueness**: Only prevents duplicate names within their parent category (case-insensitive)
- **Cross-Type Flexibility**: "Powder" can exist as both a category AND a subcategory simultaneously
- **Usage Protection**: Categories/subcategories cannot be deleted if used by products
- **Enhanced Deletion Errors**: Shows detailed table with product name, image, category, and subcategory when deletion blocked
- **Product Deletion Fix**: Resolved "No variants found" error, products can now be deleted without variants
- **VITE_BASE_URL Integration**: Completed image URL handling across all platform components

### Enhanced Product Management Improvements
- **Variant Management**: Fixed "Remove Variant" button to only show when multiple variants exist
- **Form Validation**: Fixed discount price validation to properly handle empty/null values with improved preprocessing
- **Deletion Safety**: Implemented proper deletion error modal with table format showing SKU and Order columns
- **Variant Deletion**: Added variant-specific deletion checking with order validation using existing `/api/admin/variants/:id` endpoint
- **User Experience**: Enhanced error messages and confirmation dialogs for both product and variant deletion

### Previous Updates (August 15, 2025)

### Migration Completion
- **Replit Agent to Replit Migration**: Successfully migrated project from Replit Agent to standard Replit environment
- **Bug Fix**: Fixed infinite image upload loop in enhanced product management due to stale state reference in `handleImageRemove` function
- **Security**: Ensured proper client/server separation and robust security practices
- **Performance**: Optimized image upload handling to prevent browser crashes from excessive network requests

## Previous Updates (August 14, 2025)

### India Post API Integration
- **Shipping Rate Calculator**: Real-time calculation of shipping costs using India Post services
  - Speed Post: ₹205 (4 days delivery)
  - Registered Post: ₹145 (7 days delivery)
  - Express Parcel: Available for bulk orders
- **Pincode Validation**: Validates Indian pincodes and provides location information
- **Order Tracking**: Real-time shipment tracking with status updates and location history
- **COD Support**: Cash on Delivery availability checking for different locations
- **Shipping Page**: Comprehensive shipping showcase at `/shipping` with calculator and tracking tools

### Technical Implementation
- Created `server/indiaPostApi.ts` for shipping service integration
- Added shipping API routes: `/api/shipping/validate-pincode`, `/api/shipping/calculate-rates`, `/api/shipping/track`
- Built React components: `ShippingCalculator` and `OrderTracking`
- Integrated fallback data for common Indian cities when external APIs are unavailable
- Added shipping page to main navigation