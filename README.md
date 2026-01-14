# NextGen Organics - Hyperlocal Grocery Ecosystem

**NextGen Organics** is a production-ready, dual-model grocery platform that bridges the gap between instant convenience and direct farm-to-table sourcing. It features a cross-platform mobile app for users and a powerful web-based admin panel for vendors and operations.

---

## 🏗️ Tech Stack

### Mobile App (User Facing)

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Design System**: Custom "Clean Green" Theme, Glassmorphism elements.

### Admin & Vendor Panel (Operations)

- **Framework**: Next.js (React / TypeScript)
- **Styling**: Tailwind CSS + Shadcn UI
- **Features**: Role-based access (Admin/Vendor), Data Visualization, Inventory Management.

### Backend Infrastructure

- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth (Phone, Google, Apple)
- **Storage**: Supabase Storage for product/vendor images.

---

## 📱 Mobile App Setup (Flutter)

Located in `/frontend`.

### Prerequisites

- Flutter SDK (>=3.0.0)
- Java JDK 17 (for Android)

### Quick Start

1. **Navigate to the directory**:
   ```bash
   cd frontend
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```
   _Tip: Use `flutter run -d chrome` for web or connect an Android device/emulator._

---

## 💻 Admin Web Panel Setup (Next.js)

Located in `/admin-web`.

### Prerequisites

- Node.js (>=18.0.0)

### Quick Start

1. **Navigate to the directory**:
   ```bash
   cd admin-web
   ```
2. **Install dependencies**:
   ```bash
   npm install
   ```
3. **Run development server**:
   ```bash
   npm run dev
   ```
4. **Open in browser**:
   Visit [http://localhost:3000](http://localhost:3000)
   _Demo Credentials:_ `admin@demo.com` / `Admin@123`

---

## 🗄️ Backend Setup (Supabase)

This project relies on Supabase for data.

1. **Schema Setup**: Run the `supabase_schema.sql` script in your Supabase SQL Editor to create tables.
2. **Seed Data**: Run `seed_data.sql` to populate the database with categories, vendors, and dummy products.
3. **Environment Links**:
   - Update `frontend/lib/core/config/supabase_config.dart` with your Supabase URL/Key.
   - Update `admin-web/.env.local` with your Supabase URL/Key.

---

## 🚀 Key Features

### 1. Hub Store vs Farms

- **Hub Store**: Platform-managed inventory for instant delivery.
- **Farms**: Marketplace for verified local vendors to sell directly to consumers.

### 2. Verified Vendor Architecture

- Vendor onboarding flow via Web Portal.
- Admin verification and approval pipeline.
- Dedicated Vendor Profile pages in the mobile app.

### 3. Smart Suggestions

- Cross-selling engine in Product Details ("More from this Farm").
- Impulse buy suggestions in Cart.

---

## 📂 Project Structure

```
next-organics/
├── frontend/           # Flutter Mobile App
│   ├── lib/features/   # Feature-based modular architecture
│   └── lib/core/       # Shared utilities and widgets
├── admin-web/          # Next.js Admin Dashboard
│   ├── src/app/        # App Router pages
│   └── src/components/ # Reusable UI components
├── backend/            # Setup scripts & docs
└── README.md           # This file
```

---

_© 2026 NextGen Organics. All rights reserved._
