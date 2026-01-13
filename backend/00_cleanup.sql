-- =============================================
-- 🧹 CLEANUP SCRIPT (OPTIONAL)
-- Run this ONLY if you want to reset the database
-- WARNING: This will DELETE all existing data!
-- =============================================

-- Drop triggers first
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS products_updated_at ON public.products;

-- Drop functions
DROP FUNCTION IF EXISTS public.handle_new_user();
DROP FUNCTION IF EXISTS public.update_updated_at();
DROP FUNCTION IF EXISTS public.get_user_role();

-- Drop tables in correct order (respecting foreign keys)
DROP TABLE IF EXISTS public.admin_actions CASCADE;
DROP TABLE IF EXISTS public.stock_logs CASCADE;
DROP TABLE IF EXISTS public.products CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.vendors CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.banners CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

-- Drop legacy tables if they exist
DROP TABLE IF EXISTS public.manufacturers CASCADE;

-- Drop custom types
DROP TYPE IF EXISTS user_role;
DROP TYPE IF EXISTS vendor_status;

-- =============================================
-- ✅ Database is now clean and ready for fresh schema
-- =============================================
