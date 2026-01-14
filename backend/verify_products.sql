-- Quick verification: Count products in database
SELECT COUNT(*) as total_products FROM public.products;

-- Count products per vendor
SELECT 
  v.shop_name,
  COUNT(p.id) as product_count
FROM public.vendors v
LEFT JOIN public.products p ON p.vendor_id = v.id
GROUP BY v.shop_name, v.id
ORDER BY v.shop_name;

-- Count products per category
SELECT 
  c.name as category,
  COUNT(p.id) as product_count
FROM public.categories c
LEFT JOIN public.products p ON p.category_id = c.id
GROUP BY c.name
ORDER BY c.name;
