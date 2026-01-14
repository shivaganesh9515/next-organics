'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'
import { toast } from 'sonner'
import { CheckCircle, Package, Truck, Loader2 } from 'lucide-react'

interface OrderActionsProps {
  orderId: string
  currentStatus: string
}

const statusFlow = {
  pending: { next: 'confirmed', label: 'Confirm Order', icon: CheckCircle },
  confirmed: { next: 'preparing', label: 'Start Preparing', icon: Package },
  preparing: { next: 'ready', label: 'Mark Ready', icon: CheckCircle },
  ready: { next: 'picked_up', label: 'Handed to Delivery', icon: Truck },
  picked_up: { next: null, label: 'Order Picked Up', icon: null },
  delivered: { next: null, label: 'Delivered', icon: null },
  cancelled: { next: null, label: 'Cancelled', icon: null },
}

export function OrderActions({ orderId, currentStatus }: OrderActionsProps) {
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()

  const currentStep = statusFlow[currentStatus as keyof typeof statusFlow]
  
  if (!currentStep?.next) {
    return (
      <div className="dashboard-card text-center py-6">
        <p className="text-muted-foreground">
          {currentStatus === 'delivered' ? '✅ Order has been delivered' : 
           currentStatus === 'picked_up' ? '🚚 Order is out for delivery' :
           currentStatus === 'cancelled' ? '❌ Order was cancelled' :
           'No actions available'}
        </p>
      </div>
    )
  }

  const handleStatusUpdate = async () => {
    if (!currentStep.next) return
    
    setIsLoading(true)
    const supabase = createClient()

    const { error } = await supabase
      .from('orders')
      .update({ 
        status: currentStep.next,
        updated_at: new Date().toISOString()
      })
      .eq('id', orderId)

    if (error) {
      toast.error('Failed to update order status')
      console.error(error)
    } else {
      // Add to order status history
      await supabase.from('order_status_history').insert({
        order_id: orderId,
        status: currentStep.next,
        notes: `Status updated to ${currentStep.next}`,
      })
      
      toast.success(`Order ${currentStep.next.replace('_', ' ')}!`)
      router.refresh()
    }
    
    setIsLoading(false)
  }

  const Icon = currentStep.icon

  return (
    <div className="dashboard-card">
      <h3 className="font-semibold mb-4">Actions</h3>
      <button
        onClick={handleStatusUpdate}
        disabled={isLoading}
        className="btn btn-primary w-full"
      >
        {isLoading ? (
          <Loader2 className="w-4 h-4 mr-2 animate-spin" />
        ) : Icon ? (
          <Icon className="w-4 h-4 mr-2" />
        ) : null}
        {isLoading ? 'Updating...' : currentStep.label}
      </button>
      <p className="text-xs text-muted-foreground text-center mt-3">
        Current status: <span className="font-medium capitalize">{currentStatus.replace('_', ' ')}</span>
      </p>
    </div>
  )
}
