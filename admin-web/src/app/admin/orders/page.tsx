import { createClient } from '@/utils/supabase/server'
import { PageHeader, EmptyState } from '@/components/ui/page-components'
import { ShoppingBag } from 'lucide-react'
import { StatusBadge } from '@/components/ui/status-badge'

export default async function OrdersPage() {
  const supabase = await createClient()

  // Get actual orders from the orders table
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
      ),
      vendors:vendor_id (
        shop_name
      )
    `)
    .order('created_at', { ascending: false })
    .limit(50)

  return (
    <div>
      <PageHeader 
        title="Orders Management" 
        description="View and manage all customer orders"
      />

      <div className="dashboard-card">
        {!orders || orders.length === 0 ? (
          <EmptyState 
            icon={ShoppingBag}
            title="No Orders Yet"
            description="Customer orders will appear here once they start placing orders through the app"
          />
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Order #</th>
                  <th>Customer</th>
                  <th>Vendor</th>
                  <th>Amount</th>
                  <th>Order Status</th>
                  <th>Payment</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                {orders.map((order) => {
                  const customer = order.customers as { full_name: string; phone: string } | null
                  const vendor = order.vendors as { shop_name: string } | null
                  return (
                    <tr key={order.id}>
                      <td className="font-medium">#{order.order_number}</td>
                      <td>
                        <div>
                          <p className="font-medium">{customer?.full_name || 'Unknown'}</p>
                          <p className="text-xs text-muted-foreground">{customer?.phone || '—'}</p>
                        </div>
                      </td>
                      <td className="text-muted-foreground">{vendor?.shop_name || 'Unknown'}</td>
                      <td className="font-medium">₹{order.total_amount.toFixed(2)}</td>
                      <td>
                        <StatusBadge status={order.status} />
                      </td>
                      <td>
                        <StatusBadge status={order.payment_status} />
                      </td>
                      <td className="text-muted-foreground text-sm">
                        {new Date(order.created_at).toLocaleString()}
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
