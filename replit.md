# Harvest Direct: Farm-to-Table E-commerce Platform

## Overview
Harvest Direct is a full-stack e-commerce platform designed to connect consumers directly with traditional farmers. It facilitates the purchase of authentic, preservative-free agricultural products such as coffee, spices, and grains, while highlighting traditional farming methods. The platform aims to provide a secure and seamless shopping experience.

## User Preferences
Preferred communication style: Simple, everyday language.

## System Architecture
The application utilizes a client-server architecture.

### Frontend
- **Framework**: React.js
- **UI/UX**: `shadcn/ui` (built on Radix UI) for components, styled with Tailwind CSS for a clean, consistent design. Framer Motion is used for animations.
- **State Management**: React Query for server-side data synchronization and React Context for local state.
- **Routing**: Wouter.
- **Form Handling**: React Hook Form with Zod for robust validation.
- **Key Features**: Comprehensive user interface including product browsing, detailed product views, farmer profiles, shopping cart management, and a secure checkout process. Includes a consistent layout and reusable UI components like `ProductCard` and `FarmerCard`.

### Backend
- **Framework**: Express.js.
- **ORM**: Drizzle ORM for PostgreSQL.
- **Database**: PostgreSQL, with Neon for production hosting.
- **API**: Provides CRUD operations for products, farmer information, shopping cart, and shipping services.
- **Data Schemas**: Defined for Products, Farmers, Cart, Testimonials, Newsletter subscriptions, and Orders.
- **Authentication**: Implements SMS OTP verification for user registration and password changes, integrating with Fast2SMS. Secure password hashing (bcrypt) and authentication middleware are employed.
- **Admin Functionality**: Includes order management, discount management, and order cancellation processing.
- **Shipping Integration**: Integrates with India Post API for real-time shipping rates, tracking, and Cash on Delivery (COD) services, including automated weight-based shipping calculations.

### System Design Choices
- **Deployment**: Configured for deployment on Replit, supporting both development and production environments.
- **Data Flow**: Designed for efficient product browsing with caching, synchronized shopping cart management, and secure checkout with comprehensive validation.
- **Security**: Features SMS OTP verification with expiration, mobile number validation, secure password hashing, and authentication middleware. Email verification is used for email address changes.
- **User Experience**: Emphasizes intuitive interfaces, robust error handling, clear loading states, and mobile responsiveness. Address localization is implemented for Indian users.
- **Category Management**: Supports flexible category and subcategory structures, allowing duplicate subcategory names under different parent categories, with uniqueness enforced within the same parent. Deletion is protected if items are associated.

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
- Fast2SMS API (for SMS OTP services)
- PostgreSQL
- India Post API (for shipping and tracking services)
- Razorpay (for payment processing)
- Nodemailer (for email verification)