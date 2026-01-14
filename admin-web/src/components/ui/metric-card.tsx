'use client'

import { TrendingUp, TrendingDown, DollarSign, ShoppingCart, TrendingUp as TrendingUpIcon, Users, AlertTriangle, Package, Clock } from 'lucide-react'

interface MetricCardProps {
  label: string
  value: string | number
  change?: number // percentage change
  icon: string // Changed to string
  trend?: 'up' | 'down'
}

const iconMap: Record<string, React.ComponentType<{ className?: string }>> = {
  'dollar-sign': DollarSign,
  'shopping-cart': ShoppingCart,
  'trending-up': TrendingUpIcon,
  'users': Users,
  'alert-triangle': AlertTriangle,
  'package': Package,
  'clock': Clock,
}

export function MetricCard({ label, value, change, icon, trend }: MetricCardProps) {
  const isPositive = trend === 'up' || (change && change > 0)
  const Icon = iconMap[icon] || Package
  
  return (
    <div className="dashboard-card">
      <div className="flex items-start justify-between mb-3">
        <span className="text-sm text-muted-foreground">{label}</span>
        <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <Icon className="w-5 h-5 text-primary" />
        </div>
      </div>
      
      <div className="space-y-1">
        <div className="text-3xl font-bold">{value}</div>
        
        {change !== undefined && (
          <div className={`flex items-center gap-1 text-sm ${isPositive ? 'text-success' : 'text-destructive'}`}>
            {isPositive ? (
              <TrendingUp className="w-4 h-4" />
            ) : (
              <TrendingDown className="w-4 h-4" />
            )}
            <span className="font-medium">
              {Math.abs(change)}% {isPositive ? 'increase' : 'decrease'}
            </span>
          </div>
        )}
      </div>
    </div>
  )
}
