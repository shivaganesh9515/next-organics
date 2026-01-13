-- =============================================
-- 🧪 DEMO DATA FOR INVESTOR PRESENTATION
-- Creates demo admin, vendor, categories, and products
-- =============================================

-- =============================================
-- STEP 1: CREATE DEMO USERS IN SUPABASE DASHBOARD
-- =============================================
-- 
-- Go to: Supabase Dashboard → Authentication → Users → Add User
-- 
-- ┌──────────────────────┬────────────┬─────────┐
-- │ Email                │ Password   │ Role    │
-- ├──────────────────────┼────────────┼─────────┤
-- │ admin@demo.com       │ Admin@123  │ admin   │
-- │ vendor@demo.com      │ Vendor@123 │ vendor  │
-- └──────────────────────┴────────────┴─────────┘
--
-- IMPORTANT: After creating users, run this SQL file to set up roles and data
-- =============================================

-- =============================================
-- STEP 2: UPDATE DEMO PROFILES
-- =============================================

-- Set admin role for demo admin
UPDATE public.profiles 
SET 
  full_name = 'Demo Admin',
  role = 'admin'::user_role
WHERE email = 'admin@demo.com';

-- Set vendor role for demo vendor
UPDATE public.profiles 
SET 
  full_name = 'Demo Vendor',
  role = 'vendor'::user_role
WHERE email = 'vendor@demo.com';

-- =============================================
-- STEP 3: CREATE DEMO VENDOR RECORD
-- =============================================

-- Insert demo vendor with approved status
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT 
  id,
  'Demo Fresh Store',
  '+91 9876543210',
  '123 Organic Lane, Hyderabad, Telangana 500001',
  'approved'::vendor_status
FROM public.profiles 
WHERE email = 'vendor@demo.com'
ON CONFLICT (user_id) DO UPDATE SET
  shop_name = EXCLUDED.shop_name,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  status = EXCLUDED.status;

-- =============================================
-- STEP 4: CREATE CATEGORIES
-- =============================================

INSERT INTO public.categories (name, is_active) VALUES
  ('Vegetables', true),
  ('Fruits', true),
  ('Dairy', true),
  ('Grains', true),
  ('Spices', true)
ON CONFLICT (name) DO NOTHING;

-- =============================================
-- STEP 5: CREATE DEMO PRODUCTS
-- =============================================

-- Get vendor and category IDs
DO $$
DECLARE
  demo_vendor_id UUID;
  cat_vegetables UUID;
  cat_fruits UUID;
  cat_dairy UUID;
  cat_grains UUID;
  cat_spices UUID;
BEGIN
  -- Get demo vendor ID
  SELECT v.id INTO demo_vendor_id
  FROM public.vendors v
  JOIN public.profiles p ON v.user_id = p.id
  WHERE p.email = 'vendor@demo.com';

  -- Get category IDs
  SELECT id INTO cat_vegetables FROM public.categories WHERE name = 'Vegetables';
  SELECT id INTO cat_fruits FROM public.categories WHERE name = 'Fruits';
  SELECT id INTO cat_dairy FROM public.categories WHERE name = 'Dairy';
  SELECT id INTO cat_grains FROM public.categories WHERE name = 'Grains';
  SELECT id INTO cat_spices FROM public.categories WHERE name = 'Spices';

  -- Only insert if demo vendor exists
  IF demo_vendor_id IS NOT NULL THEN
    -- Insert demo products
    INSERT INTO public.products (vendor_id, category_id, name, description, price, stock, is_active) VALUES
    -- Vegetables
    (demo_vendor_id, cat_vegetables, 'Organic Tomatoes', 'Farm-fresh desi tomatoes, pesticide-free. Hand-picked from local organic farms.', 52.00, 150, true),
    (demo_vendor_id, cat_vegetables, 'Fresh Spinach', 'Palak leaves, iron-rich superfood. Perfect for smoothies and cooking.', 25.00, 120, true),
    (demo_vendor_id, cat_vegetables, 'Organic Carrots', 'Crunchy orange carrots, vitamin A rich. Great for salads and juices.', 45.00, 180, true),
    
    -- Fruits
    (demo_vendor_id, cat_fruits, 'Fresh Bananas', 'Elaichi kela, sweet & ripe. High in potassium and natural energy.', 45.00, 200, true),
    (demo_vendor_id, cat_fruits, 'Organic Alphonso Mango', 'King of fruits from Ratnagiri. Premium quality, naturally ripened.', 399.00, 50, true),
    (demo_vendor_id, cat_fruits, 'Fresh Pomegranate', 'Anaar with ruby red seeds. Rich in antioxidants.', 160.00, 80, true),
    
    -- Dairy
    (demo_vendor_id, cat_dairy, 'Pure Desi Ghee', 'A2 cow ghee made using traditional bilona method. Premium quality.', 599.00, 50, true),
    (demo_vendor_id, cat_dairy, 'Organic Paneer', 'Fresh cottage cheese made from organic milk. High in protein.', 280.00, 80, true),
    (demo_vendor_id, cat_dairy, 'Farm Fresh Milk', 'A2 cow milk, unhomogenized. Delivered fresh daily.', 70.00, 100, true),
    
    -- Grains
    (demo_vendor_id, cat_grains, 'Organic Basmati Rice', 'Aged 2 years for extra aroma. Premium long grain variety.', 160.00, 200, true),
    (demo_vendor_id, cat_grains, 'Organic Toor Dal', 'Arhar dal, protein-rich. Essential for daily cooking.', 140.00, 200, true),
    
    -- Spices
    (demo_vendor_id, cat_spices, 'Organic Turmeric Powder', 'Haldi with high curcumin content. Immunity booster.', 100.00, 200, true)
    ON CONFLICT DO NOTHING;

    -- =============================================
    -- STEP 6: CREATE SAMPLE STOCK LOGS
    -- =============================================
    INSERT INTO public.stock_logs (product_id, vendor_id, change, reason)
    SELECT 
      p.id,
      demo_vendor_id,
      p.stock,
      'Initial stock entry'
    FROM public.products p
    WHERE p.vendor_id = demo_vendor_id;

    RAISE NOTICE '✅ Demo data created successfully!';
  ELSE
    RAISE NOTICE '⚠️ Demo vendor not found. Please create vendor@demo.com user first.';
  END IF;
END $$;

-- =============================================
-- STEP 7: LOG ADMIN ACTIONS (DEMO)
-- =============================================

INSERT INTO public.admin_actions (admin_id, action, target_id)
SELECT 
  p.id,
  'Approved vendor: Demo Fresh Store',
  v.id
FROM public.profiles p
CROSS JOIN public.vendors v
WHERE p.email = 'admin@demo.com'
AND EXISTS (
  SELECT 1 FROM public.profiles vp 
  WHERE vp.email = 'vendor@demo.com' AND v.user_id = vp.id
);

-- =============================================
-- ✅ Demo data setup complete!
-- =============================================

-- Quick verification queries:
-- SELECT * FROM public.profiles;
-- SELECT * FROM public.vendors;
-- SELECT * FROM public.categories;
-- SELECT * FROM public.products;
-- SELECT * FROM public.stock_logs;
-- SELECT * FROM public.admin_actions;
