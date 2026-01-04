-- =============================================
-- 🌿 NEXTGEN ORGANICS - SEED DATA (Hyderabad)
-- 15 Vendors | 750 Products | Indian Pricing
-- =============================================

-- STEP 1: RUN THIS AFTER supabase_schema.sql

-- =============================================
-- 🏪 MANUFACTURERS (15 Hyderabad Organic Vendors)
-- =============================================

INSERT INTO public.manufacturers (name, slug, logo_url, rating, is_verified) VALUES
('Green Valley Organics', 'green-valley-organics', 'https://ui-avatars.com/api/?name=GV&background=22c55e&color=fff', 4.8, true),
('Telangana Fresh Farms', 'telangana-fresh-farms', 'https://ui-avatars.com/api/?name=TF&background=16a34a&color=fff', 4.9, true),
('Deccan Harvest', 'deccan-harvest', 'https://ui-avatars.com/api/?name=DH&background=15803d&color=fff', 4.7, true),
('Nizamabad Naturals', 'nizamabad-naturals', 'https://ui-avatars.com/api/?name=NN&background=166534&color=fff', 4.6, true),
('Secunderabad Greens', 'secunderabad-greens', 'https://ui-avatars.com/api/?name=SG&background=14532d&color=fff', 4.5, true),
('Karimnagar Krishi', 'karimnagar-krishi', 'https://ui-avatars.com/api/?name=KK&background=84cc16&color=fff', 4.8, true),
('Warangal Wellness', 'warangal-wellness', 'https://ui-avatars.com/api/?name=WW&background=65a30d&color=fff', 4.4, true),
('Medak Meadows', 'medak-meadows', 'https://ui-avatars.com/api/?name=MM&background=4d7c0f&color=fff', 4.7, true),
('Adilabad Agro', 'adilabad-agro', 'https://ui-avatars.com/api/?name=AA&background=3f6212&color=fff', 4.6, true),
('Khammam Kisan', 'khammam-kisan', 'https://ui-avatars.com/api/?name=KS&background=365314&color=fff', 4.5, true),
('Nalgonda Nature', 'nalgonda-nature', 'https://ui-avatars.com/api/?name=NA&background=22c55e&color=fff', 4.8, true),
('Mahbubnagar Millets', 'mahbubnagar-millets', 'https://ui-avatars.com/api/?name=MB&background=16a34a&color=fff', 4.9, true),
('Rangareddy Roots', 'rangareddy-roots', 'https://ui-avatars.com/api/?name=RR&background=15803d&color=fff', 4.7, true),
('Hyderabad Herbals', 'hyderabad-herbals', 'https://ui-avatars.com/api/?name=HH&background=166534&color=fff', 4.6, true),
('Banjara Hills Bio', 'banjara-hills-bio', 'https://ui-avatars.com/api/?name=BB&background=14532d&color=fff', 4.8, true);

-- =============================================
-- 🥬 PRODUCTS (50 per Vendor = 750 Total)
-- =============================================

-- Helper: Get Manufacturer IDs
DO $$
DECLARE
  v1 uuid; v2 uuid; v3 uuid; v4 uuid; v5 uuid;
  v6 uuid; v7 uuid; v8 uuid; v9 uuid; v10 uuid;
  v11 uuid; v12 uuid; v13 uuid; v14 uuid; v15 uuid;
BEGIN
  SELECT id INTO v1 FROM public.manufacturers WHERE slug = 'green-valley-organics';
  SELECT id INTO v2 FROM public.manufacturers WHERE slug = 'telangana-fresh-farms';
  SELECT id INTO v3 FROM public.manufacturers WHERE slug = 'deccan-harvest';
  SELECT id INTO v4 FROM public.manufacturers WHERE slug = 'nizamabad-naturals';
  SELECT id INTO v5 FROM public.manufacturers WHERE slug = 'secunderabad-greens';
  SELECT id INTO v6 FROM public.manufacturers WHERE slug = 'karimnagar-krishi';
  SELECT id INTO v7 FROM public.manufacturers WHERE slug = 'warangal-wellness';
  SELECT id INTO v8 FROM public.manufacturers WHERE slug = 'medak-meadows';
  SELECT id INTO v9 FROM public.manufacturers WHERE slug = 'adilabad-agro';
  SELECT id INTO v10 FROM public.manufacturers WHERE slug = 'khammam-kisan';
  SELECT id INTO v11 FROM public.manufacturers WHERE slug = 'nalgonda-nature';
  SELECT id INTO v12 FROM public.manufacturers WHERE slug = 'mahbubnagar-millets';
  SELECT id INTO v13 FROM public.manufacturers WHERE slug = 'rangareddy-roots';
  SELECT id INTO v14 FROM public.manufacturers WHERE slug = 'hyderabad-herbals';
  SELECT id INTO v15 FROM public.manufacturers WHERE slug = 'banjara-hills-bio';

  -- =============================================
  -- VENDOR 1: Green Valley Organics (50 Products)
  -- =============================================
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags) VALUES
  (v1, 'Organic Tomatoes', 'Farm-fresh desi tomatoes, pesticide-free', 'https://images.unsplash.com/photo-1546470427-0d4db154cdf8?w=400', 'vegetables', 60.00, 52.00, 150, ARRAY['organic', 'local']),
  (v1, 'Green Chillies', 'Spicy Guntur variety, chemical-free', 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=400', 'vegetables', 40.00, 35.00, 200, ARRAY['organic', 'spicy']),
  (v1, 'Organic Onions', 'Sweet Nashik onions, naturally grown', 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400', 'vegetables', 45.00, 40.00, 300, ARRAY['organic', 'essential']),
  (v1, 'Fresh Potatoes', 'Himalayan potatoes, no chemicals', 'https://images.unsplash.com/photo-1518977676601-b53f82ber9eb?w=400', 'vegetables', 35.00, 30.00, 250, ARRAY['organic', 'staple']),
  (v1, 'Organic Carrots', 'Crunchy orange carrots, vitamin-rich', 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400', 'vegetables', 50.00, 45.00, 180, ARRAY['organic', 'healthy']),
  (v1, 'Fresh Spinach', 'Palak leaves, iron-rich superfood', 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400', 'vegetables', 30.00, 25.00, 120, ARRAY['organic', 'leafy']),
  (v1, 'Organic Cauliflower', 'White gobhi, pesticide-free', 'https://images.unsplash.com/photo-1568584711075-3d021a7c3ca3?w=400', 'vegetables', 55.00, 48.00, 100, ARRAY['organic', 'winter']),
  (v1, 'Fresh Cabbage', 'Green patta gobhi, farm fresh', 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400', 'vegetables', 40.00, 35.00, 150, ARRAY['organic', 'salad']),
  (v1, 'Organic Brinjal', 'Purple baingan, chemical-free', 'https://images.unsplash.com/photo-1615484477778-ca3b77940c25?w=400', 'vegetables', 45.00, 40.00, 200, ARRAY['organic', 'curry']),
  (v1, 'Fresh Capsicum', 'Green shimla mirch, crunchy', 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400', 'vegetables', 80.00, 70.00, 100, ARRAY['organic', 'vitamin-c']),
  (v1, 'Organic Cucumber', 'Kheera, hydrating & fresh', 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=400', 'vegetables', 35.00, 30.00, 180, ARRAY['organic', 'summer']),
  (v1, 'Fresh Bitter Gourd', 'Karela, diabetes-friendly', 'https://images.unsplash.com/photo-1604149456774-2e5fb5e9e6a8?w=400', 'vegetables', 50.00, 45.00, 120, ARRAY['organic', 'medicinal']),
  (v1, 'Organic Bottle Gourd', 'Lauki, light & healthy', 'https://images.unsplash.com/photo-1622205313162-be1d5712a43f?w=400', 'vegetables', 40.00, 35.00, 150, ARRAY['organic', 'diet']),
  (v1, 'Fresh Pumpkin', 'Kaddu, sweet & nutritious', 'https://images.unsplash.com/photo-1509622905150-fa66d3906e09?w=400', 'vegetables', 35.00, 30.00, 100, ARRAY['organic', 'winter']),
  (v1, 'Organic Drumsticks', 'Moringa, superfood pods', 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400', 'vegetables', 60.00, 55.00, 80, ARRAY['organic', 'superfood']),
  (v1, 'Fresh Green Peas', 'Matar, winter special', 'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400', 'vegetables', 80.00, 70.00, 100, ARRAY['organic', 'protein']),
  (v1, 'Organic Lady Finger', 'Bhindi, tender & fresh', 'https://images.unsplash.com/photo-1604461513807-9f07c80a06b6?w=400', 'vegetables', 50.00, 45.00, 200, ARRAY['organic', 'fiber']),
  (v1, 'Fresh Radish', 'Mooli, white & crunchy', 'https://images.unsplash.com/photo-1558678500-90b5c10ca1a6?w=400', 'vegetables', 30.00, 25.00, 150, ARRAY['organic', 'salad']),
  (v1, 'Organic Beetroot', 'Chukandar, blood builder', 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=400', 'vegetables', 45.00, 40.00, 120, ARRAY['organic', 'iron']),
  (v1, 'Fresh Coriander', 'Dhania leaves, aromatic', 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400', 'vegetables', 20.00, 15.00, 300, ARRAY['organic', 'herb']),
  (v1, 'Organic Mint Leaves', 'Pudina, cooling herb', 'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?w=400', 'vegetables', 25.00, 20.00, 250, ARRAY['organic', 'herb']),
  (v1, 'Organic Alphonso Mango', 'King of fruits, Ratnagiri', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400', 'fruits', 450.00, 399.00, 50, ARRAY['organic', 'premium', 'seasonal']),
  (v1, 'Fresh Bananas', 'Elaichi kela, sweet & ripe', 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400', 'fruits', 50.00, 45.00, 200, ARRAY['organic', 'energy']),
  (v1, 'Organic Papaya', 'Red lady papaya, digestive', 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?w=400', 'fruits', 60.00, 50.00, 100, ARRAY['organic', 'enzyme']),
  (v1, 'Fresh Pomegranate', 'Anaar, ruby red seeds', 'https://images.unsplash.com/photo-1541344999736-83eca272f6fc?w=400', 'fruits', 180.00, 160.00, 80, ARRAY['organic', 'antioxidant']),
  (v1, 'Organic Guava', 'Amrood, vitamin C rich', 'https://images.unsplash.com/photo-1536511132770-e5058c7e8c46?w=400', 'fruits', 70.00, 60.00, 150, ARRAY['organic', 'immunity']),
  (v1, 'Fresh Watermelon', 'Tarbooz, summer cooler', 'https://images.unsplash.com/photo-1563114773-84221bd62daa?w=400', 'fruits', 40.00, 35.00, 50, ARRAY['organic', 'hydrating']),
  (v1, 'Organic Sweet Lime', 'Mosambi, refreshing', 'https://images.unsplash.com/photo-1582979512210-99b6a53386f9?w=400', 'fruits', 80.00, 70.00, 120, ARRAY['organic', 'citrus']),
  (v1, 'Fresh Apple', 'Kashmir apple, red delicious', 'https://images.unsplash.com/photo-1619546813926-a78fa6372cd2?w=400', 'fruits', 180.00, 160.00, 100, ARRAY['organic', 'imported']),
  (v1, 'Organic Orange', 'Nagpur santra, juicy', 'https://images.unsplash.com/photo-1582979512210-99b6a53386f9?w=400', 'fruits', 90.00, 80.00, 150, ARRAY['organic', 'citrus']),
  (v1, 'Fresh Grapes', 'Nashik green grapes', 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400', 'fruits', 120.00, 100.00, 80, ARRAY['organic', 'antioxidant']),
  (v1, 'Organic Basmati Rice', 'Aged 2 years, aromatic', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'grains', 180.00, 160.00, 200, ARRAY['organic', 'premium']),
  (v1, 'Brown Rice', 'Unpolished, fiber-rich', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'grains', 120.00, 100.00, 150, ARRAY['organic', 'healthy']),
  (v1, 'Organic Wheat Flour', 'Chakki atta, whole grain', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 65.00, 55.00, 300, ARRAY['organic', 'staple']),
  (v1, 'Organic Toor Dal', 'Arhar dal, protein-rich', 'https://images.unsplash.com/photo-1585996746342-a2a6f5bb2b8f?w=400', 'grains', 160.00, 140.00, 200, ARRAY['organic', 'protein']),
  (v1, 'Organic Moong Dal', 'Yellow split, easy digest', 'https://images.unsplash.com/photo-1585996746342-a2a6f5bb2b8f?w=400', 'grains', 140.00, 120.00, 180, ARRAY['organic', 'light']),
  (v1, 'Organic Chana Dal', 'Bengal gram, versatile', 'https://images.unsplash.com/photo-1585996746342-a2a6f5bb2b8f?w=400', 'grains', 130.00, 110.00, 200, ARRAY['organic', 'fiber']),
  (v1, 'Organic Masoor Dal', 'Red lentils, quick cook', 'https://images.unsplash.com/photo-1585996746342-a2a6f5bb2b8f?w=400', 'grains', 120.00, 100.00, 150, ARRAY['organic', 'iron']),
  (v1, 'Organic Urad Dal', 'Black gram, for idli/dosa', 'https://images.unsplash.com/photo-1585996746342-a2a6f5bb2b8f?w=400', 'grains', 150.00, 130.00, 180, ARRAY['organic', 'south-indian']),
  (v1, 'Organic Ragi Flour', 'Finger millet, calcium-rich', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 80.00, 70.00, 120, ARRAY['organic', 'millet']),
  (v1, 'Organic Jowar Flour', 'Sorghum, gluten-free', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 75.00, 65.00, 100, ARRAY['organic', 'millet']),
  (v1, 'Pure Desi Ghee', 'A2 cow ghee, bilona method', 'https://images.unsplash.com/photo-1600271772470-bd22a42787b3?w=400', 'dairy', 650.00, 599.00, 50, ARRAY['organic', 'premium', 'a2']),
  (v1, 'Organic Paneer', 'Fresh cottage cheese', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400', 'dairy', 320.00, 280.00, 80, ARRAY['organic', 'protein']),
  (v1, 'Farm Fresh Milk', 'A2 cow milk, unhomogenized', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400', 'dairy', 80.00, 70.00, 100, ARRAY['organic', 'daily']),
  (v1, 'Organic Curd', 'Probiotic dahi, set curd', 'https://images.unsplash.com/photo-1571212515416-fef01fc43637?w=400', 'dairy', 60.00, 50.00, 120, ARRAY['organic', 'probiotic']),
  (v1, 'Pure Wild Honey', 'Forest honey, unprocessed', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400', 'essentials', 450.00, 399.00, 60, ARRAY['organic', 'raw', 'immunity']),
  (v1, 'Organic Jaggery', 'Gur, iron-rich sweetener', 'https://images.unsplash.com/photo-1604568349831-8f8a19c51f09?w=400', 'essentials', 80.00, 70.00, 150, ARRAY['organic', 'natural']),
  (v1, 'Cold Pressed Groundnut Oil', 'Kachi ghani, pure', 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400', 'essentials', 280.00, 250.00, 80, ARRAY['organic', 'cooking']),
  (v1, 'Organic Turmeric Powder', 'Haldi, high curcumin', 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400', 'spices', 120.00, 100.00, 200, ARRAY['organic', 'immunity']),
  (v1, 'Organic Red Chilli Powder', 'Guntur mirchi, spicy', 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400', 'spices', 150.00, 130.00, 150, ARRAY['organic', 'spice']);

  -- =============================================
  -- VENDOR 2: Telangana Fresh Farms (50 Products)
  -- =============================================
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags) VALUES
  (v2, 'Farm Fresh Tomatoes', 'Vine-ripened, juicy', 'https://images.unsplash.com/photo-1546470427-0d4db154cdf8?w=400', 'vegetables', 55.00, 48.00, 180, ARRAY['organic', 'fresh']),
  (v2, 'Organic Ginger', 'Adrak, aromatic', 'https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=400', 'vegetables', 120.00, 100.00, 100, ARRAY['organic', 'immunity']),
  (v2, 'Fresh Garlic', 'Lehsun, pungent', 'https://images.unsplash.com/photo-1540148426945-6cf22a6b2383?w=400', 'vegetables', 200.00, 180.00, 80, ARRAY['organic', 'medicinal']),
  (v2, 'Organic Curry Leaves', 'Kadi patta, aromatic', 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400', 'vegetables', 30.00, 25.00, 200, ARRAY['organic', 'herb']),
  (v2, 'Fresh Methi Leaves', 'Fenugreek, bitter-sweet', 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400', 'vegetables', 35.00, 30.00, 150, ARRAY['organic', 'leafy']),
  (v2, 'Organic Snake Gourd', 'Chichinda, light', 'https://images.unsplash.com/photo-1622205313162-be1d5712a43f?w=400', 'vegetables', 45.00, 40.00, 100, ARRAY['organic', 'diet']),
  (v2, 'Fresh Ridge Gourd', 'Turai, fiber-rich', 'https://images.unsplash.com/photo-1622205313162-be1d5712a43f?w=400', 'vegetables', 40.00, 35.00, 120, ARRAY['organic', 'light']),
  (v2, 'Organic Ivy Gourd', 'Tindora, crunchy', 'https://images.unsplash.com/photo-1622205313162-be1d5712a43f?w=400', 'vegetables', 50.00, 45.00, 100, ARRAY['organic', 'diabetic-friendly']),
  (v2, 'Fresh Cluster Beans', 'Gawar phali, protein', 'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400', 'vegetables', 60.00, 55.00, 80, ARRAY['organic', 'fiber']),
  (v2, 'Organic Broad Beans', 'Sem, chunky', 'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400', 'vegetables', 70.00, 60.00, 100, ARRAY['organic', 'protein']),
  (v2, 'Fresh Spring Onion', 'Hara pyaz, mild', 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400', 'vegetables', 40.00, 35.00, 150, ARRAY['organic', 'salad']),
  (v2, 'Organic Leeks', 'Mild onion flavor', 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400', 'vegetables', 80.00, 70.00, 60, ARRAY['organic', 'gourmet']),
  (v2, 'Fresh Celery', 'Ajmoda, aromatic', 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400', 'vegetables', 90.00, 80.00, 50, ARRAY['organic', 'detox']),
  (v2, 'Organic Asparagus', 'Premium green stalks', 'https://images.unsplash.com/photo-1515471209610-dae1c92d8777?w=400', 'vegetables', 250.00, 220.00, 30, ARRAY['organic', 'premium']),
  (v2, 'Fresh Zucchini', 'Italian squash', 'https://images.unsplash.com/photo-1563252622-57f27bc4234e?w=400', 'vegetables', 120.00, 100.00, 60, ARRAY['organic', 'low-carb']),
  (v2, 'Organic Broccoli', 'Green superfood', 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400', 'vegetables', 150.00, 130.00, 80, ARRAY['organic', 'superfood']),
  (v2, 'Fresh Lettuce', 'Iceberg, crisp', 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400', 'vegetables', 80.00, 70.00, 100, ARRAY['organic', 'salad']),
  (v2, 'Organic Baby Corn', 'Tender mini cobs', 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400', 'vegetables', 100.00, 85.00, 80, ARRAY['organic', 'stir-fry']),
  (v2, 'Fresh Mushrooms', 'Button mushrooms', 'https://images.unsplash.com/photo-1552825898-84c7f08675f9?w=400', 'vegetables', 120.00, 100.00, 60, ARRAY['organic', 'protein']),
  (v2, 'Organic Sweet Corn', 'Yellow corn cobs', 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400', 'vegetables', 60.00, 50.00, 100, ARRAY['organic', 'snack']),
  (v2, 'Organic Kesar Mango', 'Gujarat special', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400', 'fruits', 350.00, 299.00, 60, ARRAY['organic', 'premium']),
  (v2, 'Fresh Chikoo', 'Sapota, super sweet', 'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400', 'fruits', 80.00, 70.00, 120, ARRAY['organic', 'energy']),
  (v2, 'Organic Custard Apple', 'Sitaphal, creamy', 'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400', 'fruits', 150.00, 130.00, 60, ARRAY['organic', 'seasonal']),
  (v2, 'Fresh Fig', 'Anjeer, fiber-rich', 'https://images.unsplash.com/photo-1601379760920-bdaa78f0c4ee?w=400', 'fruits', 200.00, 180.00, 40, ARRAY['organic', 'premium']),
  (v2, 'Organic Jamun', 'Indian blackberry', 'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400', 'fruits', 120.00, 100.00, 80, ARRAY['organic', 'diabetic-friendly']),
  (v2, 'Fresh Litchi', 'Juicy summer fruit', 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400', 'fruits', 180.00, 160.00, 50, ARRAY['organic', 'seasonal']),
  (v2, 'Organic Pear', 'Nashpati, juicy', 'https://images.unsplash.com/photo-1514756331096-242fdeb70d4a?w=400', 'fruits', 160.00, 140.00, 80, ARRAY['organic', 'fiber']),
  (v2, 'Fresh Plum', 'Aloo Bukhara, tangy', 'https://images.unsplash.com/photo-1518655048521-f130df041f66?w=400', 'fruits', 200.00, 180.00, 60, ARRAY['organic', 'antioxidant']),
  (v2, 'Organic Peach', 'Aadu, fuzzy sweet', 'https://images.unsplash.com/photo-1629226182920-f03d8f51df7b?w=400', 'fruits', 220.00, 200.00, 50, ARRAY['organic', 'summer']),
  (v2, 'Fresh Strawberry', 'Mahabaleshwar berries', 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400', 'fruits', 250.00, 220.00, 40, ARRAY['organic', 'antioxidant']),
  (v2, 'Organic Kiwi', 'New Zealand variety', 'https://images.unsplash.com/photo-1585059895524-72359e06133a?w=400', 'fruits', 280.00, 250.00, 50, ARRAY['organic', 'vitamin-c']),
  (v2, 'Organic Sona Masoori Rice', 'Telugu special', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'grains', 90.00, 80.00, 250, ARRAY['organic', 'daily']),
  (v2, 'Red Rice', 'Kerala matta rice', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'grains', 110.00, 95.00, 150, ARRAY['organic', 'fiber']),
  (v2, 'Organic Quinoa', 'Protein-rich superfood', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'grains', 350.00, 320.00, 60, ARRAY['organic', 'superfood']),
  (v2, 'Organic Bajra', 'Pearl millet', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 70.00, 60.00, 120, ARRAY['organic', 'millet']),
  (v2, 'Organic Foxtail Millet', 'Kangni, ancient grain', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 90.00, 80.00, 100, ARRAY['organic', 'millet']),
  (v2, 'Little Millet', 'Kutki, diabetic-friendly', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 85.00, 75.00, 80, ARRAY['organic', 'millet']),
  (v2, 'Barnyard Millet', 'Sanwa, fasting special', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 95.00, 85.00, 80, ARRAY['organic', 'millet']),
  (v2, 'Organic Kodo Millet', 'Kodra, gluten-free', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400', 'grains', 80.00, 70.00, 90, ARRAY['organic', 'millet']),
  (v2, 'Organic Black Rice', 'Forbidden rice, antioxidant', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400', 'grains', 280.00, 250.00, 40, ARRAY['organic', 'premium']),
  (v2, 'Buffalo Ghee', 'Rich & creamy', 'https://images.unsplash.com/photo-1600271772470-bd22a42787b3?w=400', 'dairy', 550.00, 499.00, 60, ARRAY['organic', 'traditional']),
  (v2, 'Organic Butter', 'White makhan', 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400', 'dairy', 180.00, 160.00, 80, ARRAY['organic', 'fresh']),
  (v2, 'Fresh Buttermilk', 'Chaas, cooling', 'https://images.unsplash.com/photo-1571212515416-fef01fc43637?w=400', 'dairy', 40.00, 35.00, 150, ARRAY['organic', 'probiotic']),
  (v2, 'Organic Lassi', 'Sweet yogurt drink', 'https://images.unsplash.com/photo-1571212515416-fef01fc43637?w=400', 'dairy', 50.00, 45.00, 100, ARRAY['organic', 'refreshing']),
  (v2, 'Fresh Cottage Cheese', 'Homemade chenna', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400', 'dairy', 280.00, 250.00, 60, ARRAY['organic', 'bengali']),
  (v2, 'Multifloral Honey', 'Himalayan variety', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400', 'essentials', 380.00, 349.00, 80, ARRAY['organic', 'raw']),
  (v2, 'Organic Palm Jaggery', 'Karupatti, Tamil special', 'https://images.unsplash.com/photo-1604568349831-8f8a19c51f09?w=400', 'essentials', 120.00, 100.00, 100, ARRAY['organic', 'medicinal']),
  (v2, 'Cold Pressed Coconut Oil', 'Virgin, pure', 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400', 'essentials', 320.00, 280.00, 70, ARRAY['organic', 'cooking']),
  (v2, 'Organic Coriander Powder', 'Dhania, aromatic', 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400', 'spices', 80.00, 70.00, 180, ARRAY['organic', 'spice']),
  (v2, 'Organic Cumin Seeds', 'Jeera, whole', 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400', 'spices', 180.00, 160.00, 120, ARRAY['organic', 'spice']);

  -- =============================================
  -- VENDORS 3-15: Quick Insert (Condensed for brevity)
  -- Each vendor gets 50 products with varied items
  -- =============================================
  
  -- VENDOR 3: Deccan Harvest
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v3, name || ' - DH', description, image_url, category, price_mrp * 0.95, price_final * 0.95, stock_quantity + 20, tags
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;
  
  -- VENDOR 4: Nizamabad Naturals
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v4, name || ' - NN', description, image_url, category, price_mrp * 1.02, price_final * 1.02, stock_quantity + 10, tags
  FROM public.products WHERE manufacturer_id = v2 LIMIT 50;
  
  -- VENDOR 5: Secunderabad Greens
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v5, name || ' - SG', description, image_url, category, price_mrp * 0.98, price_final * 0.98, stock_quantity + 15, tags
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;
  
  -- VENDOR 6: Karimnagar Krishi
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v6, name || ' - KK', description, image_url, category, price_mrp * 1.05, price_final * 1.05, stock_quantity, tags
  FROM public.products WHERE manufacturer_id = v2 LIMIT 50;
  
  -- VENDOR 7: Warangal Wellness
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v7, name || ' - WW', description, image_url, category, price_mrp * 0.92, price_final * 0.92, stock_quantity + 25, tags
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;
  
  -- VENDOR 8: Medak Meadows
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v8, name || ' - MM', description, image_url, category, price_mrp * 1.08, price_final * 1.08, stock_quantity - 10, tags
  FROM public.products WHERE manufacturer_id = v2 LIMIT 50;
  
  -- VENDOR 9: Adilabad Agro
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v9, name || ' - AA', description, image_url, category, price_mrp * 0.90, price_final * 0.90, stock_quantity + 30, tags
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;
  
  -- VENDOR 10: Khammam Kisan
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v10, name || ' - KS', description, image_url, category, price_mrp * 1.03, price_final * 1.03, stock_quantity + 5, tags
  FROM public.products WHERE manufacturer_id = v2 LIMIT 50;
  
  -- VENDOR 11: Nalgonda Nature
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v11, name || ' - NA', description, image_url, category, price_mrp * 0.97, price_final * 0.97, stock_quantity + 12, tags
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;
  
  -- VENDOR 12: Mahbubnagar Millets
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v12, name || ' - MB', description, image_url, category, price_mrp * 1.10, price_final * 1.10, stock_quantity, tags
  FROM public.products WHERE manufacturer_id = v2 LIMIT 50;
  
  -- VENDOR 13: Rangareddy Roots
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v13, name || ' - RR', description, image_url, category, price_mrp * 0.88, price_final * 0.88, stock_quantity + 40, tags
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;
  
  -- VENDOR 14: Hyderabad Herbals
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v14, name || ' - HH', description, image_url, category, price_mrp * 1.15, price_final * 1.15, stock_quantity - 5, tags
  FROM public.products WHERE manufacturer_id = v2 LIMIT 50;
  
  -- VENDOR 15: Banjara Hills Bio
  INSERT INTO public.products (manufacturer_id, name, description, image_url, category, price_mrp, price_final, stock_quantity, tags)
  SELECT v15, name || ' - BB', description, image_url, category, price_mrp * 1.20, price_final * 1.20, stock_quantity, ARRAY_APPEND(tags, 'premium')
  FROM public.products WHERE manufacturer_id = v1 LIMIT 50;

END $$;

-- =============================================
-- 🎨 SAMPLE BANNERS (3 Active)
-- =============================================

INSERT INTO public.banners (title, subtitle, image_url, cta_text, target_route, type, gradient_colors, is_active, priority) VALUES
('FRESH HARVEST', 'Organic & Local', 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800', 'SHOP NOW', '/category/vegetables', 'hero', ARRAY['#22c55e', '#16a34a'], true, 10),
('MANGO SEASON', 'Premium Alphonso', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=800', 'ORDER NOW', '/category/fruits', 'hero', ARRAY['#f97316', '#ea580c'], true, 9),
('MILLET REVOLUTION', 'Ancient Grains for Modern Health', 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800', 'EXPLORE', '/category/grains', 'hero', ARRAY['#eab308', '#ca8a04'], true, 8);


-- =============================================
-- 📋 VENDOR LOGIN CREDENTIALS (CREATE IN SUPABASE DASHBOARD)
-- =============================================
-- 
-- Go to Supabase Dashboard > Authentication > Users > Add User
-- Create these 15 vendor accounts manually:
--
-- | Email                      | Password      | Role   |
-- |----------------------------|---------------|--------|
-- | greenvalley@nextgen.com    | Vendor@123    | vendor |
-- | telangana@nextgen.com      | Vendor@123    | vendor |
-- | deccan@nextgen.com         | Vendor@123    | vendor |
-- | nizamabad@nextgen.com      | Vendor@123    | vendor |
-- | secunderabad@nextgen.com   | Vendor@123    | vendor |
-- | karimnagar@nextgen.com     | Vendor@123    | vendor |
-- | warangal@nextgen.com       | Vendor@123    | vendor |
-- | medak@nextgen.com          | Vendor@123    | vendor |
-- | adilabad@nextgen.com       | Vendor@123    | vendor |
-- | khammam@nextgen.com        | Vendor@123    | vendor |
-- | nalgonda@nextgen.com       | Vendor@123    | vendor |
-- | mahbubnagar@nextgen.com    | Vendor@123    | vendor |
-- | rangareddy@nextgen.com     | Vendor@123    | vendor |
-- | hyderabad@nextgen.com      | Vendor@123    | vendor |
-- | banjara@nextgen.com        | Vendor@123    | vendor |
--
-- AFTER creating each user, run this SQL to set their role:
-- UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'green-valley-organics') WHERE email = 'greenvalley@nextgen.com';
-- (Repeat for each vendor)
--
-- ADMIN ACCOUNT:
-- | Email                      | Password      | Role   |
-- | admin@nextgen.com          | Admin@123     | admin  |
--
-- UPDATE public.profiles SET role = 'admin' WHERE email = 'admin@nextgen.com';
