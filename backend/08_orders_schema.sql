-- =============================================
-- 📦 ORDERS & CUSTOMERS DATABASE SCHEMA
-- Critical missing tables for delivery app functionality
-- =============================================

-- =============================================
-- ENUMS
-- =============================================

-- Order status lifecycle
CREATE TYPE order_status AS ENUM (
  'pending',       -- Order placed, awaiting vendor confirmation
  'confirmed',     -- Vendor confirmed order
  'preparing',     -- Vendor preparing items
  'ready',         -- Ready for pickup
  'out_for_delivery', -- Delivery partner picked up
  'delivered',     -- Successfully delivered
  'cancelled'      -- Cancelled by customer/vendor
);

-- Payment status
CREATE TYPE payment_status AS ENUM (
  'pending',
  'completed',
  'failed',
  'refunded'
);

-- Payment method
CREATE TYPE payment_method AS ENUM (
  'cod',           -- Cash on Delivery
  'upi',           -- UPI
  'card',          -- Credit/Debit Card
  'wallet'         -- Digital Wallet
);

-- =============================================
-- CUSTOMERS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- DELIVERY ADDRESSES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.delivery_addresses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID REFERENCES public.customers(id) ON DELETE CASCADE NOT NULL,
  label TEXT NOT NULL, -- 'Home', 'Work', 'Other'
  address_line TEXT NOT NULL,
  landmark TEXT,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  pincode TEXT NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- ORDERS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number TEXT UNIQUE NOT NULL, -- Format: ORD-20260113-0001
  customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  vendor_id UUID REFERENCES public.vendors(id) ON DELETE SET NULL NOT NULL,
  
  -- Order Details
  status order_status DEFAULT 'pending' NOT NULL,
  
  -- Pricing
  subtotal DECIMAL(10, 2) NOT NULL, -- Sum of items
  delivery_fee DECIMAL(10, 2) DEFAULT 0,
  platform_fee DECIMAL(10, 2) DEFAULT 0,
  tax_amount DECIMAL(10, 2) DEFAULT 0,
  discount_amount DECIMAL(10, 2) DEFAULT 0,
  total_amount DECIMAL(10, 2) NOT NULL,
  
  -- Delivery
  delivery_address_id UUID REFERENCES public.delivery_addresses(id) ON DELETE SET NULL,
  delivery_address_snapshot JSONB, -- Snapshot in case address is deleted
  
  -- Payment
  payment_method payment_method NOT NULL,
  payment_status payment_status DEFAULT 'pending' NOT NULL,
  
  -- Notes
  customer_notes TEXT,
  vendor_notes TEXT,
  cancellation_reason TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  confirmed_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  
  -- Constraints
  CONSTRAINT positive_amounts CHECK (
    subtotal >= 0 AND 
    delivery_fee >= 0 AND 
    platform_fee >= 0 AND 
    tax_amount >= 0 AND 
    discount_amount >= 0 AND 
    total_amount >= 0
  )
);

-- =============================================
-- ORDER ITEMS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE NOT NULL,
  product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
  
  -- Product snapshot (in case product is deleted/modified)
  product_name TEXT NOT NULL,
  product_description TEXT,
  unit_price DECIMAL(10, 2) NOT NULL,
  
  -- Order details
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- ORDER STATUS HISTORY TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS public.order_status_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE NOT NULL,
  status order_status NOT NULL,
  notes TEXT,
  changed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Customers
CREATE INDEX IF NOT EXISTS idx_customers_user_id ON public.customers(user_id);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);

-- Delivery Addresses
CREATE INDEX IF NOT EXISTS idx_delivery_addresses_customer_id ON public.delivery_addresses(customer_id);

-- Orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON public.orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_vendor_id ON public.orders(vendor_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON public.orders(order_number);

-- Order Items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON public.order_items(product_id);

-- Order Status History
CREATE INDEX IF NOT EXISTS idx_order_status_history_order_id ON public.order_status_history(order_id);

-- =============================================
-- TRIGGERS
-- =============================================

-- Update customers timestamp
CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON public.customers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Auto-create order status history
CREATE OR REPLACE FUNCTION log_order_status_change()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.order_status_history (order_id, status, changed_by)
  VALUES (NEW.id, NEW.status, auth.uid());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER log_order_status_on_insert
  AFTER INSERT ON public.orders
  FOR EACH ROW
  EXECUTE FUNCTION log_order_status_change();

CREATE TRIGGER log_order_status_on_update
  AFTER UPDATE OF status ON public.orders
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status)
  EXECUTE FUNCTION log_order_status_change();

-- =============================================
-- ✅ Orders system schema created!
-- =============================================
