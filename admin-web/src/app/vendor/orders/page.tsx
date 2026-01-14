import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { StatusBadge } from '@/components/ui/status-badge'
import { ShoppingBag, Clock, CheckCircle, Package } from 'lucide-react'
import Link from 'next/link'
import { redirect } from 'next/navigation'

export default async function VendorOrdersPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) redirect('/login')

  // Get vendor
  const { data: vendor } = await supabase
    .from('vendors')
    .select('id, shop_name')
    .eq('user_id', user.id)
    .single()

  if (!vendor) redirect('/vendor')

  // Get orders for this vendor
  const { data: orders } = await supabase
    .from('orders')
    .select(`
      id,
      order_number,
      status,
      payment_status,
      total_amount,
      created_at,
      customers:customer_id (
        full_name,
        phone
      )
    `)
    .eq('vendor_id', vendor.id)
    .order('created_at', { ascending: false })

  // Count by status
  const pending = orders?.filter(o => o.status === 'pending').length || 0
  const confirmed = orders?.filter(o => o.status === 'confirmed').length || 0
  const preparing = orders?.filter(o => o.status === 'preparing').length || 0
  const ready = orders?.filter(o => o.status === 'ready').length || 0

  return (
    <div>
      <PageHeader 
        title="Orders Management" 
        description="Manage and fulfill customer orders"
      />

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="dashboard-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-warning/10 flex items-center justify-center">
              <Clock className="w-5 h-5 text-warning" />
            </div>
            <div>
              <p className="text-2xl font-bold">{pending}</p>
              <p className="text-xs text-muted-foreground">Pending</p>
            </div>
          </div>
        </div>

        <div className="dashboard-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-info/10 flex items-center justify-center">
              <CheckCircle className="w-5 h-5 text-info" />
            </div>
            <div>
              <p className="text-2xl font-bold">{confirmed}</p>
              <p className="text-xs text-muted-foreground">Confirmed</p>
            </div>
          </div>
        </div>

        <div className="dashboard-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
              <Package className="w-5 h-5 text-primary" />
            </div>
            <div>
              <p className="text-2xl font-bold">{preparing}</p>
              <p className="text-xs text-muted-foreground">Preparing</p>
            </div>
          </div>
        </div>

        <div className="dashboard-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-success/10 flex items-center justify-center">
              <CheckCircle className="w-5 h-5 text-success" />
            </div>
            <div>
              <p className="text-2xl font-bold">{ready}</p>
              <p className="text-xs text-muted-foreground">Ready</p>
            </div>
          </div>
        </div>
      </div>

      {/* Orders Table */}
      <div className="dashboard-card">
        <h3 className="text-lg font-semibold mb-4">Recent Orders</h3>
        
        {!orders || orders.length === 0 ? (
          <div className="text-center py-12">
            <ShoppingBag className="w-12 h-12 mx-auto mb-3 text-muted-foreground/50" />
            <h3 className="text-lg font-semibold mb-1">No Orders Yet</h3>
            <p className="text-sm text-muted-foreground">
              Orders from customers will appear here when they place orders
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Order #</th>
                  <th>Customer</th>
                  <th>Amount</th>
                  <th>Status</th>
                  <th>Payment</th>
                  <th>Date</th>
                  <th className="text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                {orders.map((order) => {
                  const customer = order.customers as { full_name: string; phone: string } | null
                  return (
                    <tr key={order.id}>
                      <td className="font-medium">#{order.order_number}</td>
                      <td>
                        <div>
                          <p className="font-medium text-sm">{customer?.full_name || 'Customer'}</p>
                          <p className="text-xs text-muted-foreground">{customer?.phone || '—'}</p>
                        </div>
                      </td>
                      <td className="font-medium">₹{order.total_amount.toFixed(2)}</td>
                      <td><StatusBadge status={order.status} /></td>
                      <td><StatusBadge status={order.payment_status} /></td>
                      <td className="text-sm text-muted-foreground">
                        {new Date(order.created_at).toLocaleDateString()}
                      </td>
                      <td className="text-right">
                        <Link 
                          href={`/vendor/orders/${order.id}`}
                          className="btn btn-ghost btn-sm"
                        >
                          View
                        </Link>
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
