import { redirect } from 'next/navigation'
import { getUserWithRole, isVendor, isVendorApproved, isVendorPending } from '@/lib/auth/utils'
import { VENDOR_LOGIN_PATH, VENDOR_PENDING_PATH } from '@/lib/auth/constants'
import { Package, ShoppingBag, TrendingUp, ArrowUpRight, Plus } from 'lucide-react'
import Link from 'next/link'

export default async function VendorDashboardPage() {
    const user = await getUserWithRole()

    if (!user || !isVendor(user)) {
        redirect(VENDOR_LOGIN_PATH)
    }

    if (isVendorPending(user)) {
        redirect(VENDOR_PENDING_PATH)
    }

    if (!isVendorApproved(user)) {
        redirect(VENDOR_LOGIN_PATH)
    }

    return (
        <div className="space-y-8">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-3xl font-bold text-white">Dashboard</h1>
                    <p className="text-gray-400 mt-1">Welcome back, {user.name || 'Vendor'}</p>
                </div>
                <Link
                    href="/inventory/new"
                    className="flex items-center gap-2 bg-gradient-to-r from-orange-600 to-amber-600 text-white font-semibold px-5 py-2.5 rounded-xl hover:from-orange-500 hover:to-amber-500 transition-all shadow-lg shadow-orange-900/20"
                >
                    <Plus className="w-4 h-4" />
                    Add Product
                </Link>
            </div>

            {/* Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <StatCard
                    title="Active Products"
                    value="23"
                    change="+2 this week"
                    icon={Package}
                    color="orange"
                />
                <StatCard
                    title="Total Orders"
                    value="156"
                    change="+18 this week"
                    icon={ShoppingBag}
                    color="emerald"
                />
                <StatCard
                    title="Revenue"
                    value="₹45,230"
                    change="+12% vs last month"
                    icon={TrendingUp}
                    color="blue"
                />
            </div>

            {/* Quick Actions */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <QuickActionCard
                    title="Manage Inventory"
                    description="View and update your product catalog"
                    href="/inventory"
                    action="Go to Inventory"
                />
                <QuickActionCard
                    title="View Orders"
                    description="Track and manage customer orders"
                    href="/orders"
                    action="View All Orders"
                />
            </div>

            {/* Recent Orders */}
            <div className="bg-gray-900/50 backdrop-blur-sm border border-white/10 rounded-2xl p-6">
                <h2 className="text-lg font-semibold text-white mb-4">Recent Orders</h2>
                <div className="space-y-3">
                    <OrderRow orderId="ORD-1234" product="Organic Honey" qty={2} status="Processing" />
                    <OrderRow orderId="ORD-1233" product="Almonds 500g" qty={5} status="Shipped" />
                    <OrderRow orderId="ORD-1232" product="Turmeric Powder" qty={3} status="Delivered" />
                </div>
                <Link
                    href="/orders"
                    className="block mt-4 text-center text-orange-400 text-sm font-medium hover:text-orange-300 transition-colors"
                >
                    View All Orders →
                </Link>
            </div>
        </div>
    )
}

function StatCard({
    title,
    value,
    change,
    icon: Icon,
    color
}: {
    title: string
    value: string
    change: string
    icon: any
    color: 'orange' | 'emerald' | 'blue'
}) {
    const colorClasses = {
        orange: 'bg-orange-500/10 text-orange-400 border-orange-500/20',
        emerald: 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20',
        blue: 'bg-blue-500/10 text-blue-400 border-blue-500/20',
    }

    return (
        <div className="bg-gray-900/50 backdrop-blur-sm border border-white/10 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-4">
                <div className={`w-12 h-12 rounded-xl ${colorClasses[color]} border flex items-center justify-center`}>
                    <Icon className="w-6 h-6" />
                </div>
            </div>
            <h3 className="text-gray-400 text-sm font-medium">{title}</h3>
            <p className="text-2xl font-bold text-white mt-1">{value}</p>
            <p className="text-xs text-gray-500 mt-2">{change}</p>
        </div>
    )
}

function QuickActionCard({
    title,
    description,
    href,
    action
}: {
    title: string
    description: string
    href: string
    action: string
}) {
    return (
        <Link
            href={href}
            className="block bg-gray-900/50 backdrop-blur-sm border border-white/10 rounded-2xl p-6 hover:bg-gray-800/50 hover:border-orange-500/30 transition-all group"
        >
            <h3 className="text-white font-semibold">{title}</h3>
            <p className="text-gray-400 text-sm mt-1">{description}</p>
            <div className="flex items-center gap-1 mt-4 text-orange-400 text-sm font-medium group-hover:text-orange-300 transition-colors">
                {action}
                <ArrowUpRight className="w-4 h-4" />
            </div>
        </Link>
    )
}

function OrderRow({
    orderId,
    product,
    qty,
    status
}: {
    orderId: string
    product: string
    qty: number
    status: 'Processing' | 'Shipped' | 'Delivered'
}) {
    const statusColors = {
        Processing: 'bg-yellow-500/20 text-yellow-400',
        Shipped: 'bg-blue-500/20 text-blue-400',
        Delivered: 'bg-emerald-500/20 text-emerald-400',
    }

    return (
        <div className="flex items-center justify-between py-3 border-b border-white/5 last:border-0">
            <div className="flex-1">
                <p className="text-white font-medium">{orderId}</p>
                <p className="text-gray-500 text-sm">{product} × {qty}</p>
            </div>
            <span className={`px-3 py-1 rounded-full text-xs font-medium ${statusColors[status]}`}>
                {status}
            </span>
        </div>
    )
}
