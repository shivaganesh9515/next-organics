-- =============================================
-- 🔒 RLS POLICIES FOR ORDERS SYSTEM
-- Security policies for customers, orders, and related tables
-- =============================================

-- =============================================
-- ENABLE RLS ON ALL ORDERS TABLES
-- =============================================
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY;

-- =============================================
-- HELPER FUNCTIONS
-- =============================================

-- Get customer ID for current user
CREATE OR REPLACE FUNCTION get_customer_id()
RETURNS UUID AS $$
BEGIN
  RETURN (
    SELECT id FROM public.customers
    WHERE user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- CUSTOMERS TABLE POLICIES
-- =============================================

-- Customers can read their own profile
CREATE POLICY "customer_customers_select"
  ON public.customers
  FOR SELECT
  USING (user_id = auth.uid());

-- Customers can update their own profile
CREATE POLICY "customer_customers_update"
  ON public.customers
  FOR UPDATE
  USING (user_id = auth.uid());

-- Admins can view all customers
CREATE POLICY "admin_customers_select"
  ON public.customers
  FOR SELECT
  USING (is_admin());

-- System can insert new customers (for registration)
CREATE POLICY "system_customers_insert"
  ON public.customers
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- =============================================
-- DELIVERY ADDRESSES POLICIES
-- =============================================

-- Customers can view their own addresses
CREATE POLICY "customer_delivery_addresses_select"
  ON public.delivery_addresses
  FOR SELECT
  USING (customer_id = get_customer_id());

-- Customers can create their own addresses
CREATE POLICY "customer_delivery_addresses_insert"
  ON public.delivery_addresses
  FOR INSERT
  WITH CHECK (customer_id = get_customer_id());

-- Customers can update their own addresses
CREATE POLICY "customer_delivery_addresses_update"
  ON public.delivery_addresses
  FOR UPDATE
  USING (customer_id = get_customer_id());

-- Customers can delete their own addresses
CREATE POLICY "customer_delivery_addresses_delete"
  ON public.delivery_addresses
  FOR DELETE
  USING (customer_id = get_customer_id());

-- Admins can view all addresses
CREATE POLICY "admin_delivery_addresses_select"
  ON public.delivery_addresses
  FOR SELECT
  USING (is_admin());

-- =============================================
-- ORDERS TABLE POLICIES
-- =============================================

-- Customers can view their own orders
CREATE POLICY "customer_orders_select"
  ON public.orders
  FOR SELECT
  USING (customer_id = get_customer_id());

-- Customers can create orders
CREATE POLICY "customer_orders_insert"
  ON public.orders
  FOR INSERT
  WITH CHECK (customer_id = get_customer_id());

-- Customers can update ONLY pending orders (for cancellation)
CREATE POLICY "customer_orders_update"
  ON public.orders
  FOR UPDATE
  USING (
    customer_id = get_customer_id() 
    AND status = 'pending'
  )
  WITH CHECK (
    customer_id = get_customer_id() 
    AND status IN ('pending', 'cancelled')
  );

-- Vendors can view orders for their products
CREATE POLICY "vendor_orders_select"
  ON public.orders
  FOR SELECT
  USING (vendor_id = get_vendor_id());

-- Vendors can update order status for their orders
CREATE POLICY "vendor_orders_update"
  ON public.orders
  FOR UPDATE
  USING (vendor_id = get_vendor_id())
  WITH CHECK (vendor_id = get_vendor_id());

-- Admins can view all orders
CREATE POLICY "admin_orders_select"
  ON public.orders
  FOR SELECT
  USING (is_admin());

-- Admins can update any order
CREATE POLICY "admin_orders_update"
  ON public.orders
  FOR UPDATE
  USING (is_admin());

-- =============================================
-- ORDER ITEMS POLICIES
-- =============================================

-- Customers can view items in their own orders
CREATE POLICY "customer_order_items_select"
  ON public.order_items
  FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM public.orders 
      WHERE customer_id = get_customer_id()
    )
  );

-- Customers can create order items for their own orders
CREATE POLICY "customer_order_items_insert"
  ON public.order_items
  FOR INSERT
  WITH CHECK (
    order_id IN (
      SELECT id FROM public.orders 
      WHERE customer_id = get_customer_id()
    )
  );

-- Vendors can view order items for their orders
CREATE POLICY "vendor_order_items_select"
  ON public.order_items
  FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM public.orders 
      WHERE vendor_id = get_vendor_id()
    )
  );

-- Admins can view all order items
CREATE POLICY "admin_order_items_select"
  ON public.order_items
  FOR SELECT
  USING (is_admin());

-- =============================================
-- ORDER STATUS HISTORY POLICIES
-- =============================================

-- Customers can view status history for their orders
CREATE POLICY "customer_order_status_history_select"
  ON public.order_status_history
  FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM public.orders 
      WHERE customer_id = get_customer_id()
    )
  );

-- Vendors can view status history for their orders
CREATE POLICY "vendor_order_status_history_select"
  ON public.order_status_history
  FOR SELECT
  USING (
    order_id IN (
      SELECT id FROM public.orders 
      WHERE vendor_id = get_vendor_id()
    )
  );

-- Admins can view all status history
CREATE POLICY "admin_order_status_history_select"
  ON public.order_status_history
  FOR SELECT
  USING (is_admin());

-- System can insert status history (via trigger)
CREATE POLICY "system_order_status_history_insert"
  ON public.order_status_history
  FOR INSERT
  WITH CHECK (true); -- Trigger handles security

-- =============================================
-- ✅ RLS POLICIES FOR ORDERS SYSTEM COMPLETE
-- =============================================
