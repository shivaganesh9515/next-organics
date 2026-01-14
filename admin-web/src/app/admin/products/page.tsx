import { createClient } from '@/utils/supabase/server'
import { PageHeader, EmptyState } from '@/components/ui/page-components'
import { Package } from 'lucide-react'
import { AdminProductsClient } from './products-client'

export default async function ProductsPage() {
  const supabase = await createClient()

  // Get all products with vendor and category info
  const { data: products, error: productsError } = await supabase
    .from('products')
    .select(`
      id,
      name,
      description,
      price,
      stock,
      is_active,
      image_url,
      category_id,
      vendor_id,
      categories:category_id (
        id,
        name
      ),
      vendors:vendor_id (
        id,
        shop_name
      )
    `)
    .order('name', { ascending: true })

  // Log errors for debugging
  if (productsError) {
    console.error('Admin Products fetch error:', productsError)
  }
  
  console.log('Admin - Products found:', products?.length || 0)

  return (
    <div>
      <PageHeader 
        title="Product Oversight" 
        description={`View and monitor all products across vendors${products ? ` • Total: ${products.length} products` : ''}`}
      />

      {!products || products.length === 0 ? (
        <div className="dashboard-card">
          <EmptyState 
            icon={Package}
            title="No Products Yet"
            description="Products will appear here as vendors add them"
          />
        </div>
      ) : (
        <AdminProductsClient products={products} />
      )}
    </div>
  )
}
