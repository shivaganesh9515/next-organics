-- =============================================
-- 🛒 50 PRODUCTS PER VENDOR - DEMO DATA
-- Realistic Indian organic grocery products
-- =============================================

DO $$
DECLARE
  v1_id UUID; -- Green Valley Farms
  v2_id UUID; -- Fresh Harvest Co
  v3_id UUID; -- Organic Basket
  v4_id UUID; -- Nature's Bounty
  v5_id UUID; -- Pure Produce Hub (rejected, but still add products)
  
  cat_vegetables UUID;
  cat_fruits UUID;
  cat_dairy UUID;
  cat_grains UUID;
  cat_spices UUID;
BEGIN
  -- Get vendor IDs
  SELECT id INTO v1_id FROM public.vendors v JOIN public.profiles p ON v.user_id = p.id WHERE p.email = 'vendor1@demo.com';
  SELECT id INTO v2_id FROM public.vendors v JOIN public.profiles p ON v.user_id = p.id WHERE p.email = 'vendor2@demo.com';
  SELECT id INTO v3_id FROM public.vendors v JOIN public.profiles p ON v.user_id = p.id WHERE p.email = 'vendor3@demo.com';
  SELECT id INTO v4_id FROM public.vendors v JOIN public.profiles p ON v.user_id = p.id WHERE p.email = 'vendor4@demo.com';
  SELECT id INTO v5_id FROM public.vendors v JOIN public.profiles p ON v.user_id = p.id WHERE p.email = 'vendor5@demo.com';
  
  -- Get category IDs
  SELECT id INTO cat_vegetables FROM public.categories WHERE name = 'Vegetables';
  SELECT id INTO cat_fruits FROM public.categories WHERE name = 'Fruits';
  SELECT id INTO cat_dairy FROM public.categories WHERE name = 'Dairy';
  SELECT id INTO cat_grains FROM public.categories WHERE name = 'Grains';
  SELECT id INTO cat_spices FROM public.categories WHERE name = 'Spices';

  -- =============================================
  -- VENDOR 1: Green Valley Farms (50 products)
  -- =============================================
  INSERT INTO public.products (vendor_id, category_id, name, description, price, stock, is_active) VALUES
  -- Vegetables (15)
  (v1_id, cat_vegetables, 'Organic Tomatoes', 'Bright desi tomatoes, vitamin-C rich', 52.00, 200, true),
  (v1_id, cat_vegetables, 'Fresh Spinach (Palak)', 'Iron-rich green leaves, ideal for curries', 25.00, 150, true),
  (v1_id, cat_vegetables, 'Organic Carrots', 'Crunchy orange carrots, vitamin-A loaded', 45.00, 180, true),
  (v1_id, cat_vegetables, 'Cauliflower (Phool Gobhi)', 'Fresh white florets, perfect for parathas', 35.00, 100, true),
  (v1_id, cat_vegetables, 'Green Capsicum (Shimla Mirch)', 'Crisp bell peppers for stir-fries', 60.00, 120, true),
  (v1_id, cat_vegetables, 'Lady Finger (Bhindi)', 'Tender okra, low in calories', 40.00, 90, true),
  (v1_id, cat_vegetables, 'Brinjal (Baingan)', 'Purple eggplant, rich in antioxidants', 30.00, 110, true),
  (v1_id, cat_vegetables, 'Bottle Gourd (Lauki)', 'Hydrating green gourd, diet-friendly', 28.00, 80, true),
  (v1_id, cat_vegetables, 'Ridge Gourd (Tori)', 'Fibrous green vegetable for healthy digestion', 32.00, 70, true),
  (v1_id, cat_vegetables, 'Pumpkin (Kaddu)', 'Sweet orange pumpkin, nutrient-dense', 25.00, 95, true),
  (v1_id, cat_vegetables, 'Beetroot', 'Deep red roots, blood purifier', 48.00, 130, true),
  (v1_id, cat_vegetables, 'Radish (Mooli)', 'White radish, good for digestion', 20.00, 100, true),
  (v1_id, cat_vegetables, 'Cabbage (Patta Gobhi)', 'Fresh green cabbage for salads', 30.00, 120, true),
  (v1_id, cat_vegetables, 'Coriander Leaves (Dhaniya)', 'Fresh aromatic herbs', 15.00, 200, true),
  (v1_id, cat_vegetables, 'Curry Leaves (Kadhi Patta)', 'Fragrant leaves for tempering', 10.00, 150, true),
  
  -- Fruits (15)
  (v1_id, cat_fruits, 'Fresh Bananas (Elaichi Kela)', 'Sweet ripe bananas, energy-rich', 45.00, 250, true),
  (v1_id, cat_fruits, 'Organic Alphonso Mango', 'King of fruits from Ratnagiri', 399.00, 60, true),
  (v1_id, cat_fruits, 'Fresh Pomegranate (Anaar)', 'Ruby red seeds, antioxidant-rich', 160.00, 90, true),
  (v1_id, cat_fruits, 'Papaya (Papita)', 'Ripe orange papaya, digestive enzyme', 40.00, 100, true),
  (v1_id, cat_fruits, 'Watermelon (Tarbooz)', 'Juicy red melon, summer refresher', 30.00, 150, true),
  (v1_id, cat_fruits, 'Guava (Amrood)', 'Crunchy white guava, vitamin-C bomb', 50.00, 120, true),
  (v1_id, cat_fruits, 'Custard Apple (Sitaphal)', 'Creamy sweet fruit, seasonal delight', 120.00, 50, true),
  (v1_id, cat_fruits, 'Sapota (Chikoo)', 'Brown sweet fruit, rich in fiber', 70.00, 80, true),
  (v1_id, cat_fruits, 'Grapes (Angoor) - Green', 'Seedless green grapes, fresh bunch', 90.00, 100, true),
  (v1_id, cat_fruits, 'Sweet Lime (Mosambi)', 'Citrus fruit, vitamin-C source', 60.00, 110, true),
  (v1_id, cat_fruits, 'Orange (Santra)', 'Juicy oranges, immunity booster', 80.00, 130, true),
  (v1_id, cat_fruits, 'Pineapple (Ananas)', 'Tropical fruit, digestive aid', 50.00, 70, true),
  (v1_id, cat_fruits, 'Dragon Fruit', 'Exotic pink fruit, low-calorie', 150.00, 40, true),
  (v1_id, cat_fruits, 'Kiwi Fruit', 'Green tangy kiwi, vitamin-rich', 200.00, 60, true),
  (v1_id, cat_fruits, 'Avocado (Butter Fruit)', 'Creamy avocado, healthy fats', 180.00, 50, true),
  
  -- Dairy (10)
  (v1_id, cat_dairy, 'Pure Desi Ghee', 'A2 cow ghee, traditional bilona method', 599.00, 80, true),
  (v1_id, cat_dairy, 'Organic Paneer', 'Fresh cottage cheese, protein-packed', 280.00, 100, true),
  (v1_id, cat_dairy, 'Farm Fresh Milk (A2)', 'Unhomogenized A2 cow milk', 70.00, 120, true),
  (v1_id, cat_dairy, 'Fresh Curd (Dahi)', 'Homemade style curd, probiotic-rich', 50.00, 90, true),
  (v1_id, cat_dairy, 'Buttermilk (Chaas)', 'Spiced buttermilk, cooling drink', 30.00, 110, true),
  (v1_id, cat_dairy, 'Butter (White)', 'Unsalted white butter, creamy', 150.00, 70, true),
  (v1_id, cat_dairy, 'Mozzarella Cheese', 'Fresh mozzarella for pizza', 320.00, 50, true),
  (v1_id, cat_dairy, 'Cream Cheese', 'Soft spreadable cheese', 250.00, 40, true),
  (v1_id, cat_dairy, 'Khoya (Mawa)', 'Condensed milk solid for sweets', 400.00, 60, true),
  (v1_id, cat_dairy, 'Lassi (Sweet)', 'Yogurt-based drink, refreshing', 40.00, 100, true),
  
  -- Grains & Pulses (7)
  (v1_id, cat_grains, 'Organic Basmati Rice', 'Aged 2 years, extra aroma', 160.00, 200, true),
  (v1_id, cat_grains, 'Organic Toor Dal (Arhar)', 'Protein-rich lentils', 140.00, 180, true),
  (v1_id, cat_grains, 'Moong Dal (Green Gram)', 'Easy-to-digest yellow lentils', 130.00, 150, true),
  (v1_id, cat_grains, 'Chana Dal (Bengal Gram)', 'Split chickpeas for dal', 120.00, 160, true),
  (v1_id, cat_grains, 'Masoor Dal (Red Lentils)', 'Quick-cooking red lentils', 110.00, 140, true),
  (v1_id, cat_grains, 'Whole Wheat Atta', 'Stone-ground whole wheat flour', 50.00, 300, true),
  (v1_id, cat_grains, 'Quinoa (Organic)', 'Superfood grain, complete protein', 350.00, 80, true),
  
  -- Spices (3)
  (v1_id, cat_spices, 'Organic Turmeric Powder (Haldi)', 'High curcumin, immunity booster', 100.00, 200, true),
  (v1_id, cat_spices, 'Red Chili Powder (Lal Mirch)', 'Spicy red chili, adds heat', 80.00, 180, true),
  (v1_id, cat_spices, 'Corianderseed Powder (Dhaniya)', 'Aromatic coriander for curries', 60.00, 150, true);

  -- =============================================
  -- VENDOR 2: Fresh Harvest Co (50 products)
  -- =============================================
  INSERT INTO public.products (vendor_id, category_id, name, description, price, stock, is_active) VALUES
  -- Vegetables (15)
  (v2_id, cat_vegetables, 'Organic Potatoes', 'Starchy tubers for aloo recipes', 35.00, 250, true),
  (v2_id, cat_vegetables, 'Fresh Green Peas (Matar)', 'Sweet green peas for curries', 55.00, 130, true),
  (v2_id, cat_vegetables, 'Onions (Pyaz)', 'Essential cooking base vegetable', 40.00, 300, true),
  (v2_id, cat_vegetables, 'Garlic (Lahsun)', 'Aromatic bulbs for tempering', 180.00, 100, true),
  (v2_id, cat_vegetables, 'Ginger (Adrak)', 'Fresh rhizome, digestive aid', 120.00, 110, true),
  (v2_id, cat_vegetables, 'Green Chili (Hari Mirch)', 'Spicy peppers for heat', 60.00, 150, true),
  (v2_id, cat_vegetables, 'Bitter Gourd (Karela)', 'Bitter vegetable for diabetes', 50.00, 80, true),
  (v2_id, cat_vegetables, 'Snake Gourd (Chichinda)', 'Long green gourd', 35.00, 70, true),
  (v2_id, cat_vegetables, 'Drumstick (Moringa)', 'Long green pods, superfood', 40.00, 90, true),
  (v2_id, cat_vegetables, 'Cluster Beans (Guar)', 'Green beans, fiber-rich', 45.00, 95, true),
  (v2_id, cat_vegetables, 'Ash Gourd (Petha)', 'White gourd for halwa', 28.00, 75, true),
  (v2_id, cat_vegetables, 'Mint Leaves (Pudina)', 'Fresh aromatic mint', 12.00, 200, true),
  (v2_id, cat_vegetables, 'Fenugreek Leaves (Methi)', 'Bitter green leaves', 18.00, 150, true),
  (v2_id, cat_vegetables, 'French Beans', 'Tender green beans', 55.00, 100, true),
  (v2_id, cat_vegetables, 'Sweet Corn', 'Fresh corn on cob', 30.00, 120, true),
  
  -- Fruits (15)
  (v2_id, cat_fruits, 'Apples (Kashmiri)', 'Crisp red apples from Kashmir', 180.00, 150, true),
  (v2_id, cat_fruits, 'Grapes (Black)', 'Seedless black grapes', 110.00, 100, true),
  (v2_id, cat_fruits, 'Strawberries', 'Fresh red berries, seasonal', 250.00, 60, true),
  (v2_id, cat_fruits, 'Mangoes (Kesar)', 'Gujarati kesar mangoes', 350.00, 70, true),
  (v2_id, cat_fruits, 'Mangoes (Dasheri)', 'North Indian sweet mangoes', 280.00, 80, true),
  (v2_id, cat_fruits, 'Lychee (Litchi)', 'Sweet tropical fruit', 150.00, 50, true),
  (v2_id, cat_fruits, 'Jackfruit (Kathal)', 'Large tropical fruit', 60.00, 40, true),
  (v2_id, cat_fruits, 'Coconut (Nariyal)', 'Fresh coconuts, hydrating water', 40.00, 200, true),
  (v2_id, cat_fruits, 'Lemon (Nimbu)', 'Tangy citrus fruit', 80.00, 180, true),
  (v2_id, cat_fruits, 'Figs (Anjeer) - Fresh', 'Sweet figs, high in fiber', 200.00, 40, true),
  (v2_id, cat_fruits, 'Dates (Khajoor) - Fresh', 'Sweet dates, energy-rich', 150.00, 60, true),
  (v2_id, cat_fruits, 'Pears (Nashpati)', 'Crisp sweet pears', 120.00, 80, true),
  (v2_id, cat_fruits, 'Plums (Aloo Bukhara)', 'Purple plums, tangy', 140.00, 70, true),
  (v2_id, cat_fruits, 'Cherries', 'Red sweet cherries, import', 400.00, 30, true),
  (v2_id, cat_fruits, 'Blueberries', 'Superfood berries, antioxidant', 500.00, 25, true),
  
  -- Dairy (10)
  (v2_id, cat_dairy, 'Buffalo Milk', 'Rich creamy buffalo milk', 80.00, 150, true),
  (v2_id, cat_dairy, 'Flavored Yogurt - Strawberry', 'Sweetened fruit yogurt', 60.00, 100, true),
  (v2_id, cat_dairy, 'Flavored Yogurt - Mango', 'Mango-flavored yogurt', 60.00, 100, true),
  (v2_id, cat_dairy, 'Greek Yogurt', 'Thick protein-rich yogurt', 120.00, 60, true),
  (v2_id, cat_dairy, 'Malai (Milk Cream)', 'Fresh milk cream for sweets', 200.00, 50, true),
  (v2_id, cat_dairy, 'Butter (Salted)', 'Yellow salted butter', 140.00, 80, true),
  (v2_id, cat_dairy, 'Cheddar Cheese', 'Sharp cheddar slices', 300.00, 70, true),
  (v2_id, cat_dairy, 'Gouda Cheese', 'Mild yellow cheese', 350.00, 50, true),
  (v2_id, cat_dairy, 'Shrikhand', 'Sweetened yogurt dessert', 150.00, 60, true),
  (v2_id, cat_dairy, 'Raita (Cucumber)', 'Cucumber yogurt dip', 40.00, 90, true),
  
  -- Grains (7)
  (v2_id, cat_grains, 'Brown Rice', 'Whole grain brown rice', 90.00, 180, true),
  (v2_id, cat_grains, 'Urad Dal (Black Gram)', 'Black lentils for dal makhani', 150.00, 140, true),
  (v2_id, cat_grains, 'Rajma (Kidney Beans)', 'Red beans for Rajma Chawal', 120.00, 160, true),
  (v2_id, cat_grains, 'Kabuli Chana (Chickpeas)', 'White chickpeas for chole', 110.00, 150, true),
  (v2_id, cat_grains, 'Black Chana (Kala Chana)', 'Black chickpeas, protein-rich', 100.00, 140, true),
  (v2_id, cat_grains, 'Multigrain Atta', 'Mixed grain flour', 80.00, 200, true),
  (v2_id, cat_grains, 'Oats (Rolled)', 'Healthy breakfast oats', 120.00, 160, true),
  
  -- Spices (3)
  (v2_id, cat_spices, 'Cumin Seeds (Jeera)', 'Aromatic seeds for tempering', 200.00, 150, true),
  (v2_id, cat_spices, 'Mustard Seeds (Rai)', 'Black mustard for tadka', 90.00, 140, true),
  (v2_id, cat_spices, 'Garam Masala', 'Spice blend for Indian curries', 150.00, 130, true);

  -- =============================================
  -- VENDOR 3: Organic Basket (50 products)
  -- =============================================
  INSERT INTO public.products (vendor_id, category_id, name, description, price, stock, is_active) VALUES
  -- Vegetables (15)
  (v3_id, cat_vegetables, 'Baby Corn', 'Tender miniature corn', 70.00, 80, true),
  (v3_id, cat_vegetables, 'Zucchini', 'Green squash for stir-fries', 80.00, 70, true),
  (v3_id, cat_vegetables, 'Broccoli', 'Green florets, superfood', 90.00, 60, true),
  (v3_id, cat_vegetables, 'Bell Pepper - Red', 'Sweet red peppers', 100.00, 70, true),
  (v3_id, cat_vegetables, 'Bell Pepper - Yellow', 'Bright yellow peppers', 100.00, 70, true),
  (v3_id, cat_vegetables, 'Lettuce (Iceberg)', 'Crisp salad leaves', 50.00, 90, true),
  (v3_id, cat_vegetables, 'Celery', 'Crunchy stalks for salads', 60.00, 65, true),
  (v3_id, cat_vegetables, 'Arugula (Rocket)', 'Peppery salad greens', 80.00, 50, true),
  (v3_id, cat_vegetables, 'Spring Onions', 'Green onions with stalks', 30.00, 120, true),
  (v3_id, cat_vegetables, 'Leeks', 'Mild onion-like vegetable', 70.00, 60, true),
  (v3_id, cat_vegetables, 'Asparagus', 'Green spears, gourmet vegetable', 250.00, 40, true),
  (v3_id, cat_vegetables, 'Mushrooms - Button', 'White button mushrooms', 120.00, 80, true),
  (v3_id, cat_vegetables, 'Cherry Tomatoes', 'Small sweet tomatoes', 90.00, 100, true),
  (v3_id, cat_vegetables, 'Parsley', 'Fresh herb for garnish', 20.00, 150, true),
  (v3_id, cat_vegetables, 'Basil Leaves', 'Aromatic Italian herb', 30.00, 120, true),
  
  -- Fruits (15)
  (v3_id, cat_fruits, 'Raspberries', 'Red antioxidant berries', 550.00, 20, true),
  (v3_id, cat_fruits, 'Blackberries', 'Dark purple berries', 520.00, 22, true),
  (v3_id, cat_fruits, 'Cranberries (Fresh)', 'Tart red berries', 400.00, 30, true),
  (v3_id, cat_fruits, 'Goji Berries', 'Superfood dried berries', 600.00, 25, true),
  (v3_id, cat_fruits, 'Passion Fruit', 'Tropical tangy fruit', 180.00, 40, true),
  (v3_id, cat_fruits, 'Star Fruit (Kamrakh)', 'Star-shaped tropical fruit', 120.00, 50, true),
  (v3_id, cat_fruits, 'Wood Apple (Bael)', 'Hard shell fruit, digestive', 60.00, 70, true),
  (v3_id, cat_fruits, 'Persimmon', 'Orange sweet fruit', 200.00, 35, true),
  (v3_id, cat_fruits, 'Pomelo', 'Large citrus fruit', 150.00, 45, true),
  (v3_id, cat_fruits, 'Longan', 'Sweet tropical fruit', 220.00, 30, true),
  (v3_id, cat_fruits, 'Rambutan', 'Hairy red fruit, sweet', 250.00, 28, true),
  (v3_id, cat_fruits, 'Mangosteen', 'Queen of fruits, exotic', 450.00, 20, true),
  (v3_id, cat_fruits, 'Mulberries (Fresh)', 'Purple sweet berries', 300.00, 35, true),
  (v3_id, cat_fruits, 'Custard Apple - Anon', 'Smooth custard apple variety', 140.00, 55, true),
  (v3_id, cat_fruits, 'Green Apple', 'Tangy granny smith apples', 200.00, 100, true),
  
  -- Dairy (10)
  (v3_id, cat_dairy, 'Almond Milk (Unsweetened)', 'Plant-based milk', 180.00, 70, true),
  (v3_id, cat_dairy, 'Soy Milk', 'Protein-rich plant milk', 150.00, 80, true),
  (v3_id, cat_dairy, 'Coconut Milk', 'Creamy plant-based milk', 160.00, 75, true),
  (v3_id, cat_dairy, 'Oat Milk', 'Creamy oat-based milk', 170.00, 65, true),
  (v3_id, cat_dairy, 'Vegan Cheese - Cashew', 'Plant-based cheese', 400.00, 40, true),
  (v3_id, cat_dairy, 'Tofu (Regular)', 'Soy-based protein block', 120.00, 90, true),
  (v3_id, cat_dairy, 'Tofu (Silken)', 'Soft silken tofu', 130.00, 80, true),
  (v3_id, cat_dairy, 'Tempeh', 'Fermented soy protein', 180.00, 50, true),
  (v3_id, cat_dairy, 'Nutritional Yeast', 'Cheesy vegan seasoning', 300.00, 40, true),
  (v3_id, cat_dairy, 'Hangcurd (Fermented)', 'Thick hung yogurt', 80.00, 90, true),
  
  -- Grains (7)
  (v3_id, cat_grains, 'Wild Rice', 'Black wild rice, nutty', 400.00, 60, true),
  (v3_id, cat_grains, 'Amaranth (Rajgira)', 'Ancient grain, gluten-free', 200.00, 80, true),
  (v3_id, cat_grains, 'Buckwheat (Kuttu)', 'Gluten-free grain', 150.00, 90, true),
  (v3_id, cat_grains, 'Millet - Foxtail (Kangni)', 'Nutritious millet', 90.00, 120, true),
  (v3_id, cat_grains, 'Millet - Pearl (Bajra)', 'Winter grain, warming', 80.00, 130, true),
  (v3_id, cat_grains, 'Millet - Finger (Ragi)', 'Calcium-rich red millet', 100.00, 110, true),
  (v3_id, cat_grains, 'Couscous', 'Tiny pasta pearls', 180.00, 70, true),
  
  -- Spices (3)
  (v3_id, cat_spices, 'Cinnamon Sticks (Dalchini)', 'Aromatic bark for tea', 250.00, 80, true),
  (v3_id, cat_spices, 'Cardamom (Elaichi)', 'Green pods, sweet aroma', 800.00, 50, true),
  (v3_id, cat_spices, 'Cloves (Laung)', 'Aromatic flower buds', 300.00, 70, true);

  -- =============================================
  -- VENDOR 4: Nature's Bounty (50 products)
  -- =============================================
  INSERT INTO public.products (vendor_id, category_id, name, description, price, stock, is_active) VALUES
  -- Vegetables (15)
  (v4_id, cat_vegetables, 'Lettuce (Romaine)', 'Crisp romaine leaves', 55.00, 95, true),
  (v4_id, cat_vegetables, 'Kale', 'Superfood green leaves', 100.00, 60, true),
  (v4_id, cat_vegetables, 'Swiss Chard', 'Colorful leafy vegetable', 90.00, 55, true),
  (v4_id, cat_vegetables, 'Bok Choy', 'Asian leafy vegetable', 85.00, 65, true),
  (v4_id, cat_vegetables, 'Eggplant (Japanese)', 'Long purple eggplant', 70.00, 75, true),
  (v4_id, cat_vegetables, 'Chayote (Chow Chow)', 'Light green squash', 35.00, 100, true),
  (v4_id, cat_vegetables, 'Turnip (Shalgam)', 'White root vegetable', 40.00, 90, true),
  (v4_id, cat_vegetables, 'Kohlrabi (Ganth Gobhi)', 'Cabbage turnip hybrid', 50.00, 70, true),
  (v4_id, cat_vegetables, 'Artichokes', 'Gourmet globe thistle', 300.00, 30, true),
  (v4_id, cat_vegetables, 'Brussels Sprouts', 'Mini cabbage heads', 150.00, 50, true),
  (v4_id, cat_vegetables, 'Radicchio', 'Purple Italian chicory', 200.00, 40, true),
  (v4_id, cat_vegetables, 'Fennel Bulb', 'Anise-flavored bulb', 120.00, 55, true),
  (v4_id, cat_vegetables, 'Rosemary', 'Aromatic herb sprigs', 40.00, 100, true),
  (v4_id, cat_vegetables, 'Thyme', 'Small fragrant leaves', 50.00, 90, true),
  (v4_id, cat_vegetables, 'Dill', 'Feathery herb for pickling', 30.00, 110, true),
  
  -- Fruits (15)
  (v4_id, cat_fruits, 'Peaches', 'Fuzzy stone fruit', 180.00, 60, true),
  (v4_id, cat_fruits, 'Nectarines', 'Smooth peaches', 200.00, 55, true),
  (v4_id, cat_fruits, 'Apricots', 'Orange stone fruits', 220.00, 50, true),
  (v4_id, cat_fruits, 'Prunes (Fresh)', 'Purple plum variety', 160.00, 65, true),
  (v4_id, cat_fruits, 'Cantaloupe Melon', 'Orange-fleshed melon', 80.00, 90, true),
  (v4_id, cat_fruits, 'Honeydew Melon', 'Green sweet melon', 85.00, 85, true),
  (v4_id, cat_fruits, 'Muskmelon (Kharbooja)', 'Aromatic orange melon', 60.00, 100, true),
  (v4_id, cat_fruits, 'Seedless Grapes (Red)', 'Sweet red grapes', 120.00, 110, true),
  (v4_id, cat_fruits, 'Table Grapes - Black', 'Large black grapes', 130.00, 95, true),
  (v4_id, cat_fruits, 'Tangerine (Mandarin)', 'Easy-peel orange', 100.00, 120, true),
  (v4_id, cat_fruits, 'Clementine', 'Tiny seedless oranges', 150.00, 80, true),
  (v4_id, cat_fruits, 'Grapefruit', 'Large citrus, tangy', 120.00, 70, true),
  (v4_id, cat_fruits, 'Blood Orange', 'Red-fleshed orange', 180.00, 55, true),
  (v4_id, cat_fruits, 'Red Banana', 'Purple-skinned sweet bananas', 70.00, 140, true),
  (v4_id, cat_fruits, 'Plantain (Raw Banana)', 'Cooking banana', 50.00, 160, true),
  
  -- Dairy (10)
  (v4_id, cat_dairy, 'Kefir', 'Fermented probiotic milk', 120.00, 70, true),
  (v4_id, cat_dairy, 'Ricotta Cheese', 'Soft Italian cheese', 280.00, 50, true),
  (v4_id, cat_dairy, 'Parmesan Cheese', 'Hard Italian cheese', 400.00, 40, true),
  (v4_id, cat_dairy, 'Blue Cheese', 'Veined moldy cheese', 450.00, 30, true),
  (v4_id, cat_dairy, 'Feta Cheese', 'Greek brined cheese', 350.00, 45, true),
  (v4_id, cat_dairy, 'Cottage Cheese', 'Chunky fresh cheese', 200.00, 80, true),
  (v4_id, cat_dairy, 'Mascarpone', 'Italian cream cheese', 380.00, 35, true),
  (v4_id, cat_dairy, 'Camembert', 'Soft French cheese', 500.00, 25, true),
  (v4_id, cat_dairy, 'Goat Cheese (Chevre)', 'Tangy goat milk cheese', 420.00, 35, true),
  (v4_id, cat_dairy, 'Whipped Cream', 'Sweetened cream topping', 150.00, 60, true),
  
  -- Grains (7)
  (v4_id, cat_grains, 'Freekeh', 'Roasted green wheat', 350.00, 50, true),
  (v4_id, cat_grains, 'Farro', 'Ancient wheat grain', 280.00, 60, true),
  (v4_id, cat_grains, 'Barley (Pearl)', 'Polished barley grain', 100.00, 120, true),
  (v4_id, cat_grains, 'Bulgur Wheat', 'Cracked parboiled wheat', 120.00, 100, true),
  (v4_id, cat_grains, 'Black Rice', 'Anthocyanin-rich rice', 250.00, 70, true),
  (v4_id, cat_grains, 'Red Rice', 'Unpolished red rice', 180.00, 90, true),
  (v4_id, cat_grains, 'Poha (Beaten Rice)', 'Flattened rice flakes', 60.00, 140, true),
  
  -- Spices (3)
  (v4_id, cat_spices, 'Black Pepper (Kali Mirch)', 'Whole black peppercorns', 250.00, 100, true),
  (v4_id, cat_spices, 'Star Anise (Chakra Phool)', 'Star-shaped spice', 300.00, 60, true),
  (v4_id, cat_spices, 'Bay Leaves (Tej Patta)', 'Aromatic dried leaves', 100.00, 120, true);

  -- =============================================
  -- VENDOR 5: Pure Produce Hub (50 products)
  -- Even though rejected, add products for demo
  -- =============================================
  INSERT INTO public.products (vendor_id, category_id, name, description, price, stock, is_active) VALUES
  -- Vegetables (15)
  (v5_id, cat_vegetables, 'Red Cabbage', 'Purple cabbage for salads', 60.00, 80, true),
  (v5_id, cat_vegetables, 'Savoy Cabbage', 'Crinkled cabbage leaves', 65.00, 75, true),
  (v5_id, cat_vegetables, 'Chinese Cabbage', 'Long napa cabbage', 70.00, 70, true),
  (v5_id, cat_vegetables, 'Taro Root (Arbi)', 'Starchy root vegetable', 45.00, 100, true),
  (v5_id, cat_vegetables, 'Yam (Jimikand)', 'Purple root vegetable', 50.00, 90, true),
  (v5_id, cat_vegetables, 'Sweet Potato', 'Orange root, sweet flavor', 55.00, 120, true),
  (v5_id, cat_vegetables, 'Purple Yam', 'Purple-fleshed sweet potato', 80.00, 70, true),
  (v5_id, cat_vegetables, 'Lotus Root (Bhein)', 'Crunchy root vegetable', 120.00, 50, true),
  (v5_id, cat_vegetables, 'Bamboo Shoots', 'Young bamboo stems', 150.00, 40, true),
  (v5_id, cat_vegetables, 'Water Chestnuts', 'Crunchy aquatic tubers', 100.00, 60, true),
  (v5_id, cat_vegetables, 'Jicama', 'Crisp white root', 90.00, 65, true),
  (v5_id, cat_vegetables, 'Daikon Radish', 'Large white radish', 40.00, 95, true),
  (v5_id, cat_vegetables, 'Horseradish', 'Spicy root for sauces', 200.00, 30, true),
  (v5_id, cat_vegetables, 'Oregano', 'Italian herb leaves', 35.00, 110, true),
  (v5_id, cat_vegetables, 'Chives', 'Mild onion-flavored herb', 25.00, 130, true),
  
  -- Fruits (15)
  (v5_id, cat_fruits, 'Acai Berry (Frozen)', 'Superfood purple berries', 700.00, 20, true),
  (v5_id, cat_fruits, 'Elderberries', 'Dark purple immune berries', 650.00, 22, true),
  (v5_id, cat_fruits, 'Gooseberries (Amla-like)', 'Tart green berries', 180.00, 45, true),
  (v5_id, cat_fruits, 'Currants (Red)', 'Tiny tart berries', 350.00, 30, true),
  (v5_id, cat_fruits, 'Quince', 'Golden aromatic fruit', 220.00, 35, true),
  (v5_id, cat_fruits, 'Medlar', 'Ancient brown fruit', 280.00, 25, true),
  (v5_id, cat_fruits, 'Carambola (Star Fruit)', 'Yellow star fruit', 110.00, 55, true),
  (v5_id, cat_fruits, 'Tamarind (Fresh)', 'Sour brown pods', 80.00, 90, true),
  (v5_id, cat_fruits, 'Fresh Dates (Seedai)', 'Brown sweet dates', 180.00, 60, true),
  (v5_id, cat_fruits, 'Black Grapes (Seedless)', 'Dark seedless grapes', 140.00, 85, true),
  (v5_id, cat_fruits, 'Golden Kiwi', 'Yellow-fleshed kiwi', 250.00, 50, true),
  (v5_id, cat_fruits, 'Mini Watermelon', 'Personal-sized melons', 60.00, 80, true),
  (v5_id, cat_fruits, 'Sugar Cane (Ganna)', 'Fresh cane sticks', 30.00, 150, true),
  (v5_id, cat_fruits, 'Indian Gooseberry (Amla)', 'Green tart berries', 60.00, 110, true),
  (v5_id, cat_fruits, 'Jamun (Black Plum)', 'Purple summer fruit', 80.00, 95, true),
  
  -- Dairy (10)
  (v5_id, cat_dairy, 'Cashew Cream', 'Plant-based cream', 250.00, 50, true),
  (v5_id, cat_dairy, 'Hemp Milk', 'Nutty plant milk', 220.00, 45, true),
  (v5_id, cat_dairy, 'Rice Milk', 'Light plant milk', 140.00, 60, true),
  (v5_id, cat_dairy, 'Pea Protein Milk', 'High-protein plant milk', 190.00, 55, true),
  (v5_id, cat_dairy, 'Vegan Butter', 'Plant-based butter', 180.00, 70, true),
  (v5_id, cat_dairy, 'Vegan Yogurt - Coconut', 'Coconut-based yogurt', 120.00, 65, true),
  (v5_id, cat_dairy, 'Vegan Ice Cream - Vanilla', 'Plant-based ice cream', 300.00, 40, true),
  (v5_id, cat_dairy, 'Vegan Cream Cheese', 'Plant-based spread', 280.00, 45, true),
  (v5_id, cat_dairy, 'Seitan', 'Wheat protein meat alternative', 220.00, 50, true),
  (v5_id, cat_dairy, 'Soya Chunks', 'Textured soy protein', 80.00, 150, true),
  
  -- Grains (7)
  (v5_id, cat_grains, 'Chia Seeds', 'Omega-3 rich tiny seeds', 300.00, 80, true),
  (v5_id, cat_grains, 'Flax Seeds (Alsi)', 'Fiber-rich brown seeds', 150.00, 100, true),
  (v5_id, cat_grains, 'Pumpkin Seeds', 'Green pepitas, zinc-rich', 350.00, 70, true),
  (v5_id, cat_grains, 'Sunflower Seeds', 'Striped seeds, vitamin-E', 200.00, 90, true),
  (v5_id, cat_grains, 'Hemp Seeds', 'Complete protein seeds', 450.00, 50, true),
  (v5_id, cat_grains, 'Sorghum (Jowar)', 'Gluten-free cereal', 70.00, 130, true),
  (v5_id, cat_grains, 'Teff', 'Tiny Ethiopian grain', 400.00, 45, true),
  
  -- Spices (3)
  (v5_id, cat_spices, 'Saffron (Kesar)', 'Red gold spice threads', 2000.00, 10, true),
  (v5_id, cat_spices, 'Vanilla Beans', 'Aromatic vanilla pods', 1500.00, 15, true),
  (v5_id, cat_spices, 'Nutmeg (Jaiphal)', 'Aromatic brown nut seed', 400.00, 50, true);

  RAISE NOTICE '✅ Successfully added 250 products (50 per vendor)!';
END $$;

-- =============================================
-- ✅ 250 PRODUCTS CREATED
-- =============================================
