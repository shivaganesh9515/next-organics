import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { Package, Plus } from 'lucide-react'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { VendorProductsClient } from './products-client'

export default async function VendorProductsPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) redirect('/login')

  // Get vendor
  const { data: vendor } = await supabase
    .from('vendors')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!vendor) redirect('/vendor')

  // Get products with category info
  const { data: products, error: productsError } = await supabase
    .from('products')
    .select(`
      id,
      name,
      description,
      price,
      stock,
      image_url,
      is_active,
      category_id,
      categories:category_id (
        id,
        name
      )
    `)
    .eq('vendor_id', vendor.id)
    .order('name', { ascending: true })

  // Log errors for debugging
  if (productsError) {
    console.error('Products fetch error:', productsError)
  }
  
  console.log('Vendor ID:', vendor.id)
  console.log('Products found:', products?.length || 0)
  console.log('Products data:', products)

  return (
    <div>
      <PageHeader 
        title="My Products" 
        description="Manage your product catalog"
      >
        <Link href="/vendor/products/add" className="btn btn-primary">
          <Plus className="w-4 h-4 mr-2" />
          Add Product
        </Link>
      </PageHeader>

      {!products || products.length === 0 ? (
        <div className="dashboard-card">
          <div className="text-center py-12 text-muted-foreground">
            <Package className="w-8 h-8 mx-auto mb-2 opacity-50" />
            <p className="mb-4">No products yet</p>
            <Link href="/vendor/products/add" className="btn btn-primary">
              Add Your First Product
            </Link>
          </div>
        </div>
      ) : (
        <VendorProductsClient products={products} />
      )}
    </div>
  )
}
