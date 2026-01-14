import { createClient } from '@/utils/supabase/server'
import { AdminDashboardClient } from './dashboard-client'

export default async function AdminDashboard() {
  const supabase = await createClient()

  // Fetch all data needed for dashboard
  const [ordersResult, vendorsResult, productsResult, categoriesResult] = await Promise.all([
    supabase.from('orders').select('id, total_amount, created_at, status'),
    supabase.from('vendors').select('id, status'),
    supabase.from('products').select('id, stock, category_id'),
    supabase.from('categories').select('id, name')
  ])

  const orders = ordersResult.data || []
  const vendors = vendorsResult.data || []
  const products = productsResult.data || []
  const categories = categoriesResult.data || []

  // Calculate vendor stats
  const totalVendors = vendors.length
  const activeVendors = vendors.filter(v => v.status === 'approved').length

  // Calculate product stats
  const totalProducts = products.length
  const lowStockCount = products.filter(p => p.stock <= 10).length

  // Calculate category distribution
  const categoryData = categories.map((cat, index) => {
    const count = products.filter(p => p.category_id === cat.id).length
    const colors = ['#10b981', '#3b82f6', '#f59e0b', '#ef4444', '#8b5cf6']
    return {
      name: cat.name,
      value: count,
      color: colors[index % colors.length]
    }
  }).filter(c => c.value > 0)

  return (
    <AdminDashboardClient
      orders={orders}
      totalVendors={totalVendors}
      activeVendors={activeVendors}
      totalProducts={totalProducts}
      lowStockCount={lowStockCount}
      categoryData={categoryData}
    />
  )
}
