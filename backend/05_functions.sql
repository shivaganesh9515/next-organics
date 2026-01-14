-- =============================================
-- 🔧 DATABASE FUNCTIONS FOR ATOMIC OPERATIONS
-- Ensures transaction safety for critical operations
-- =============================================

-- =============================================
-- Function: Atomic Stock Update
-- Updates product stock and logs the change in one transaction
-- =============================================
CREATE OR REPLACE FUNCTION public.update_product_stock(
  p_product_id UUID,
  p_change INT,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_vendor_id UUID;
  v_current_stock INT;
  v_new_stock INT;
  v_product_name TEXT;
BEGIN
  -- Get vendor_id for current user
  SELECT id INTO v_vendor_id FROM public.vendors WHERE user_id = auth.uid();
  
  IF v_vendor_id IS NULL THEN
    RAISE EXCEPTION 'No vendor record found for current user';
  END IF;

  -- Get current stock and verify ownership
  SELECT stock, name INTO v_current_stock, v_product_name
  FROM public.products
  WHERE id = p_product_id AND vendor_id = v_vendor_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Product not found or access denied';
  END IF;

  -- Calculate new stock
  v_new_stock := v_current_stock + p_change;

  -- Validate stock cannot be negative
  IF v_new_stock < 0 THEN
    RAISE EXCEPTION 'Stock cannot be negative. Current: %, Change: %', v_current_stock, p_change;
  END IF;

  -- Update product stock (atomic)
  UPDATE public.products
  SET stock = v_new_stock, updated_at = NOW()
  WHERE id = p_product_id AND vendor_id = v_vendor_id;

  -- Log the change (in same transaction)
  INSERT INTO public.stock_logs (product_id, vendor_id, change, reason)
  VALUES (
    p_product_id, 
    v_vendor_id, 
    p_change, 
    COALESCE(p_reason, CASE WHEN p_change > 0 THEN 'Stock added' ELSE 'Stock deducted' END)
  );

  -- Return success with details
  RETURN jsonb_build_object(
    'success', true,
    'product_id', p_product_id,
    'product_name', v_product_name,
    'old_stock', v_current_stock,
    'new_stock', v_new_stock,
    'change', p_change
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- Function: Approve/Reject Vendor with Audit Log
-- Updates vendor status and logs admin action in one transaction
-- =============================================
CREATE OR REPLACE FUNCTION public.admin_update_vendor_status(
  p_vendor_id UUID,
  p_new_status vendor_status
)
RETURNS JSONB AS $$
DECLARE
  v_admin_id UUID;
  v_old_status vendor_status;
  v_shop_name TEXT;
BEGIN
  -- Verify current user is admin
  SELECT id INTO v_admin_id FROM public.profiles WHERE id = auth.uid() AND role = 'admin';
  
  IF v_admin_id IS NULL THEN
    RAISE EXCEPTION 'Access denied. Admin only.';
  END IF;

  -- Get current status
  SELECT status, shop_name INTO v_old_status, v_shop_name
  FROM public.vendors
  WHERE id = p_vendor_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Vendor not found';
  END IF;

  -- Update vendor status (atomic)
  UPDATE public.vendors
  SET status = p_new_status
  WHERE id = p_vendor_id;

  -- Log admin action (in same transaction)
  INSERT INTO public.admin_actions (admin_id, action, target_id)
  VALUES (v_admin_id, p_new_status || ' vendor', p_vendor_id);

  -- Return success with details
  RETURN jsonb_build_object(
    'success', true,
    'vendor_id', p_vendor_id,
    'shop_name', v_shop_name,
    'old_status', v_old_status,
    'new_status', p_new_status
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- ✅ Database functions created successfully
-- =============================================
