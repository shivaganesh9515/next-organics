# 🚀 Supabase Backend Deployment Guide

Production-ready backend schema for multi-platform app (Flutter + Next.js).

## 📦 File Structure

```
backend/
├── 00_cleanup.sql       # ⚠️ Optional: Drops all existing tables
├── 01_enums.sql         # Custom types (user_role, vendor_status)
├── 02_schema.sql        # 6 tables + triggers + indexes
├── 03_rls_policies.sql  # Row Level Security policies
├── 04_demo_data.sql     # Demo data for investor presentation
└── README.md            # This file
```

## 🗂️ Database Tables

| Table           | Purpose                                     |
| --------------- | ------------------------------------------- |
| `profiles`      | User data extending auth.users              |
| `vendors`       | Vendor business info with approval workflow |
| `categories`    | Product grouping                            |
| `products`      | Vendor-owned products                       |
| `stock_logs`    | Stock change audit trail                    |
| `admin_actions` | Admin operation logging                     |

## 🔐 Security (RLS)

| Role       | Access                  |
| ---------- | ----------------------- |
| **Admin**  | Full CRUD on all tables |
| **Vendor** | Own data only           |
| **Public** | No access               |

## 🚀 Deployment Steps

### Step 1: Open Supabase SQL Editor

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Navigate to **SQL Editor**

### Step 2: Execute SQL Files (In Order)

```bash
# If starting fresh, run cleanup first (OPTIONAL - DELETES ALL DATA!)
00_cleanup.sql

# Required files - run in this exact order:
01_enums.sql
02_schema.sql
03_rls_policies.sql
```

### Step 3: Create Demo Users

1. Go to **Authentication** → **Users** → **Add User**
2. Create:
   | Email | Password |
   |-------|----------|
   | `admin@demo.com` | `Admin@123` |
   | `vendor@demo.com` | `Vendor@123` |

### Step 4: Run Demo Data Script

```bash
# After creating users, run:
04_demo_data.sql
```

## ✅ Verification

Run these queries to verify setup:

```sql
-- Check profiles
SELECT email, role, is_active FROM public.profiles;

-- Check vendors
SELECT shop_name, status FROM public.vendors;

-- Check categories
SELECT name, is_active FROM public.categories;

-- Check products
SELECT name, price, stock FROM public.products;

-- Check stock logs
SELECT reason, change FROM public.stock_logs;
```

## 📱 Client Integration

### Flutter/Next.js Auth

```dart
// Sign in
await supabase.auth.signInWithPassword(
  email: 'vendor@demo.com',
  password: 'Vendor@123',
);

// Get user role
final profile = await supabase
  .from('profiles')
  .select('role')
  .eq('id', supabase.auth.currentUser!.id)
  .single();
```

### Vendor Check

```dart
// Check if vendor is approved
final vendor = await supabase
  .from('vendors')
  .select('status')
  .eq('user_id', userId)
  .single();

if (vendor['status'] == 'approved') {
  // Allow access
}
```

## 🔑 Demo Credentials

| Role   | Email             | Password     |
| ------ | ----------------- | ------------ |
| Admin  | `admin@demo.com`  | `Admin@123`  |
| Vendor | `vendor@demo.com` | `Vendor@123` |

## ⚠️ Production Notes

1. **Change demo passwords** before production
2. **Enable email confirmation** in Auth settings
3. **Configure phone auth** if needed for vendor onboarding
4. **Set up database backups** in Supabase dashboard
5. **Monitor** using Supabase Logs

---

Built for **Nextgen Organics** 🌿
