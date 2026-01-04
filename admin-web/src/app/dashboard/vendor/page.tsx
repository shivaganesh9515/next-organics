import { redirect } from 'next/navigation'
import { getUserWithRole, isVendor, isVendorApproved } from '@/lib/auth/utils'
import {
    TrendingUp,
    ShoppingBag,
    Package,
    Wallet,
    Plus,
    ArrowUpRight,
    Clock,
    CheckCircle,
    AlertTriangle,
    Star
} from 'lucide-react'
import Link from 'next/link'

export default async function VendorDashboardPage() {
    const user = await getUserWithRole()

    if (!user || !isVendor(user)) {
        redirect('/login')
    }

    if (!isVendorApproved(user)) {
        redirect('/dashboard/vendor/pending')
    }

    return (
        <div className="space-y-6">
            {/* Welcome Header with Performance Insight */}
            <div className="bg-gradient-to-r from-orange-600/20 to-amber-600/10 border border-orange-500/20 rounded-2xl p-6">
                <div className="flex items-center justify-between">
                    <div>
                        <h1 className="text-2xl font-bold text-white">Good afternoon, {user.name || 'Partner'} 👋</h1>
                        <p className="text-orange-200/70 mt-1">Your sales are up 18% from last week. Keep it going!</p>
                    </div>
                    <Link
                        href="/dashboard/vendor/products/new"
                        className="hidden md:flex items-center gap-2 bg-orange-500 hover:bg-orange-400 text-white font-semibold px-5 py-2.5 rounded-xl transition-all shadow-lg shadow-orange-900/30"
                    >
                        <Plus className="w-4 h-4" />
                        Add Product
                    </Link>
                </div>

                {/* Mini Performance Stats */}
                <div className="grid grid-cols-3 gap-4 mt-6">
                    <div className="text-center">
                        <p className="text-2xl font-bold text-white">₹12,450</p>
                        <p className="text-xs text-orange-200/60 mt-1">Today's Sales</p>
                    </div>
                    <div className="text-center border-x border-orange-500/20">
                        <p className="text-2xl font-bold text-white">23</p>
                        <p className="text-xs text-orange-200/60 mt-1">Orders Today</p>
                    </div>
                    <div className="text-center">
                        <p className="text-2xl font-bold text-white">4.8</p>
                        <p className="text-xs text-orange-200/60 mt-1 flex items-center justify-center gap-1">
                            <Star className="w-3 h-3 text-yellow-400 fill-yellow-400" /> Rating
                        </p>
                    </div>
                </div>
            </div>

            {/* Main Dashboard Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Orders Flow - 2 columns */}
                <div className="lg:col-span-2 space-y-6">
                    {/* Visual Order Flow */}
                    <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                        <div className="flex items-center justify-between mb-6">
                            <h2 className="text-lg font-semibold text-white">Orders Management</h2>
                            <Link href="/dashboard/vendor/orders" className="text-sm text-orange-400 hover:text-orange-300 flex items-center gap-1 transition-colors">
                                View all <ArrowUpRight className="w-3 h-3" />
                            </Link>
                        </div>

                        <div className="grid grid-cols-3 gap-4">
                            <OrderStage
                                label="New Orders"
                                count={8}
                                color="blue"
                                icon={ShoppingBag}
                                action="Accept"
                            />
                            <OrderStage
                                label="Preparing"
                                count={5}
                                color="yellow"
                                icon={Clock}
                                action="Mark Ready"
                            />
                            <OrderStage
                                label="Ready for Pickup"
                                count={3}
                                color="green"
                                icon={CheckCircle}
                                action="Complete"
                            />
                        </div>
                    </div>

                    {/* Inventory Intelligence */}
                    <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                        <div className="flex items-center justify-between mb-4">
                            <h2 className="text-lg font-semibold text-white">Inventory Alerts</h2>
                            <Link href="/dashboard/vendor/inventory" className="text-sm text-orange-400 hover:text-orange-300 flex items-center gap-1 transition-colors">
                                Manage <ArrowUpRight className="w-3 h-3" />
                            </Link>
                        </div>

                        <div className="space-y-3">
                            <InventoryAlert
                                product="Organic Almonds"
                                stock={5}
                                status="low"
                            />
                            <InventoryAlert
                                product="Pure Honey 500g"
                                stock={12}
                                status="warning"
                            />
                            <InventoryAlert
                                product="Turmeric Powder"
                                stock={0}
                                status="out"
                            />
                        </div>
                    </div>

                    {/* Quick Actions */}
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                        <QuickAction label="Add Product" href="/dashboard/vendor/products/new" icon="📦" />
                        <QuickAction label="Update Stock" href="/dashboard/vendor/inventory" icon="📊" />
                        <QuickAction label="View Earnings" href="/dashboard/vendor/earnings" icon="💰" />
                        <QuickAction label="Get Support" href="/dashboard/vendor/support" icon="💬" />
                    </div>
                </div>

                {/* Earnings & Payouts - 1 column */}
                <div className="space-y-6">
                    {/* Earnings Overview */}
                    <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                        <div className="flex items-center justify-between mb-4">
                            <h2 className="text-lg font-semibold text-white">Earnings</h2>
                            <div className="flex text-xs">
                                <button className="px-2 py-1 bg-orange-500/20 text-orange-400 rounded-l-lg">Week</button>
                                <button className="px-2 py-1 text-gray-500 hover:bg-white/5 rounded-r-lg">Month</button>
                            </div>
                        </div>

                        <div className="text-center py-4">
                            <p className="text-3xl font-bold text-white">₹45,230</p>
                            <p className="text-sm text-gray-500 mt-1">This Week's Earnings</p>
                            <div className="flex items-center justify-center gap-1 mt-2 text-emerald-400 text-sm">
                                <TrendingUp className="w-4 h-4" />
                                <span>+18% from last week</span>
                            </div>
                        </div>

                        <div className="border-t border-white/5 pt-4 mt-4 space-y-3">
                            <div className="flex items-center justify-between">
                                <span className="text-gray-400 text-sm">Pending Payout</span>
                                <span className="text-white font-medium">₹12,340</span>
                            </div>
                            <div className="flex items-center justify-between">
                                <span className="text-gray-400 text-sm">Last Payout</span>
                                <span className="text-gray-500 text-sm">₹32,890 (Dec 25)</span>
                            </div>
                        </div>

                        <Link
                            href="/dashboard/vendor/earnings"
                            className="mt-4 w-full block text-center py-2.5 bg-orange-500/10 text-orange-400 rounded-xl hover:bg-orange-500/20 transition-colors text-sm font-medium"
                        >
                            View All Transactions
                        </Link>
                    </div>

                    {/* Top Products */}
                    <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                        <h2 className="text-lg font-semibold text-white mb-4">Top Selling</h2>

                        <div className="space-y-3">
                            <TopProduct rank={1} name="Organic Honey" sales={45} />
                            <TopProduct rank={2} name="Almonds 500g" sales={38} />
                            <TopProduct rank={3} name="Turmeric Powder" sales={32} />
                        </div>
                    </div>

                    {/* Tips Card */}
                    <div className="bg-gradient-to-br from-emerald-500/10 to-lime-500/5 border border-emerald-500/20 rounded-2xl p-5">
                        <div className="flex items-start gap-3">
                            <span className="text-2xl">💡</span>
                            <div>
                                <p className="text-sm font-medium text-white">Pro Tip</p>
                                <p className="text-xs text-gray-400 mt-1">
                                    Products with photos get 40% more orders. Update your product images today!
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

// Reusable Components

function OrderStage({ label, count, color, icon: Icon, action }: {
    label: string
    count: number
    color: 'blue' | 'yellow' | 'green'
    icon: any
    action: string
}) {
    const colors = {
        blue: 'bg-blue-500/15 border-blue-500/20 text-blue-400',
        yellow: 'bg-yellow-500/15 border-yellow-500/20 text-yellow-400',
        green: 'bg-emerald-500/15 border-emerald-500/20 text-emerald-400',
    }
    const buttonColors = {
        blue: 'bg-blue-500/20 text-blue-400 hover:bg-blue-500/30',
        yellow: 'bg-yellow-500/20 text-yellow-400 hover:bg-yellow-500/30',
        green: 'bg-emerald-500/20 text-emerald-400 hover:bg-emerald-500/30',
    }

    return (
        <div className={`p-4 rounded-xl border ${colors[color]} text-center`}>
            <Icon className="w-6 h-6 mx-auto mb-2" />
            <p className="text-2xl font-bold">{count}</p>
            <p className="text-xs opacity-80 mb-3">{label}</p>
            <button className={`w-full py-1.5 rounded-lg text-xs font-medium transition-colors ${buttonColors[color]}`}>
                {action}
            </button>
        </div>
    )
}

function InventoryAlert({ product, stock, status }: {
    product: string
    stock: number
    status: 'low' | 'warning' | 'out'
}) {
    const statusConfig = {
        low: { color: 'text-yellow-400', bg: 'bg-yellow-500/10', label: 'Low Stock' },
        warning: { color: 'text-orange-400', bg: 'bg-orange-500/10', label: 'Restock Soon' },
        out: { color: 'text-red-400', bg: 'bg-red-500/10', label: 'Out of Stock' },
    }

    return (
        <div className={`flex items-center justify-between p-3 ${statusConfig[status].bg} rounded-xl`}>
            <div className="flex items-center gap-3">
                <AlertTriangle className={`w-4 h-4 ${statusConfig[status].color}`} />
                <div>
                    <p className="text-sm text-white">{product}</p>
                    <p className="text-xs text-gray-500">{stock} units left</p>
                </div>
            </div>
            <span className={`text-xs font-medium ${statusConfig[status].color}`}>
                {statusConfig[status].label}
            </span>
        </div>
    )
}

function QuickAction({ label, href, icon }: {
    label: string
    href: string
    icon: string
}) {
    return (
        <Link
            href={href}
            className="p-4 rounded-xl bg-gray-900/50 border border-white/5 hover:bg-gray-800/50 hover:border-orange-500/20 transition-all text-center group"
        >
            <span className="text-2xl mb-2 block group-hover:scale-110 transition-transform">{icon}</span>
            <p className="text-xs text-gray-400 group-hover:text-white transition-colors">{label}</p>
        </Link>
    )
}

function TopProduct({ rank, name, sales }: {
    rank: number
    name: string
    sales: number
}) {
    const rankColors = {
        1: 'text-yellow-400',
        2: 'text-gray-400',
        3: 'text-orange-600',
    }

    return (
        <div className="flex items-center gap-3">
            <span className={`text-lg font-bold ${rankColors[rank as keyof typeof rankColors] || 'text-gray-500'}`}>
                #{rank}
            </span>
            <div className="flex-1">
                <p className="text-sm text-white">{name}</p>
                <p className="text-xs text-gray-500">{sales} sold this week</p>
            </div>
        </div>
    )
}
