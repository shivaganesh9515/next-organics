import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { StatusBadge } from '@/components/ui/status-badge'
import { ArrowLeft, Clock, Package, CheckCircle, Truck, MapPin, Phone, User } from 'lucide-react'
import Link from 'next/link'
import { redirect, notFound } from 'next/navigation'
import { OrderActions } from './order-actions'

interface PageProps {
  params: Promise<{ id: string }>
}

export default async function VendorOrderDetailPage({ params }: PageProps) {
  const { id } = await params
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

  // Get order details
  const { data: order } = await supabase
    .from('orders')
    .select(`
      *,
      customers:customer_id (
        full_name,
        phone,
        email
      ),
      delivery_addresses:delivery_address_id (
        address_line1,
        address_line2,
        city,
        state,
        pincode,
        landmark
      )
    `)
    .eq('id', id)
    .eq('vendor_id', vendor.id)
    .single()

  if (!order) notFound()

  // Get order items
  const { data: orderItems } = await supabase
    .from('order_items')
    .select(`
      *,
      products:product_id (
        name,
        price
      )
    `)
    .eq('order_id', id)

  const customer = order.customers as { full_name: string; phone: string; email: string } | null
  const address = order.delivery_addresses as { 
    address_line1: string;
    address_line2?: string;
    city: string;
    state: string;
    pincode: string;
    landmark?: string;
  } | null

  const statusSteps = ['pending', 'confirmed', 'preparing', 'ready', 'picked_up', 'delivered']
  const currentStatusIndex = statusSteps.indexOf(order.status)

  return (
    <div>
      <div className="mb-6">
        <Link 
          href="/vendor/orders" 
          className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to Orders
        </Link>
      </div>

      <PageHeader 
        title={`Order #${order.order_number}`}
        description={`Placed on ${new Date(order.created_at).toLocaleString()}`}
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Order Info */}
        <div className="lg:col-span-2 space-y-6">
          {/* Order Status Timeline */}
          <div className="dashboard-card">
            <h3 className="font-semibold mb-4">Order Progress</h3>
            <div className="flex items-center justify-between relative">
              {/* Progress Line */}
              <div className="absolute top-4 left-0 right-0 h-1 bg-muted">
                <div 
                  className="h-full bg-primary transition-all"
                  style={{ width: `${(currentStatusIndex / (statusSteps.length - 1)) * 100}%` }}
                />
              </div>
              
              {statusSteps.map((step, index) => {
                const isActive = index <= currentStatusIndex
                const isCurrent = index === currentStatusIndex
                return (
                  <div key={step} className="relative flex flex-col items-center z-10">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                      isActive ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground'
                    } ${isCurrent ? 'ring-4 ring-primary/20' : ''}`}>
                      {index === 0 && <Clock className="w-4 h-4" />}
                      {index === 1 && <CheckCircle className="w-4 h-4" />}
                      {index === 2 && <Package className="w-4 h-4" />}
                      {index === 3 && <CheckCircle className="w-4 h-4" />}
                      {index === 4 && <Truck className="w-4 h-4" />}
                      {index === 5 && <MapPin className="w-4 h-4" />}
                    </div>
                    <span className={`text-xs mt-2 capitalize ${isActive ? 'text-foreground font-medium' : 'text-muted-foreground'}`}>
                      {step.replace('_', ' ')}
                    </span>
                  </div>
                )
              })}
            </div>
          </div>

          {/* Order Items */}
          <div className="dashboard-card">
            <h3 className="font-semibold mb-4">Order Items</h3>
            {orderItems && orderItems.length > 0 ? (
              <div className="space-y-3">
                {orderItems.map((item) => {
                  const product = item.products as { name: string; price: number } | null
                  return (
                    <div key={item.id} className="flex items-center justify-between py-3 border-b last:border-0">
                      <div className="flex items-center gap-3">
                        <div className="w-12 h-12 bg-muted rounded-lg flex items-center justify-center">
                          <Package className="w-6 h-6 text-muted-foreground" />
                        </div>
                        <div>
                          <p className="font-medium">{product?.name || 'Unknown Product'}</p>
                          <p className="text-sm text-muted-foreground">₹{item.unit_price} × {item.quantity}</p>
                        </div>
                      </div>
                      <p className="font-semibold">₹{item.total_price.toFixed(2)}</p>
                    </div>
                  )
                })}
              </div>
            ) : (
              <p className="text-muted-foreground text-center py-6">No items in this order</p>
            )}
          </div>

          {/* Order Actions */}
          <OrderActions orderId={order.id} currentStatus={order.status} />
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Price Summary */}
          <div className="dashboard-card">
            <h3 className="font-semibold mb-4">Payment Summary</h3>
            <div className="space-y-3">
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Subtotal</span>
                <span>₹{order.subtotal?.toFixed(2) || '0.00'}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Delivery Fee</span>
                <span>₹{order.delivery_fee?.toFixed(2) || '0.00'}</span>
              </div>
              {order.discount_amount > 0 && (
                <div className="flex justify-between text-sm text-success">
                  <span>Discount</span>
                  <span>-₹{order.discount_amount.toFixed(2)}</span>
                </div>
              )}
              <div className="border-t pt-3 flex justify-between font-semibold">
                <span>Total</span>
                <span>₹{order.total_amount.toFixed(2)}</span>
              </div>
              <div className="pt-2">
                <StatusBadge status={order.payment_status} />
              </div>
            </div>
          </div>

          {/* Customer Info */}
          <div className="dashboard-card">
            <h3 className="font-semibold mb-4">Customer</h3>
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-muted flex items-center justify-center">
                  <User className="w-5 h-5 text-muted-foreground" />
                </div>
                <div>
                  <p className="font-medium">{customer?.full_name || 'Unknown'}</p>
                  <p className="text-sm text-muted-foreground">{customer?.email || '—'}</p>
                </div>
              </div>
              {customer?.phone && (
                <div className="flex items-center gap-2 text-sm">
                  <Phone className="w-4 h-4 text-muted-foreground" />
                  <span>{customer.phone}</span>
                </div>
              )}
            </div>
          </div>

          {/* Delivery Address */}
          {address && (
            <div className="dashboard-card">
              <h3 className="font-semibold mb-4">Delivery Address</h3>
              <div className="flex items-start gap-2">
                <MapPin className="w-4 h-4 text-muted-foreground mt-1 flex-shrink-0" />
                <div className="text-sm">
                  <p>{address.address_line1}</p>
                  {address.address_line2 && <p>{address.address_line2}</p>}
                  <p>{address.city}, {address.state} {address.pincode}</p>
                  {address.landmark && (
                    <p className="text-muted-foreground mt-1">Landmark: {address.landmark}</p>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
