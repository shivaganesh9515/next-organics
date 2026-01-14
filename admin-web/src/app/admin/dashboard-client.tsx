'use client'

import { useState, useMemo } from 'react'
import { MetricCard } from '@/components/ui/metric-card'
import { RevenueChart } from '@/components/charts/revenue-chart'
import { CategoryDistribution } from '@/components/charts/category-distribution'
import { DateRangePicker, DateRangePreset } from '@/components/ui/date-range-picker'
import { StatusBadge } from '@/components/ui/status-badge'
import { ShoppingCart, RefreshCw } from 'lucide-react'
import Link from 'next/link'

interface Order {
  id: string
  total_amount: number
  created_at: string
  status: string
}

interface AdminDashboardClientProps {
  orders: Order[]
  totalVendors: number
  activeVendors: number
  totalProducts: number
  lowStockCount: number
  categoryData: Array<{ name: string; value: number; color: string }>
}

export function AdminDashboardClient({
  orders,
  totalVendors,
  activeVendors,
  totalProducts,
  lowStockCount,
  categoryData
}: AdminDashboardClientProps) {
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
  const avgOrderValue = filteredOrders.length > 0 ? totalRevenue / filteredOrders.length : 0
  const cancelledOrders = filteredOrders.filter(o => o.status === 'cancelled').length

  // Prepare chart data
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

  return (
    <div className="space-y-6">
      {/* Header with Date Picker */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Dashboard Overview</h1>
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

      {/* Top Metric Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
        <MetricCard
          label="Total Revenue"
          value={`₹${totalRevenue.toFixed(2)}`}
          change={12.5}
          icon="dollar-sign"
          trend="up"
        />
        <MetricCard
          label="Today's Orders"
          value={todayOrders}
          change={8.2}
          icon="shopping-cart"
          trend="up"
        />
        <MetricCard
          label="Avg Order Value"
          value={`₹${avgOrderValue.toFixed(2)}`}
          icon="trending-up"
        />
        <MetricCard
          label="Active Vendors"
          value={`${activeVendors}/${totalVendors}`}
          icon="users"
        />
        <MetricCard
          label="Low Stock Items"
          value={lowStockCount}
          icon="alert-triangle"
        />
        <MetricCard
          label="Cancelled Orders"
          value={cancelledOrders}
          change={cancelledOrders > 0 ? -15.3 : undefined}
          icon="package"
          trend={cancelledOrders > 0 ? "down" : undefined}
        />
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Revenue Chart */}
        <div className="lg:col-span-2 dashboard-card">
          <div className="mb-4">
            <h3 className="text-lg font-semibold">Revenue Overview</h3>
            <p className="text-sm text-muted-foreground">
              {dateRange === 'today' ? "Today's" : dateRange === 'week' ? 'Last 7 days' : 'Last 30 days'} revenue trend
            </p>
          </div>
          <RevenueChart data={chartData} period={dateRange === 'today' ? 'day' : 'week'} />
        </div>

        {/* Category Distribution */}
        <div className="dashboard-card">
          <div className="mb-4">
            <h3 className="text-lg font-semibold">Products by Category</h3>
            <p className="text-sm text-muted-foreground">Distribution breakdown</p>
          </div>
          <CategoryDistribution data={categoryData} title="Categories" />
        </div>
      </div>

      {/* Recent Orders */}
      <div className="dashboard-card">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-lg font-semibold">Recent Orders</h3>
            <p className="text-sm text-muted-foreground">Latest customer orders</p>
          </div>
          <Link href="/admin/orders" className="btn btn-ghost btn-sm">
            View All →
          </Link>
        </div>

        {filteredOrders.length === 0 ? (
          <div className="text-center py-12 text-muted-foreground">
            <ShoppingCart className="w-8 h-8 mx-auto mb-2 opacity-50" />
            <p>No orders in this period</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Order ID</th>
                  <th>Amount</th>
                  <th>Status</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                {filteredOrders.slice(0, 10).map((order) => (
                  <tr key={order.id}>
                    <td className="font-medium">#{order.id.slice(0, 8)}</td>
                    <td className="font-medium">₹{order.total_amount.toFixed(2)}</td>
                    <td><StatusBadge status={order.status} /></td>
                    <td className="text-muted-foreground text-sm">
                      {new Date(order.created_at).toLocaleString()}
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
