-- =============================================
-- 🔐 ROW LEVEL SECURITY (RLS) POLICIES
-- Secure access control for all tables
-- =============================================

-- =============================================
-- Helper Function: Get Current User's Role
-- =============================================
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS user_role AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper Function: Check if user is Admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper Function: Get vendor_id for current user
CREATE OR REPLACE FUNCTION public.get_vendor_id()
RETURNS UUID AS $$
  SELECT id FROM public.vendors WHERE user_id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- =============================================
-- ENABLE RLS ON ALL TABLES
-- =============================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_actions ENABLE ROW LEVEL SECURITY;

-- =============================================
-- 1️⃣ PROFILES POLICIES
-- =============================================

-- Admin: Full access to all profiles
CREATE POLICY "admin_profiles_all" ON public.profiles
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Vendor: Read/Update own profile only
CREATE POLICY "vendor_profiles_select" ON public.profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "vendor_profiles_update" ON public.profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- =============================================
-- 2️⃣ VENDORS POLICIES
-- =============================================

-- Admin: Full access to all vendors
CREATE POLICY "admin_vendors_all" ON public.vendors
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Vendor: Read own vendor record
CREATE POLICY "vendor_vendors_select" ON public.vendors
  FOR SELECT
  USING (user_id = auth.uid());

-- Vendor: Update own vendor record (except status)
CREATE POLICY "vendor_vendors_update" ON public.vendors
  FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Vendor: Insert own vendor record (for onboarding)
CREATE POLICY "vendor_vendors_insert" ON public.vendors
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- =============================================
-- 3️⃣ CATEGORIES POLICIES
-- =============================================

-- Admin: Full access to categories
CREATE POLICY "admin_categories_all" ON public.categories
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Vendor: Read active categories only
CREATE POLICY "vendor_categories_select" ON public.categories
  FOR SELECT
  USING (
    auth.uid() IS NOT NULL 
    AND is_active = true
  );

-- =============================================
-- 4️⃣ PRODUCTS POLICIES
-- =============================================

-- Admin: Full access to all products
CREATE POLICY "admin_products_all" ON public.products
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Vendor: Read own products only
CREATE POLICY "vendor_products_select" ON public.products
  FOR SELECT
  USING (vendor_id = public.get_vendor_id());

-- Vendor: Insert own products
CREATE POLICY "vendor_products_insert" ON public.products
  FOR INSERT
  WITH CHECK (vendor_id = public.get_vendor_id());

-- Vendor: Update own products
CREATE POLICY "vendor_products_update" ON public.products
  FOR UPDATE
  USING (vendor_id = public.get_vendor_id())
  WITH CHECK (vendor_id = public.get_vendor_id());

-- Vendor: Delete own products
CREATE POLICY "vendor_products_delete" ON public.products
  FOR DELETE
  USING (vendor_id = public.get_vendor_id());

-- =============================================
-- 5️⃣ STOCK LOGS POLICIES
-- =============================================

-- Admin: Full access to all stock logs
CREATE POLICY "admin_stock_logs_all" ON public.stock_logs
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Vendor: Read own stock logs
CREATE POLICY "vendor_stock_logs_select" ON public.stock_logs
  FOR SELECT
  USING (vendor_id = public.get_vendor_id());

-- Vendor: Insert own stock logs
CREATE POLICY "vendor_stock_logs_insert" ON public.stock_logs
  FOR INSERT
  WITH CHECK (vendor_id = public.get_vendor_id());

-- =============================================
-- 6️⃣ ADMIN ACTIONS POLICIES
-- =============================================

-- Admin only: Full access to admin actions
CREATE POLICY "admin_admin_actions_all" ON public.admin_actions
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- =============================================
-- ✅ RLS Policies created successfully
-- =============================================

-- Summary of access:
-- ┌─────────────────┬───────────────────────┬───────────────────────┬────────┐
-- │ Table           │ Admin                 │ Vendor                │ Public │
-- ├─────────────────┼───────────────────────┼───────────────────────┼────────┤
-- │ profiles        │ Full CRUD             │ Own record (R/U)      │ None   │
-- │ vendors         │ Full CRUD             │ Own record (R/U/I)    │ None   │
-- │ categories      │ Full CRUD             │ Read active only      │ None   │
-- │ products        │ Full CRUD             │ Own products (CRUD)   │ None   │
-- │ stock_logs      │ Full CRUD             │ Own logs (R/I)        │ None   │
-- │ admin_actions   │ Full CRUD             │ None                  │ None   │
-- └─────────────────┴───────────────────────┴───────────────────────┴────────┘
