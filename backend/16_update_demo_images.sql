-- Update images for existing demo products by name

-- Vegetables
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500' WHERE name = 'Organic Tomatoes';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500' WHERE name = 'Fresh Spinach';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500' WHERE name = 'Organic Carrots';

-- Fruits
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1603833665858-e61d17a8622e?w=500' WHERE name = 'Fresh Bananas';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=500' WHERE name = 'Organic Alphonso Mango';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1615485925763-867862f80a02?w=500' WHERE name = 'Fresh Pomegranate';

-- Dairy
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=500' WHERE name = 'Pure Desi Ghee';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1559561853-08451507cbe4?w=500' WHERE name = 'Organic Paneer';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500' WHERE name = 'Farm Fresh Milk';

-- Grains
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500' WHERE name = 'Organic Basmati Rice';
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1585996736075-814cb2414736?w=500' WHERE name = 'Organic Toor Dal';

-- Spices
UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500' WHERE name = 'Organic Turmeric Powder';
