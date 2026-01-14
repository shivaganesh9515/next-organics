import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { Boxes } from 'lucide-react'
import { redirect } from 'next/navigation'
import { StockUpdateForm } from './stock-form'

export default async function VendorStockPage() {
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

  // Get products with low stock first
  const { data: products } = await supabase
    .from('products')
    .select('id, name, stock')
    .eq('vendor_id', vendor.id)
    .order('stock', { ascending: true })

  return (
    <div>
      <PageHeader 
        title="Stock Management" 
        description="Update inventory levels for your products"
      />

      <div className="dashboard-card">
        {!products || products.length === 0 ? (
          <div className="text-center py-12 text-muted-foreground">
            <Boxes className="w-8 h-8 mx-auto mb-2 opacity-50" />
            <p>No products to manage</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Current Stock</th>
                  <th>Update</th>
                </tr>
              </thead>
              <tbody>
                {products.map((product) => (
                  <tr key={product.id}>
                    <td className="font-medium">{product.name}</td>
                    <td>
                      <span className={product.stock <= 10 ? 'text-destructive font-medium' : ''}>
                        {product.stock} units
                      </span>
                      {product.stock <= 10 && (
                        <span className="ml-2 text-xs text-warning">Low stock</span>
                      )}
                    </td>
                    <td>
                      <StockUpdateForm 
                        productId={product.id} 
                        vendorId={vendor.id}
                        currentStock={product.stock} 
                      />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
