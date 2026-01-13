-- =============================================
-- 🌿 NEXTGEN ORGANICS - COMPLETE BACKEND SETUP
-- Run this file STEP BY STEP in Supabase SQL Editor
-- =============================================

-- =============================================
-- STEP 1: CLEANUP (Run this first to reset everything)
-- =============================================
-- WHY: Removes any old tables, functions, and types so we start fresh
-- This prevents conflicts with existing data

-- Drop triggers first
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS products_updated_at ON public.products;

-- Drop functions
DROP FUNCTION IF EXISTS public.handle_new_user();
DROP FUNCTION IF EXISTS public.update_updated_at();
DROP FUNCTION IF EXISTS public.get_user_role();
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.get_vendor_id();

-- Drop tables (order matters due to foreign keys)
DROP TABLE IF EXISTS public.admin_actions CASCADE;
DROP TABLE IF EXISTS public.stock_logs CASCADE;
DROP TABLE IF EXISTS public.products CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.vendors CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.banners CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;
DROP TABLE IF EXISTS public.manufacturers CASCADE;

-- Drop custom types
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS vendor_status CASCADE;

-- ✅ STEP 1 COMPLETE - Database is clean!
-- Click "Run" button now, then proceed to STEP 2

-- =============================================
-- STEP 2: CREATE CUSTOM TYPES (Enums)
-- =============================================
-- WHY: Enums ensure data consistency. Instead of allowing any text,
-- we restrict "role" to only be 'admin' or 'vendor'
-- This prevents typos and invalid data

-- User roles: admin (full access) or vendor (seller)
CREATE TYPE user_role AS ENUM ('admin', 'vendor');

-- Vendor approval status: pending → approved/rejected by admin
CREATE TYPE vendor_status AS ENUM ('pending', 'approved', 'rejected');

-- ✅ STEP 2 COMPLETE - Types created!

-- =============================================
-- STEP 3: CREATE TABLES
-- =============================================
-- WHY: These 6 tables store all your app data

-- TABLE 1: profiles
-- WHY: Supabase has auth.users but we can't modify it.
-- This table extends user data with app-specific info like role and name.
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  email TEXT UNIQUE,
  role user_role NOT NULL DEFAULT 'vendor',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- TABLE 2: vendors
-- WHY: Stores vendor business details. Only users with role='vendor' have a vendor record.
-- Includes approval workflow (pending → approved/rejected)
CREATE TABLE public.vendors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  shop_name TEXT NOT NULL,
  phone TEXT,
  address TEXT,
  status vendor_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT unique_vendor_per_user UNIQUE (user_id)
);

-- TABLE 3: categories  
-- WHY: Groups products (Vegetables, Fruits, Dairy, etc.)
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT true
);

-- TABLE 4: products
-- WHY: Stores vendor inventory. Each product belongs to one vendor and one category.
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_id UUID NOT NULL REFERENCES public.vendors(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  stock INTEGER DEFAULT 0 CHECK (stock >= 0),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- TABLE 5: stock_logs
-- WHY: Audit trail for stock changes. Shows investors you track everything.
CREATE TABLE public.stock_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  vendor_id UUID NOT NULL REFERENCES public.vendors(id) ON DELETE CASCADE,
  change INTEGER NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- TABLE 6: admin_actions
-- WHY: Logs what admins do (approve vendors, etc.). Builds investor confidence.
CREATE TABLE public.admin_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  target_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX idx_products_vendor_id ON public.products(vendor_id);
CREATE INDEX idx_products_category_id ON public.products(category_id);
CREATE INDEX idx_stock_logs_product_id ON public.stock_logs(product_id);

-- ✅ STEP 3 COMPLETE - All 6 tables created!

-- =============================================
-- STEP 4: CREATE TRIGGERS
-- =============================================
-- WHY: Triggers run automatically when things happen

-- TRIGGER 1: Auto-create profile when user signs up
-- WHY: When someone registers via Supabase Auth, this automatically
-- creates their profile record so they can use the app immediately
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'vendor'::user_role
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- TRIGGER 2: Auto-update "updated_at" on products
-- WHY: Automatically tracks when products were last modified
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- ✅ STEP 4 COMPLETE - Triggers active!

-- =============================================
-- STEP 5: ENABLE ROW LEVEL SECURITY (RLS)
-- =============================================
-- WHY: RLS enforces security at the database level.
-- Even if someone hacks your frontend, they can't access unauthorized data.

-- Helper functions for RLS
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS user_role AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.get_vendor_id()
RETURNS UUID AS $$
  SELECT id FROM public.vendors WHERE user_id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_actions ENABLE ROW LEVEL SECURITY;

-- =============================================
-- STEP 6: CREATE RLS POLICIES
-- =============================================
-- WHY: Policies define WHO can do WHAT
-- Admin = Full access to everything
-- Vendor = Only their own data

-- PROFILES policies
CREATE POLICY "admin_profiles_all" ON public.profiles FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "vendor_profiles_select" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "vendor_profiles_update" ON public.profiles FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- VENDORS policies
CREATE POLICY "admin_vendors_all" ON public.vendors FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "vendor_vendors_select" ON public.vendors FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "vendor_vendors_update" ON public.vendors FOR UPDATE USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "vendor_vendors_insert" ON public.vendors FOR INSERT WITH CHECK (user_id = auth.uid());

-- CATEGORIES policies
CREATE POLICY "admin_categories_all" ON public.categories FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "vendor_categories_select" ON public.categories FOR SELECT USING (auth.uid() IS NOT NULL AND is_active = true);

-- PRODUCTS policies
CREATE POLICY "admin_products_all" ON public.products FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "vendor_products_select" ON public.products FOR SELECT USING (vendor_id = public.get_vendor_id());
CREATE POLICY "vendor_products_insert" ON public.products FOR INSERT WITH CHECK (vendor_id = public.get_vendor_id());
CREATE POLICY "vendor_products_update" ON public.products FOR UPDATE USING (vendor_id = public.get_vendor_id()) WITH CHECK (vendor_id = public.get_vendor_id());
CREATE POLICY "vendor_products_delete" ON public.products FOR DELETE USING (vendor_id = public.get_vendor_id());

-- STOCK_LOGS policies
CREATE POLICY "admin_stock_logs_all" ON public.stock_logs FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "vendor_stock_logs_select" ON public.stock_logs FOR SELECT USING (vendor_id = public.get_vendor_id());
CREATE POLICY "vendor_stock_logs_insert" ON public.stock_logs FOR INSERT WITH CHECK (vendor_id = public.get_vendor_id());

-- ADMIN_ACTIONS policies (Admin only)
CREATE POLICY "admin_admin_actions_all" ON public.admin_actions FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ✅ STEP 6 COMPLETE - Security enabled!

-- =============================================
-- STEP 7: INSERT CATEGORIES
-- =============================================
-- WHY: Pre-populate categories so vendors can start adding products

INSERT INTO public.categories (name, is_active) VALUES
  ('Vegetables', true),
  ('Fruits', true),
  ('Dairy', true),
  ('Grains', true),
  ('Spices', true);

-- ✅ STEP 7 COMPLETE - Categories added!

-- =============================================
-- ✅ DATABASE SETUP COMPLETE!
-- =============================================
-- 
-- NOW DO THIS MANUALLY IN SUPABASE DASHBOARD:
-- 
-- 1. Go to Authentication → Users → Add User
-- 2. Create Admin:
--    Email: admin@demo.com
--    Password: Admin@123
-- 
-- 3. Create Vendor:
--    Email: vendor@demo.com  
--    Password: Vendor@123
--
-- 4. After creating users, run STEP 8 below
-- =============================================

-- =============================================
-- STEP 8: SET UP DEMO DATA (Run AFTER creating users above)
-- =============================================

-- Set admin role
UPDATE public.profiles SET full_name = 'Demo Admin', role = 'admin'::user_role WHERE email = 'admin@demo.com';

-- Set vendor role
UPDATE public.profiles SET full_name = 'Demo Vendor', role = 'vendor'::user_role WHERE email = 'vendor@demo.com';

-- Create vendor record
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT id, 'Demo Fresh Store', '+91 9876543210', 'Hyderabad, Telangana', 'approved'::vendor_status
FROM public.profiles WHERE email = 'vendor@demo.com'
ON CONFLICT (user_id) DO NOTHING;

-- Add demo products
DO $$
DECLARE
  v_id UUID;
  cat_veg UUID;
  cat_fruit UUID;
  cat_dairy UUID;
BEGIN
  SELECT id INTO v_id FROM public.vendors WHERE shop_name = 'Demo Fresh Store';
  SELECT id INTO cat_veg FROM public.categories WHERE name = 'Vegetables';
  SELECT id INTO cat_fruit FROM public.categories WHERE name = 'Fruits';
  SELECT id INTO cat_dairy FROM public.categories WHERE name = 'Dairy';

  IF v_id IS NOT NULL THEN
    INSERT INTO public.products (vendor_id, category_id, name, description, price, stock) VALUES
      (v_id, cat_veg, 'Organic Tomatoes', 'Farm-fresh desi tomatoes', 52.00, 150),
      (v_id, cat_veg, 'Fresh Spinach', 'Iron-rich palak leaves', 25.00, 120),
      (v_id, cat_fruit, 'Fresh Bananas', 'Sweet elaichi kela', 45.00, 200),
      (v_id, cat_dairy, 'Pure Desi Ghee', 'A2 cow ghee, bilona method', 599.00, 50);
  END IF;
END $$;

-- ✅ STEP 8 COMPLETE - Demo data added!

-- =============================================
-- 🎉 ALL DONE! YOUR BACKEND IS READY!
-- =============================================
-- 
-- Summary of what we created:
-- ┌─────────────────┬────────────────────────────────────┐
-- │ Table           │ Purpose                            │
-- ├─────────────────┼────────────────────────────────────┤
-- │ profiles        │ User data (name, role, active)     │
-- │ vendors         │ Vendor shops with approval status  │
-- │ categories      │ Product categories                 │
-- │ products        │ Vendor inventory                   │
-- │ stock_logs      │ Stock change audit trail           │
-- │ admin_actions   │ Admin activity log                 │
-- └─────────────────┴────────────────────────────────────┘
--
-- Demo Credentials:
-- Admin: admin@demo.com / Admin@123
-- Vendor: vendor@demo.com / Vendor@123
-- =============================================
