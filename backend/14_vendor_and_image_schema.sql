-- =============================================
-- 📷 PHASE 4: VENDOR ONBOARDING & IMAGE SYSTEM
-- =============================================

-- 1. Add image_url to products
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS image_url TEXT;

COMMENT ON COLUMN public.products.image_url IS 'URL of the primary product image';

-- 2. Add doc_url and status fields to vendors for onboarding
ALTER TABLE public.vendors
ADD COLUMN IF NOT EXISTS owner_name TEXT,
ADD COLUMN IF NOT EXISTS email TEXT,
ADD COLUMN IF NOT EXISTS documents JSONB DEFAULT '[]'::JSONB;

COMMENT ON COLUMN public.vendors.documents IS 'List of uploaded verification document URLs';

-- 3. Create Storage Buckets (via SQL for convenience, usually done in dashboard)
-- We'll insert into storage.buckets if using Supabase local/self-hosted or equivalent
-- Note: In hosted Supabase, this might need to be done via API/Dashboard, but we can try SQL.

INSERT INTO storage.buckets (id, name, public)
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('vendor-documents', 'vendor-documents', false) -- Private bucket
ON CONFLICT (id) DO NOTHING;

-- 4. RLS Policies for Storage

-- Product Images: Public Read, Vendor Write (Own images)
CREATE POLICY "Public Access Product Images"
ON storage.objects FOR SELECT
USING ( bucket_id = 'product-images' );

CREATE POLICY "Vendor Upload Product Images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'product-images' AND
  (auth.role() = 'service_role' OR 
   EXISTS (SELECT 1 FROM public.vendors WHERE user_id = auth.uid()))
);

CREATE POLICY "Vendor Update/Delete Product Images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'product-images' AND
  (auth.role() = 'service_role' OR 
   EXISTS (SELECT 1 FROM public.vendors WHERE user_id = auth.uid()))
);

-- Vendor Documents: Admin Read, Vendor Write (Own docs)
CREATE POLICY "Vendor Upload Documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'vendor-documents' AND
  auth.uid()::text = (storage.foldername(name))[1] -- Folder structure: user_id/filename
);

CREATE POLICY "Vendor View Own Documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'vendor-documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Admin View All Documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'vendor-documents' AND
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- =============================================
-- ✅ Schema migration completed
-- =============================================
