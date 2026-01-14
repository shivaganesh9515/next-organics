'use client'

import { useState, useMemo } from 'react'
import { MetricCard } from '@/components/ui/metric-card'
import { RevenueChart } from '@/components/charts/revenue-chart'
import { TopProductsChart } from '@/components/charts/top-products-chart'
import { DateRangePicker, DateRangePreset } from '@/components/ui/date-range-picker'
import { PageHeader } from '@/components/ui/page-components'
import { AlertTriangle, Package, ShoppingCart, RefreshCw } from 'lucide-react'
import Link from 'next/link'

interface Order {
  id: string
  total_amount: number
  status: string
  created_at: string
}

interface Product {
  id: string
  name: string
  price: number
  stock: number
}

interface VendorDashboardClientProps {
  shopName: string
  orders: Order[]
  products: Product[]
  lowStockCount: number
}

export function VendorDashboardClient({
  shopName,
  orders,
  products,
  lowStockCount
}: VendorDashboardClientProps) {
  const [dateRange, setDateRange] = useState<DateRangePreset>('week')
  const [lastUpdated] = useState(new Date())

  // Filter orders based on date range
  const filteredOrders = useMemo(() => {
    const now = new Date()
    let startDate: Date

    switch (dateRange) {
      case 'today':
        startDate = new Date(now.setHours(0, 0, 0, 0))
        break
      case 'week':
        startDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
        break
      case 'month':
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
        break
      default:
        startDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    }

    return orders.filter(o => new Date(o.created_at) >= startDate)
  }, [orders, dateRange])

  // Calculate metrics
  const totalRevenue = filteredOrders.reduce((sum, o) => sum + o.total_amount, 0)
  const todayOrders = orders.filter(o => 
    new Date(o.created_at).toDateString() === new Date().toDateString()
  ).length
  const pendingOrders = orders.filter(o => 
    o.status === 'pending' || o.status === 'confirmed'
  ).length

  // Revenue chart data
  const days = dateRange === 'today' ? 1 : dateRange === 'week' ? 7 : 30
  const chartData = Array.from({ length: Math.min(days, 7) }, (_, i) => {
    const date = new Date()
    date.setDate(date.getDate() - (Math.min(days, 7) - 1 - i))
    const dateStr = date.toISOString().split('T')[0]
    const dayOrders = orders.filter(o => o.created_at.startsWith(dateStr))
    const revenue = dayOrders.reduce((sum, o) => sum + o.total_amount, 0)
    return { 
      date: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }), 
      revenue 
    }
  })

  // Top products by stock value
  const topProducts = products
    .map(p => ({ name: p.name.slice(0, 20) + (p.name.length > 20 ? '...' : ''), revenue: p.price * Math.max(0, p.stock) }))
    .sort((a, b) => b.revenue - a.revenue)
    .slice(0, 5)

  return (
    <div className="space-y-6">
      {/* Header with Date Picker */}
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-2xl font-bold">Welcome back, {shopName}</h1>
          <p className="text-sm text-muted-foreground flex items-center gap-2 mt-1">
            <RefreshCw className="w-3 h-3" />
            Last updated: {lastUpdated.toLocaleTimeString()}
          </p>
        </div>
        <DateRangePicker 
          currentPreset={dateRange}
          onRangeChange={(preset) => setDateRange(preset)}
        />
      </div>

      {/* Top Performance Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard
          label="Total Revenue"
          value={`₹${totalRevenue.toFixed(2)}`}
          change={15.3}
          icon="dollar-sign"
          trend="up"
        />
        <MetricCard
          label="Orders Today"
          value={todayOrders}
          icon="shopping-cart"
        />
        <MetricCard
          label="Pending Orders"
          value={pendingOrders}
          icon="clock"
        />
        <MetricCard
          label="Low Stock Items"
          value={lowStockCount}
          icon="alert-triangle"
        />
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Revenue Trend */}
        <div className="dashboard-card">
          <div className="mb-4">
            <h3 className="text-lg font-semibold">Revenue Trend</h3>
            <p className="text-sm text-muted-foreground">
              {dateRange === 'today' ? "Today's" : dateRange === 'week' ? 'Last 7 days' : 'Last 30 days'} performance
            </p>
          </div>
          <RevenueChart data={chartData} period={dateRange === 'today' ? 'day' : 'week'} />
        </div>

        {/* Top Products */}
        <div className="dashboard-card">
          <div className="mb-4">
            <h3 className="text-lg font-semibold">Top Products by Value</h3>
            <p className="text-sm text-muted-foreground">Stock value ranking</p>
          </div>
          {topProducts.length > 0 ? (
            <TopProductsChart data={topProducts} />
          ) : (
            <div className="h-[300px] flex items-center justify-center text-muted-foreground">
              No products available
            </div>
          )}
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Link href="/vendor/products" className="dashboard-card group hover:border-primary transition-colors">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center group-hover:bg-primary/20 transition-colors">
              <Package className="w-6 h-6 text-primary" />
            </div>
            <div className="flex-1">
              <h3 className="font-medium">Manage Products</h3>
              <p className="text-sm text-muted-foreground">{products.length} products total</p>
            </div>
            <div className="text-muted-foreground group-hover:text-foreground transition-colors">→</div>
          </div>
        </Link>

        <Link href="/vendor/orders" className="dashboard-card group hover:border-primary transition-colors">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-lg bg-info/10 flex items-center justify-center group-hover:bg-info/20 transition-colors">
              <ShoppingCart className="w-6 h-6 text-info" />
            </div>
            <div className="flex-1">
              <h3 className="font-medium">View Orders</h3>
              <p className="text-sm text-muted-foreground">{pendingOrders} pending</p>
            </div>
            <div className="text-muted-foreground group-hover:text-foreground transition-colors">→</div>
          </div>
        </Link>

        <Link href="/vendor/stock" className="dashboard-card group hover:border-primary transition-colors">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-lg bg-warning/10 flex items-center justify-center group-hover:bg-warning/20 transition-colors">
              <AlertTriangle className="w-6 h-6 text-warning" />
            </div>
            <div className="flex-1">
              <h3 className="font-medium">Update Stock</h3>
              <p className="text-sm text-muted-foreground">{lowStockCount} low stock items</p>
            </div>
            <div className="text-muted-foreground group-hover:text-foreground transition-colors">→</div>
          </div>
        </Link>
      </div>

      {/* Low Stock Warning */}
      {lowStockCount > 0 && (
        <div className="dashboard-card border-warning/30 bg-warning/5">
          <div className="flex items-center gap-3">
            <AlertTriangle className="w-5 h-5 text-warning flex-shrink-0" />
            <div className="flex-1">
              <p className="text-sm font-medium">Low Stock Alert</p>
              <p className="text-sm text-muted-foreground">
                {lowStockCount} products have low stock (≤10 units).{' '}
                <Link href="/vendor/stock" className="text-warning hover:underline">
                  Update stock →
                </Link>
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
