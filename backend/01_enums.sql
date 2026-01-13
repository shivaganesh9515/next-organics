-- =============================================
-- 🏷️ CUSTOM TYPES & ENUMS
-- Run this FIRST before creating tables
-- =============================================

-- User roles enum
-- admin: Full system access
-- vendor: Vendor/seller access
DO $$ BEGIN
  CREATE TYPE user_role AS ENUM ('admin', 'vendor');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- Vendor approval status enum
-- pending: Awaiting admin approval
-- approved: Approved and active
-- rejected: Rejected by admin
DO $$ BEGIN
  CREATE TYPE vendor_status AS ENUM ('pending', 'approved', 'rejected');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- =============================================
-- ✅ Enums created successfully
-- =============================================
