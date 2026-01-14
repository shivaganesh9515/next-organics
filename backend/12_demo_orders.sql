-- ============================================
-- DEMO ORDERS DATA
-- Creates sample orders for testing dashboard
-- ============================================

-- First, let's create a demo customer
INSERT INTO public.customers (id, full_name, email, phone, created_at)
VALUES (
  gen_random_uuid(),
  'Demo Customer',
  'customer@demo.com',
  '+91 98765 43210',
  NOW()
) ON CONFLICT DO NOTHING;

-- Get vendor IDs for orders
DO $$
DECLARE
  v_vendor_id UUID;
  v_customer_id UUID;
  v_product_id UUID;
  v_order_id UUID;
  v_order_num INTEGER := 1000;
  v_status TEXT[] := ARRAY['pending', 'confirmed', 'preparing', 'ready', 'delivered'];
  v_payment_status TEXT[] := ARRAY['pending', 'completed', 'completed', 'completed', 'completed'];
BEGIN
  -- Get customer ID
  SELECT id INTO v_customer_id FROM public.customers LIMIT 1;
  
  -- If no customer exists, create one
  IF v_customer_id IS NULL THEN
    INSERT INTO public.customers (id, full_name, email, phone)
    VALUES (gen_random_uuid(), 'Demo Customer', 'customer@demo.com', '+91 98765 43210')
    RETURNING id INTO v_customer_id;
  END IF;
  
  -- Create orders for each approved vendor
  FOR v_vendor_id IN 
    SELECT id FROM public.vendors WHERE status = 'approved'
  LOOP
    -- Create 5-10 orders per vendor
    FOR i IN 1..8 LOOP
      v_order_num := v_order_num + 1;
      
      -- Create order
      INSERT INTO public.orders (
        id,
        order_number,
        customer_id,
        vendor_id,
        status,
        payment_status,
        subtotal,
        delivery_fee,
        discount_amount,
        total_amount,
        delivery_instructions,
        created_at
      ) VALUES (
        gen_random_uuid(),
        LPAD(v_order_num::TEXT, 6, '0'),
        v_customer_id,
        v_vendor_id,
        v_status[(i % 5) + 1],
        v_payment_status[(i % 5) + 1],
        (random() * 800 + 200)::numeric(10,2),
        40.00,
        (random() * 50)::numeric(10,2),
        ((random() * 800 + 200) + 40 - (random() * 50))::numeric(10,2),
        CASE WHEN random() > 0.5 THEN 'Leave at door' ELSE 'Ring the bell' END,
        NOW() - (random() * interval '30 days')
      ) RETURNING id INTO v_order_id;
      
      -- Add 2-4 order items
      FOR v_product_id IN 
        SELECT id FROM public.products 
        WHERE vendor_id = v_vendor_id 
        ORDER BY random() 
        LIMIT floor(random() * 3 + 2)::int
      LOOP
        INSERT INTO public.order_items (
          order_id,
          product_id,
          quantity,
          unit_price,
          total_price
        ) VALUES (
          v_order_id,
          v_product_id,
          floor(random() * 3 + 1)::int,
          (random() * 200 + 50)::numeric(10,2),
          ((random() * 200 + 50) * (random() * 3 + 1))::numeric(10,2)
        );
      END LOOP;
      
      -- Add status history
      INSERT INTO public.order_status_history (order_id, status, notes)
      VALUES (v_order_id, 'pending', 'Order placed by customer');
      
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Created demo orders successfully!';
END $$;

-- Verify counts
SELECT 'Orders' as table_name, COUNT(*) as count FROM public.orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM public.order_items
UNION ALL
SELECT 'Status History', COUNT(*) FROM public.order_status_history;
