-- =============================================
-- 📦 DATABASE SCHEMA (Supabase / PostgreSQL)
-- Production-Ready Multi-Platform Backend
-- =============================================

-- =============================================
-- 1️⃣ PROFILES (Extends auth.users)
-- =============================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  email TEXT UNIQUE,
  role user_role NOT NULL DEFAULT 'vendor',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.profiles IS 'Application-specific user data extending Supabase Auth';
COMMENT ON COLUMN public.profiles.role IS 'User role: admin or vendor';
COMMENT ON COLUMN public.profiles.is_active IS 'Soft delete flag for user accounts';

-- =============================================
-- 2️⃣ VENDORS (Business Information)
-- =============================================
CREATE TABLE IF NOT EXISTS public.vendors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  shop_name TEXT NOT NULL,
  phone TEXT,
  address TEXT,
  status vendor_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Ensure one vendor record per user
  CONSTRAINT unique_vendor_per_user UNIQUE (user_id)
);

COMMENT ON TABLE public.vendors IS 'Vendor business information with approval workflow';
COMMENT ON COLUMN public.vendors.status IS 'Approval status: pending, approved, or rejected';

-- =============================================
-- 3️⃣ CATEGORIES (Product Grouping)
-- =============================================
CREATE TABLE IF NOT EXISTS public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT true
);

COMMENT ON TABLE public.categories IS 'Product categories for organizing inventory';

-- =============================================
-- 4️⃣ PRODUCTS (Vendor Inventory)
-- =============================================
CREATE TABLE IF NOT EXISTS public.products (
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

COMMENT ON TABLE public.products IS 'Vendor-owned products with inventory tracking';
COMMENT ON COLUMN public.products.price IS 'Product price in INR';
COMMENT ON COLUMN public.products.stock IS 'Current stock quantity';

-- Create index for faster vendor product lookups
CREATE INDEX IF NOT EXISTS idx_products_vendor_id ON public.products(vendor_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products(category_id);

-- =============================================
-- 5️⃣ STOCK LOGS (Audit Trail)
-- =============================================
CREATE TABLE IF NOT EXISTS public.stock_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  vendor_id UUID NOT NULL REFERENCES public.vendors(id) ON DELETE CASCADE,
  change INTEGER NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.stock_logs IS 'Stock change history for audit and tracking';
COMMENT ON COLUMN public.stock_logs.change IS 'Positive for additions, negative for deductions';

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_stock_logs_product_id ON public.stock_logs(product_id);
CREATE INDEX IF NOT EXISTS idx_stock_logs_vendor_id ON public.stock_logs(vendor_id);

-- =============================================
-- 6️⃣ ADMIN ACTIONS (Admin Audit Log)
-- =============================================
CREATE TABLE IF NOT EXISTS public.admin_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  target_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.admin_actions IS 'Admin operation audit log for investor confidence';
COMMENT ON COLUMN public.admin_actions.action IS 'Description of admin action performed';
COMMENT ON COLUMN public.admin_actions.target_id IS 'ID of the affected entity (vendor, product, etc.)';

-- Create index for faster admin history lookups
CREATE INDEX IF NOT EXISTS idx_admin_actions_admin_id ON public.admin_actions(admin_id);

-- =============================================
-- 🔄 TRIGGERS
-- =============================================

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(
      NULLIF(NEW.raw_user_meta_data->>'role', '')::user_role,
      'vendor'::user_role
    )
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if exists and recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Auto-update updated_at on product changes
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS products_updated_at ON public.products;
CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- =============================================
-- ✅ Schema created successfully
-- =============================================
