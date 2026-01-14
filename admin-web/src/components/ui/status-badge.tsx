'use client'

import { cn } from '@/lib/utils'

interface StatusBadgeProps {
  status: string
  className?: string
}

// Map statuses to semantic badge classes
const getStatusClass = (status: string): string => {
  const normalized = status.toLowerCase().replace(/_/g, '')
  
  // GREEN - Success states
  if (['approved', 'completed', 'delivered', 'active', 'enabled', 'success', 'paid'].includes(normalized)) {
    return 'bg-green-100 text-green-700 border border-green-200'
  }
  
  // ORANGE - Pending/Warning states
  if (['pending', 'placed', 'waiting'].includes(normalized)) {
    return 'bg-orange-100 text-orange-700 border border-orange-200'
  }
  
  // BLUE - In Progress states
  if (['confirmed', 'preparing', 'processing', 'inprogress', 'pickedup'].includes(normalized)) {
    return 'bg-blue-100 text-blue-700 border border-blue-200'
  }
  
  // CYAN - Ready states
  if (['ready', 'shipped', 'dispatched'].includes(normalized)) {
    return 'bg-cyan-100 text-cyan-700 border border-cyan-200'
  }
  
  // RED - Error/Cancelled states
  if (['rejected', 'cancelled', 'suspended', 'failed', 'error', 'inactive', 'disabled'].includes(normalized)) {
    return 'bg-red-100 text-red-700 border border-red-200'
  }
  
  // Default - Gray
  return 'bg-gray-100 text-gray-700 border border-gray-200'
}

export function StatusBadge({ status, className }: StatusBadgeProps) {
  const displayStatus = status.replace(/_/g, ' ')
  
  return (
    <span className={cn(
      'inline-flex items-center px-2.5 py-1 rounded-md text-xs font-semibold capitalize',
      getStatusClass(status),
      className
    )}>
      {displayStatus}
    </span>
  )
}
