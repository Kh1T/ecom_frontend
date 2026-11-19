# E-commerce Frontend

## Project Overview

A Flutter e-commerce app for customers and administrators in one codebase, using role-based access. Customers can sign in, browse and search products, and manage a cart. Admins have a protected area for managing products. Built with GetX and organized into feature-based modules.

## Project Objective

To build a Flutter e-commerce mobile app where customers can browse, search, and shop for products, and administrators can manage the catalog through a protected, role-based area.

## Main Application Menu

Accessed from the sidebar drawer.

**Shop**
- Home
- Products
- Search
- Cart

**Account**
- Dashboard
- Admin (admin users only)
- Sign In / Register, or Logout when signed in

## System Flow

1. **Start as guest:** the app opens on Home, where users can browse Products, Search, and use the Cart.
2. **Sign in or register:** the user submits credentials, and the backend returns a token. The app stores the token and fetches the current user.
3. **Route by role:**
   - Admin users go to the Admin Panel.
   - Customers go to Home.

Admin routes are guarded, so non-admin or signed-out users are redirected to Home. Logout clears the user and returns to Home.

## Technology Stack

- **Framework:** Flutter (Dart, SDK ^3.10.0)
- **State management, routing, DI:** GetX
- **HTTP client:** Dio
- **Local storage:** shared_preferences
- **Configuration:** flutter_dotenv (`.env`)
- **Media:** image_picker (product images)

## Conclusion

This project delivers a Flutter e-commerce app with role-based access in a single codebase. Customers can browse, search, and use the cart, while administrators manage products through a protected panel. The structure is modular and ready for the planned features.

## 6. Functions of the Ecommerce Customer Mobile App

- **Account:** sign in, register, and sign out; guest browsing is allowed
- **Home:** landing page with entry points to products, search, and cart
- **Products:** view the product catalog and product details, including images and variants
- **Search:** find products by keyword and add results to the cart
- **Cart:** add items, increase or decrease quantity, remove items, and clear the cart
- **Sidebar menu:** navigate between Home, Products, Search, Cart, and Dashboard

## 7. Functions of the Ecommerce Admin Dashboard

- **Access control:** only users with the ADMIN role can open the admin panel
- **Summary cards:** sales, orders, users, and product counts (currently placeholder values)
- **Product management:** create, edit, and delete products; change product status
- **Images:** upload and delete product images
- **Variants:** add and update product variants (for example, size or colour)
- **Navigation:** Dashboard, Orders, and Users sections (Orders and Users are placeholders)

## Planned Features

- Product details, variants, and checkout
- Order history and order status
- Admin dashboard with stats and order management
- Wishlist, filters, and dark mode

## Getting Started

Install Flutter, then fetch the project dependencies and launch the app:

```bash
flutter pub get
flutter run
```
