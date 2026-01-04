import { redirect } from 'next/navigation'
import { getUserWithRole, isAdmin } from '@/lib/auth/utils'
import { ADMIN_LOGIN_PATH } from '@/lib/auth/constants'
import { LayoutDashboard, Users, Package, ShoppingBag, TrendingUp, ArrowUpRight } from 'lucide-react'
import Link from 'next/link'

export default async function AdminDashboardPage() {
    const user = await getUserWithRole()

    if (!user || !isAdmin(user)) {
        redirect(ADMIN_LOGIN_PATH)
    }

    return (
        <div className="space-y-8">
            {/* Header */}
            <div>
                <h1 className="text-3xl font-bold text-white">Welcome back, Admin</h1>
                <p className="text-gray-400 mt-1">Here's what's happening with Nextgen Organics today.</p>
            </div>

            {/* Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <StatCard
                    title="Total Vendors"
                    value="24"
                    change="+3 this week"
                    icon={Users}
                    color="purple"
                />
                <StatCard
                    title="Active Products"
                    value="156"
                    change="+12 this week"
                    icon={Package}
                    color="blue"
                />
                <StatCard
                    title="Total Orders"
                    value="1,234"
                    change="+89 this week"
                    icon={ShoppingBag}
                    color="emerald"
                />
                <StatCard
                    title="Revenue"
                    value="₹4.5L"
                    change="+18% vs last month"
                    icon={TrendingUp}
                    color="orange"
                />
            </div>

            {/* Quick Actions */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <QuickActionCard
                    title="Pending Vendors"
                    description="5 vendors awaiting approval"
                    href="/manufacturers"
                    action="Review Now"
                />
                <QuickActionCard
                    title="Banner Studio"
                    description="Manage promotional banners"
                    href="/banners"
                    action="Manage Banners"
                />
                <QuickActionCard
                    title="User Management"
                    description="View and manage all users"
                    href="/users"
                    action="View Users"
                />
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
    color: 'purple' | 'blue' | 'emerald' | 'orange'
}) {
    const colorClasses = {
        purple: 'bg-purple-500/10 text-purple-400 border-purple-500/20',
        blue: 'bg-blue-500/10 text-blue-400 border-blue-500/20',
        emerald: 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20',
        orange: 'bg-orange-500/10 text-orange-400 border-orange-500/20',
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
            className="block bg-gray-900/50 backdrop-blur-sm border border-white/10 rounded-2xl p-6 hover:bg-gray-800/50 hover:border-purple-500/30 transition-all group"
        >
            <h3 className="text-white font-semibold">{title}</h3>
            <p className="text-gray-400 text-sm mt-1">{description}</p>
            <div className="flex items-center gap-1 mt-4 text-purple-400 text-sm font-medium group-hover:text-purple-300 transition-colors">
                {action}
                <ArrowUpRight className="w-4 h-4" />
            </div>
        </Link>
    )
}
