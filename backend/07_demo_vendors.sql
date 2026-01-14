x-- =============================================
-- 📝 DEMO VENDOR ACCOUNTS CREATION GUIDE
-- =============================================

/*
STEP 1: Create these users in Supabase Dashboard
Go to: Authentication → Users → Add User

┌──────────────────────────────┬──────────────┬─────────┐
│ Email                        │ Password     │ Role    │
├──────────────────────────────┼──────────────┼─────────┤
│ admin@demo.com               │ Admin@123    │ admin   │
│ vendor1@demo.com             │ Vendor@123   │ vendor  │
│ vendor2@demo.com             │ Vendor@123   │ vendor  │
│ vendor3@demo.com             │ Vendor@123   │ vendor  │
│ vendor4@demo.com             │ Vendor@123   │ vendor  │
│ vendor5@demo.com             │ Vendor@123   │ vendor  │
└──────────────────────────────┴──────────────┴─────────┘

STEP 2: After creating users in Auth, run the SQL below
*/

-- =============================================
-- Update profiles for all demo vendors
-- =============================================

UPDATE public.profiles 
SET full_name = 'Demo Admin', role = 'admin'
WHERE email = 'admin@demo.com';

UPDATE public.profiles 
SET full_name = 'Green Valley Farms', role = 'vendor'
WHERE email = 'vendor1@demo.com';

UPDATE public.profiles 
SET full_name = 'Fresh Harvest Co', role = 'vendor'
WHERE email = 'vendor2@demo.com';

UPDATE public.profiles 
SET full_name = 'Organic Basket', role = 'vendor'
WHERE email = 'vendor3@demo.com';

UPDATE public.profiles 
SET full_name = 'Nature''s Bounty', role = 'vendor'
WHERE email = 'vendor4@demo.com';

UPDATE public.profiles 
SET full_name = 'Pure Produce Hub', role = 'vendor'
WHERE email = 'vendor5@demo.com';

-- =============================================
-- Create vendor records
-- =============================================

-- Vendor 1: Green Valley Farms (Approved)
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT 
  id,
  'Green Valley Farms',
  '+91 9876543210',
  '123 Organic Lane, Hyderabad, Telangana 500001',
  'approved'::vendor_status
FROM public.profiles 
WHERE email = 'vendor1@demo.com'
ON CONFLICT (user_id) DO UPDATE SET
  shop_name = EXCLUDED.shop_name,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  status = EXCLUDED.status;

-- Vendor 2: Fresh Harvest Co (Approved)
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT 
  id,
  'Fresh Harvest Co',
  '+91 9876543211',
  '45 Farm Road, Bangalore, Karnataka 560001',
  'approved'::vendor_status
FROM public.profiles 
WHERE email = 'vendor2@demo.com'
ON CONFLICT (user_id) DO UPDATE SET
  shop_name = EXCLUDED.shop_name,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  status = EXCLUDED.status;

-- Vendor 3: Organic Basket (Pending Approval)
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT 
  id,
  'Organic Basket',
  '+91 9876543212',
  '78 Green Street, Pune, Maharashtra 411001',
  'pending'::vendor_status
FROM public.profiles 
WHERE email = 'vendor3@demo.com'
ON CONFLICT (user_id) DO UPDATE SET
  shop_name = EXCLUDED.shop_name,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  status = EXCLUDED.status;

-- Vendor 4: Nature's Bounty (Approved)
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT 
  id,
  'Nature''s Bounty',
  '+91 9876543213',
  '90 Eco Park, Chennai, Tamil Nadu 600001',
  'approved'::vendor_status
FROM public.profiles 
WHERE email = 'vendor4@demo.com'
ON CONFLICT (user_id) DO UPDATE SET
  shop_name = EXCLUDED.shop_name,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  status = EXCLUDED.status;

-- Vendor 5: Pure Produce Hub (Rejected)
INSERT INTO public.vendors (user_id, shop_name, phone, address, status)
SELECT 
  id,
  'Pure Produce Hub',
  '+91 9876543214',
  '12 Market Road, Mumbai, Maharashtra 400001',
  'rejected'::vendor_status
FROM public.profiles 
WHERE email = 'vendor5@demo.com'
ON CONFLICT (user_id) DO UPDATE SET
  shop_name = EXCLUDED.shop_name,
  phone = EXCLUDED.phone,
  address = EXCLUDED.address,
  status = EXCLUDED.status;

-- =============================================
-- ✅ DEMO VENDOR CREDENTIALS
-- =============================================

/*
DEMO LOGIN CREDENTIALS:

ADMIN:
- Email: admin@demo.com
- Password: Admin@123
- Access: /admin portal

APPROVED VENDORS (Can access vendor portal):
1. vendor1@demo.com / Vendor@123 → Green Valley Farms
2. vendor2@demo.com / Vendor@123 → Fresh Harvest Co
3. vendor4@demo.com / Vendor@123 → Nature's Bounty

PENDING VENDOR (Shows pending page):
- vendor3@demo.com / Vendor@123 → Organic Basket (awaiting approval)

REJECTED VENDOR (Cannot login):
- vendor5@demo.com / Vendor@123 → Pure Produce Hub (rejected)

*/
