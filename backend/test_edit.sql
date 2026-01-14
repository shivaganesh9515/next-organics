-- Test query to verify a product exists and can be edited
-- Run this to check if there are products to edit

SELECT 
  p.id,
  p.name,
  p.vendor_id,
  v.shop_name,
  v.user_id
FROM public.products p
JOIN public.vendors v ON p.vendor_id = v.id
WHERE p.vendor_id IN (SELECT id FROM public.vendors WHERE user_id IN (
  SELECT id FROM public.profiles WHERE email = 'vendor1@demo.com'
))
LIMIT 5;
