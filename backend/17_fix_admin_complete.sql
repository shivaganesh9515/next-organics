-- =============================================
-- 🛠️ FIX ADMIN ROLE & RELOAD DEMO DATA
-- =============================================

-- 1️⃣ FIX ADMIN ROLE
-- Ensure the admin user has the correct role
UPDATE public.profiles
SET role = 'admin'
WHERE email = 'admin@nextorganics.com'; -- Change this if your email is different

-- 2️⃣ ENSURE RLS POLICIES FOR ADMIN
-- If RLS is enabled, Admins need permission to see everything
-- We'll enable RLS to be safe and add the policies

ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Admin Policy: Full Access to Vendors
DROP POLICY IF EXISTS "Admin Full Access Vendors" ON public.vendors;
CREATE POLICY "Admin Full Access Vendors" ON public.vendors
  FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Admin Policy: Full Access to Products
DROP POLICY IF EXISTS "Admin Full Access Products" ON public.products;
CREATE POLICY "Admin Full Access Products" ON public.products
  FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- 3️⃣ RELOAD DEMO DATA (Idempotent)
-- We will insert or update the demo vendor and products

DO $$
DECLARE
  v_user_id UUID;
  v_vendor_id UUID;
  c_veg UUID;
  c_fruit UUID;
  c_dairy UUID;
  c_grain UUID;
  c_spice UUID;
BEGIN
  -- Get User ID for 'admin@nextorganics.com' (or update to your test email)
  SELECT id INTO v_user_id FROM auth.users WHERE email = 'admin@nextorganics.com';

  -- If user doesn't exist, we can't create them here (must use Auth API), but we can skip
  IF v_user_id IS NOT NULL THEN
    
    -- Create Vendor Profile for this user (if they want to be a vendor/admin hybrid or just for demo)
    -- Actually, let's create a SEPARATE demo vendor user if possible, or link to admin for simplicity
    -- For now, let's assume 'admin@nextorganics.com' acts as the vendor "Nextgen Farm"
    
    INSERT INTO public.vendors (user_id, shop_name, status, address, phone)
    VALUES (v_user_id, 'Nextgen Farm Hub', 'approved', '123 Admin Road', '9998887776')
    ON CONFLICT (user_id) DO UPDATE SET status = 'approved'
    RETURNING id INTO v_vendor_id;

    -- Create Categories
    INSERT INTO public.categories (name) VALUES 
      ('Vegetables'), ('Fruits'), ('Dairy'), ('Grains'), ('Spices')
    ON CONFLICT (name) DO UPDATE SET is_active = true;

    SELECT id INTO c_veg FROM public.categories WHERE name = 'Vegetables';
    SELECT id INTO c_fruit FROM public.categories WHERE name = 'Fruits';

    -- Insert Products (Upsert by name usually not possible if no unique constrain, so we delete duplicates or just insert)
    -- We'll just insert sample if empty
    
    IF NOT EXISTS (SELECT 1 FROM public.products WHERE vendor_id = v_vendor_id) THEN
       INSERT INTO public.products (vendor_id, category_id, name, price, stock, is_active, image_url, description) VALUES
       (v_vendor_id, c_veg, 'Organic Tomatoes', 50, 100, true, 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500', 'Fresh red tomatoes'),
       (v_vendor_id, c_veg, 'Potatoes', 30, 200, true, 'https://images.unsplash.com/photo-1518977676641-8f396102dbd9?w=500', 'Organic potatoes'),
       (v_vendor_id, c_fruit, 'Bananas', 40, 50, true, 'https://images.unsplash.com/photo-1603833665858-e61d17a8622e?w=500', 'Sweet bananas');
    END IF;
    
  END IF;
END $$;
