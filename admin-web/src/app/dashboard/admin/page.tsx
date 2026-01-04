import { redirect } from 'next/navigation'
import { getUserWithRole, isAdmin } from '@/lib/auth/utils'
import {
    TrendingUp,
    ShoppingBag,
    Users,
    Package,
    AlertTriangle,
    CheckCircle,
    Clock,
    Truck,
    ArrowUpRight,
    ArrowDownRight,
    Activity
} from 'lucide-react'
import Link from 'next/link'

export default async function AdminDashboardPage() {
    const user = await getUserWithRole()

    if (!user || !isAdmin(user)) {
        redirect('/login')
    }

    return (
        <div className="space-y-6">
            {/* Welcome Header */}
            <div>
                <h1 className="text-2xl font-bold text-white">Welcome back, {user.name || 'Admin'}</h1>
                <p className="text-gray-400 mt-1">Here's what's happening with Nextgen Organics today.</p>
            </div>

            {/* Executive Overview - Hero Stats Bar */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <StatCard
                    title="Today's Revenue"
                    value="₹45,230"
                    change="+12.5%"
                    trend="up"
                    icon={TrendingUp}
                />
                <StatCard
                    title="Orders Today"
                    value="127"
                    change="+8.2%"
                    trend="up"
                    icon={ShoppingBag}
                />
                <StatCard
                    title="Active Vendors"
                    value="24"
                    change="+2 new"
                    trend="up"
                    icon={Users}
                />
                <StatCard
                    title="Products"
                    value="1,456"
                    change="-3 out of stock"
                    trend="down"
                    icon={Package}
                />
            </div>

            {/* Main Dashboard Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Operations Control Panel - 2 columns */}
                <div className="lg:col-span-2 space-y-6">
                    {/* Order Pipeline */}
                    <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                        <div className="flex items-center justify-between mb-6">
                            <h2 className="text-lg font-semibold text-white">Order Pipeline</h2>
                            <Link href="/dashboard/admin/orders" className="text-sm text-emerald-400 hover:text-emerald-300 flex items-center gap-1 transition-colors">
                                View all <ArrowUpRight className="w-3 h-3" />
                            </Link>
                        </div>

                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <PipelineStage
                                label="New Orders"
                                count={18}
                                color="blue"
                                icon={Clock}
                            />
                            <PipelineStage
                                label="Preparing"
                                count={12}
                                color="yellow"
                                icon={Package}
                            />
                            <PipelineStage
                                label="Out for Delivery"
                                count={24}
                                color="purple"
                                icon={Truck}
                            />
                            <PipelineStage
                                label="Completed"
                                count={73}
                                color="green"
                                icon={CheckCircle}
                            />
                        </div>
                    </div>

                    {/* Alerts & Actions */}
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <AlertCard
                            title="Delayed Orders"
                            value={3}
                            description="Orders pending for more than 30 minutes"
                            severity="warning"
                            href="/dashboard/admin/orders?status=delayed"
                        />
                        <AlertCard
                            title="Vendor Approvals"
                            value={5}
                            description="Vendors awaiting your approval"
                            severity="info"
                            href="/dashboard/admin/vendors?status=pending"
                        />
                    </div>

                    {/* Quick Actions */}
                    <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                        <h2 className="text-lg font-semibold text-white mb-4">Quick Actions</h2>
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                            <QuickAction label="Add Banner" href="/dashboard/admin/cms" icon="🖼️" />
                            <QuickAction label="Manage Offers" href="/dashboard/admin/cms" icon="🏷️" />
                            <QuickAction label="View Analytics" href="/dashboard/admin/analytics" icon="📊" />
                            <QuickAction label="Settings" href="/dashboard/admin/settings" icon="⚙️" />
                        </div>
                    </div>
                </div>

                {/* Live Activity Feed - 1 column */}
                <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                    <div className="flex items-center justify-between mb-4">
                        <div className="flex items-center gap-2">
                            <Activity className="w-4 h-4 text-emerald-400" />
                            <h2 className="text-lg font-semibold text-white">Live Activity</h2>
                        </div>
                        <span className="w-2 h-2 bg-emerald-400 rounded-full animate-pulse" />
                    </div>

                    <div className="space-y-4 max-h-[400px] overflow-y-auto pr-2">
                        <ActivityItem
                            title="New order placed"
                            description="Order #1234 - ₹456"
                            time="2 min ago"
                            type="order"
                        />
                        <ActivityItem
                            title="Vendor approved"
                            description="Green Valley Farms"
                            time="15 min ago"
                            type="vendor"
                        />
                        <ActivityItem
                            title="Product updated"
                            description="Organic Honey - Stock: 50"
                            time="32 min ago"
                            type="product"
                        />
                        <ActivityItem
                            title="Order delivered"
                            description="Order #1198"
                            time="45 min ago"
                            type="success"
                        />
                        <ActivityItem
                            title="Low stock alert"
                            description="Almonds - Only 5 left"
                            time="1 hour ago"
                            type="warning"
                        />
                        <ActivityItem
                            title="New vendor request"
                            description="Himalayan Naturals"
                            time="2 hours ago"
                            type="vendor"
                        />
                    </div>
                </div>
            </div>

            {/* Revenue Analytics Section */}
            <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-6">
                <div className="flex items-center justify-between mb-6">
                    <h2 className="text-lg font-semibold text-white">Revenue Overview</h2>
                    <div className="flex items-center gap-2">
                        <button className="px-3 py-1.5 text-xs font-medium bg-emerald-500/20 text-emerald-400 rounded-lg">Week</button>
                        <button className="px-3 py-1.5 text-xs font-medium text-gray-400 hover:bg-white/5 rounded-lg transition-colors">Month</button>
                        <button className="px-3 py-1.5 text-xs font-medium text-gray-400 hover:bg-white/5 rounded-lg transition-colors">Year</button>
                    </div>
                </div>

                {/* Placeholder Chart Area */}
                <div className="h-64 bg-gradient-to-br from-emerald-500/5 to-transparent rounded-xl border border-white/5 flex items-center justify-center">
                    <div className="text-center">
                        <div className="w-16 h-16 mx-auto mb-4 rounded-2xl bg-emerald-500/10 flex items-center justify-center">
                            <TrendingUp className="w-8 h-8 text-emerald-400" />
                        </div>
                        <p className="text-gray-400 text-sm">Revenue analytics chart</p>
                        <p className="text-gray-600 text-xs mt-1">Integration with chart library pending</p>
                    </div>
                </div>
            </div>
        </div>
    )
}

// Reusable Components

function StatCard({ title, value, change, trend, icon: Icon }: {
    title: string
    value: string
    change: string
    trend: 'up' | 'down'
    icon: any
}) {
    return (
        <div className="bg-gray-900/50 backdrop-blur-sm border border-white/5 rounded-2xl p-5 hover:bg-gray-900/70 transition-all group">
            <div className="flex items-center justify-between mb-3">
                <div className="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center group-hover:bg-emerald-500/20 transition-colors">
                    <Icon className="w-5 h-5 text-emerald-400" />
                </div>
                <div className={`flex items-center gap-1 text-xs font-medium ${trend === 'up' ? 'text-emerald-400' : 'text-red-400'}`}>
                    {trend === 'up' ? <ArrowUpRight className="w-3 h-3" /> : <ArrowDownRight className="w-3 h-3" />}
                    {change}
                </div>
            </div>
            <p className="text-2xl font-bold text-white">{value}</p>
            <p className="text-sm text-gray-500 mt-1">{title}</p>
        </div>
    )
}

function PipelineStage({ label, count, color, icon: Icon }: {
    label: string
    count: number
    color: 'blue' | 'yellow' | 'purple' | 'green'
    icon: any
}) {
    const colorMap = {
        blue: 'bg-blue-500/15 text-blue-400 border-blue-500/20',
        yellow: 'bg-yellow-500/15 text-yellow-400 border-yellow-500/20',
        purple: 'bg-purple-500/15 text-purple-400 border-purple-500/20',
        green: 'bg-emerald-500/15 text-emerald-400 border-emerald-500/20',
    }

    return (
        <div className={`p-4 rounded-xl border ${colorMap[color]} text-center hover:scale-105 transition-transform cursor-pointer`}>
            <Icon className="w-5 h-5 mx-auto mb-2" />
            <p className="text-2xl font-bold">{count}</p>
            <p className="text-xs opacity-80 mt-1">{label}</p>
        </div>
    )
}

function AlertCard({ title, value, description, severity, href }: {
    title: string
    value: number
    description: string
    severity: 'warning' | 'info'
    href: string
}) {
    const colors = {
        warning: 'border-yellow-500/20 bg-yellow-500/5 hover:bg-yellow-500/10',
        info: 'border-blue-500/20 bg-blue-500/5 hover:bg-blue-500/10',
    }
    const iconColors = {
        warning: 'text-yellow-400',
        info: 'text-blue-400',
    }

    return (
        <Link href={href} className={`p-4 rounded-xl border flex items-center gap-4 transition-colors ${colors[severity]}`}>
            <div className={`w-12 h-12 rounded-xl flex items-center justify-center text-2xl font-bold ${iconColors[severity]}`}>
                {value}
            </div>
            <div className="flex-1">
                <p className="font-medium text-white">{title}</p>
                <p className="text-xs text-gray-500 mt-0.5">{description}</p>
            </div>
            <AlertTriangle className={`w-5 h-5 ${iconColors[severity]}`} />
        </Link>
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
            className="p-4 rounded-xl bg-white/5 border border-white/5 hover:bg-white/10 hover:border-white/10 transition-all text-center group"
        >
            <span className="text-2xl mb-2 block group-hover:scale-110 transition-transform">{icon}</span>
            <p className="text-sm text-gray-400 group-hover:text-white transition-colors">{label}</p>
        </Link>
    )
}

function ActivityItem({ title, description, time, type }: {
    title: string
    description: string
    time: string
    type: 'order' | 'vendor' | 'product' | 'success' | 'warning'
}) {
    const colors = {
        order: 'bg-blue-500',
        vendor: 'bg-purple-500',
        product: 'bg-emerald-500',
        success: 'bg-green-500',
        warning: 'bg-yellow-500',
    }

    return (
        <div className="flex items-start gap-3 group">
            <div className={`w-2 h-2 rounded-full mt-2 ${colors[type]}`} />
            <div className="flex-1 min-w-0">
                <p className="text-sm text-white group-hover:text-emerald-300 transition-colors">{title}</p>
                <p className="text-xs text-gray-500 truncate">{description}</p>
            </div>
            <p className="text-xs text-gray-600 flex-shrink-0">{time}</p>
        </div>
    )
}
