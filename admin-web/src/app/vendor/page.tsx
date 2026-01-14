import { createClient } from '@/utils/supabase/server'
import { VendorDashboardClient } from './dashboard-client'
import { AlertTriangle } from 'lucide-react'
import { redirect } from 'next/navigation'

export default async function VendorDashboard() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) redirect('/login')

  // Get vendor info
  const { data: vendor } = await supabase
    .from('vendors')
    .select('id, shop_name, status')
    .eq('user_id', user.id)
    .single()

  if (!vendor || vendor.status !== 'approved') {
    return (
      <div className="text-center py-16">
        <AlertTriangle className="w-12 h-12 text-warning mx-auto mb-4" />
        <h2 className="text-xl font-semibold mb-2">Account Not Approved</h2>
        <p className="text-muted-foreground">
          Your vendor account is currently {vendor?.status || 'pending'}.
          Please wait for admin approval.
        </p>
      </div>
    )
  }

  // Fetch vendor analytics data
  const [productsResult, ordersResult, lowStockResult] = await Promise.all([
    supabase.from('products')
      .select('id, name, price, stock')
      .eq('vendor_id', vendor.id),
    supabase.from('orders')
      .select('id, total_amount, status, created_at')
      .eq('vendor_id', vendor.id),
    supabase.from('products')
      .select('id')
      .eq('vendor_id', vendor.id)
      .lte('stock', 10)
  ])

  const products = productsResult.data || []
  const orders = ordersResult.data || []
  const lowStockCount = lowStockResult.data?.length || 0

  return (
    <VendorDashboardClient
      shopName={vendor.shop_name}
      orders={orders}
      products={products}
      lowStockCount={lowStockCount}
    />
  )
}
