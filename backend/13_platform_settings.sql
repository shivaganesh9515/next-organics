-- Platform Settings Table
-- Run this in Supabase SQL Editor to create the settings table

CREATE TABLE IF NOT EXISTS public.platform_settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  platform_commission DECIMAL(5,2) DEFAULT 10.00,
  delivery_fee_base DECIMAL(10,2) DEFAULT 40.00,
  delivery_fee_per_km DECIMAL(10,2) DEFAULT 5.00,
  min_order_amount DECIMAL(10,2) DEFAULT 100.00,
  tax_percentage DECIMAL(5,2) DEFAULT 5.00,
  free_delivery_threshold DECIMAL(10,2) DEFAULT 500.00,
  max_delivery_radius_km INTEGER DEFAULT 15,
  order_auto_cancel_hours INTEGER DEFAULT 24,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  CONSTRAINT single_row CHECK (id = 1)
);

-- Insert default settings
INSERT INTO public.platform_settings (id)
VALUES (1)
ON CONFLICT (id) DO NOTHING;

-- Enable RLS
ALTER TABLE public.platform_settings ENABLE ROW LEVEL SECURITY;

-- Admin can read/write
CREATE POLICY "Admins can view settings"
  ON public.platform_settings FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Admins can update settings"
  ON public.platform_settings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Admins can insert settings"
  ON public.platform_settings FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Verify
SELECT * FROM public.platform_settings;
