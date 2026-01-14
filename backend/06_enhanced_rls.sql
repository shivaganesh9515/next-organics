-- =============================================
-- 🔒 ENHANCED RLS POLICIES WITH COLUMN-LEVEL RESTRICTIONS
-- Prevents security gaps like vendor self-approval
-- =============================================

-- DROP existing policies first
DROP POLICY IF EXISTS "vendor_vendors_update" ON public.vendors;

-- =============================================
-- VENDORS TABLE: Prevent vendors from changing status
-- =============================================

-- Vendor: Update own vendor record (EXCEPT status field)
CREATE POLICY "vendor_vendors_update_restricted" ON public.vendors
  FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (
    user_id = auth.uid()
    -- Ensure status field is not changed by vendor
    AND status = (SELECT status FROM public.vendors WHERE id = public.vendors.id)
  );

-- =============================================
-- PRODUCTS TABLE: Add check constraint for stock
-- =============================================

-- Ensure stock cannot be negative (database-level)
ALTER TABLE public.products
ADD CONSTRAINT check_stock_non_negative CHECK (stock >= 0);

-- =============================================
-- ✅ Enhanced RLS policies applied
-- =============================================
