-- =============================================
-- 🌍 PUBLIC ACCESS POLICIES (Customer App Support)
-- Enable read access for anonymous/authenticated users
-- =============================================

-- 1️⃣ PRODUCTS: Allow public to see active products
CREATE POLICY "public_products_select" ON public.products
  FOR SELECT
  USING (is_active = true);

-- 2️⃣ CATEGORIES: Allow public to see active categories
CREATE POLICY "public_categories_select" ON public.categories
  FOR SELECT
  USING (is_active = true);

-- 3️⃣ VENDORS: Allow public to see approved vendors
CREATE POLICY "public_vendors_select" ON public.vendors
  FOR SELECT
  USING (status = 'approved');

-- =============================================
-- ✅ Public access policies created
-- =============================================
