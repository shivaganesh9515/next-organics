-- ========================================
-- COMPREHENSIVE DATABASE INTEGRITY CHECK
-- Run this in Supabase SQL Editor
-- ========================================

-- 1. Product Count Per Vendor
-- Should show 50 per vendor
SELECT 
  v.shop_name, 
  v.status,
  COUNT(p.id) as product_count
FROM public.vendors v
LEFT JOIN public.products p ON p.vendor_id = v.id
GROUP BY v.shop_name, v.id, v.status
ORDER BY v.shop_name;

-- 2. Total Products Check
-- Should be 250
SELECT COUNT(*) as total_products FROM public.products;

-- 3. Check for Orphaned Products
-- Should be 0
SELECT COUNT(*) as orphaned_products
FROM public.products p
WHERE p.vendor_id NOT IN (SELECT id FROM public.vendors);

-- 4. Category Distribution
-- Should show all 5 categories with products
SELECT 
  c.name, 
  c.is_active,
  COUNT(p.id) as product_count
FROM public.categories c
LEFT JOIN public.products p ON p.category_id = c.id
GROUP BY c.name, c.is_active
ORDER BY c.name;

-- 5. Vendor Status Summary
-- Should be: 3 approved, 1 pending, 1 rejected
SELECT 
  status, 
  COUNT(*) as vendor_count,
  string_agg(shop_name, ', ') as vendors
FROM public.vendors
GROUP BY status
ORDER BY status;

-- 6. Check All Demo Accounts Exist
-- Should return 6 rows (1 admin + 5 vendors)
SELECT 
  p.email,
  p.role,
  v.shop_name,
  v.status as vendor_status
FROM public.profiles p
LEFT JOIN public.vendors v ON v.user_id = p.id
WHERE p.email LIKE '%demo.com'
ORDER BY p.role, p.email;

-- 7. Check Orders Tables Exist
-- Should return all 5 tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('customers', 'delivery_addresses', 'orders', 'order_items', 'order_status_history')
ORDER BY table_name;

-- 8. Check RLS Enabled on Orders Tables
-- Should show all 5 tables with RLS enabled
SELECT 
  tablename, 
  rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN ('customers', 'delivery_addresses', 'orders', 'order_items', 'order_status_history');

-- 9. Check Stock Integrity
-- Should return 0 (no negative stock)
SELECT COUNT(*) as negative_stock_products
FROM public.products
WHERE stock < 0;

-- 10. Check Price Integrity
-- Should return 0 (no zero/negative prices)
SELECT COUNT(*) as invalid_price_products
FROM public.products
WHERE price <= 0;
