'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import {
    LayoutDashboard,
    ShoppingBag,
    Store,
    Package,
    BarChart3,
    Image as ImageIcon,
    Settings,
    ChevronLeft,
    ChevronRight,
    Wallet,
    HelpCircle,
    Star
} from 'lucide-react'
import { useState } from 'react'

interface SidebarProps {
    role: 'ADMIN' | 'VENDOR'
    userName?: string
}

const adminMenuItems = [
    { label: 'Dashboard', icon: LayoutDashboard, href: '/dashboard/admin' },
    { label: 'Orders', icon: ShoppingBag, href: '/dashboard/admin/orders' },
    { label: 'Vendors', icon: Store, href: '/dashboard/admin/vendors' },
    { label: 'Products', icon: Package, href: '/dashboard/admin/products' },
    { label: 'Analytics', icon: BarChart3, href: '/dashboard/admin/analytics' },
    { label: 'CMS', icon: ImageIcon, href: '/dashboard/admin/cms' },
    { label: 'Settings', icon: Settings, href: '/dashboard/admin/settings' },
]

const vendorMenuItems = [
    { label: 'Dashboard', icon: LayoutDashboard, href: '/dashboard/vendor' },
    { label: 'Orders', icon: ShoppingBag, href: '/dashboard/vendor/orders' },
    { label: 'Products', icon: Package, href: '/dashboard/vendor/products' },
    { label: 'Inventory', icon: Store, href: '/dashboard/vendor/inventory' },
    { label: 'Earnings', icon: Wallet, href: '/dashboard/vendor/earnings' },
    { label: 'Reviews', icon: Star, href: '/dashboard/vendor/reviews' },
    { label: 'Support', icon: HelpCircle, href: '/dashboard/vendor/support' },
]

export function Sidebar({ role, userName }: SidebarProps) {
    const [collapsed, setCollapsed] = useState(false)
    const pathname = usePathname()

    const menuItems = role === 'ADMIN' ? adminMenuItems : vendorMenuItems
    const accentColor = role === 'ADMIN' ? 'emerald' : 'orange'

    return (
        <aside className={`
      ${collapsed ? 'w-20' : 'w-64'} 
      bg-gray-900/50 backdrop-blur-xl border-r border-white/5 
      flex flex-col transition-all duration-300 ease-in-out
      relative z-30
    `}>
            {/* Header */}
            <div className={`p-4 border-b border-white/5 ${collapsed ? 'px-3' : 'px-5'}`}>
                <div className="flex items-center gap-3">
                    <div className={`
            ${collapsed ? 'w-10 h-10' : 'w-11 h-11'} 
            rounded-xl bg-gradient-to-br 
            ${role === 'ADMIN' ? 'from-emerald-500 to-lime-500' : 'from-orange-500 to-amber-500'} 
            flex items-center justify-center text-white font-bold shadow-lg transition-all
          `}>
                        {role === 'ADMIN' ? '🌿' : '🏪'}
                    </div>
                    {!collapsed && (
                        <div className="animate-in fade-in slide-in-from-left-2 duration-200">
                            <h2 className="text-sm font-bold text-white">
                                {role === 'ADMIN' ? 'Admin Panel' : 'Vendor Portal'}
                            </h2>
                            <p className="text-xs text-gray-500 truncate max-w-[140px]">
                                {userName || (role === 'ADMIN' ? 'Platform Manager' : 'Business Dashboard')}
                            </p>
                        </div>
                    )}
                </div>
            </div>

            {/* Navigation */}
            <nav className="flex-1 py-4 overflow-y-auto">
                <div className={`space-y-1 ${collapsed ? 'px-2' : 'px-3'}`}>
                    {menuItems.map((item) => {
                        const isActive = pathname === item.href ||
                            (item.href !== '/dashboard/admin' && item.href !== '/dashboard/vendor' && pathname.startsWith(item.href))

                        return (
                            <Link
                                key={item.href}
                                href={item.href}
                                className={`
                  flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium
                  transition-all duration-200 group
                  ${isActive
                                        ? `bg-${accentColor}-500/15 text-${accentColor}-400 border border-${accentColor}-500/20`
                                        : 'text-gray-400 hover:text-white hover:bg-white/5'
                                    }
                  ${collapsed ? 'justify-center' : ''}
                `}
                                style={isActive ? {
                                    backgroundColor: role === 'ADMIN' ? 'rgba(16, 185, 129, 0.15)' : 'rgba(249, 115, 22, 0.15)',
                                    color: role === 'ADMIN' ? '#34d399' : '#fb923c',
                                    borderColor: role === 'ADMIN' ? 'rgba(16, 185, 129, 0.2)' : 'rgba(249, 115, 22, 0.2)',
                                } : {}}
                            >
                                <item.icon className={`w-5 h-5 flex-shrink-0 transition-colors ${isActive ? '' : 'group-hover:text-white'}`} />
                                {!collapsed && (
                                    <span className="animate-in fade-in slide-in-from-left-1 duration-150">{item.label}</span>
                                )}
                            </Link>
                        )
                    })}
                </div>
            </nav>

            {/* Collapse Toggle */}
            <button
                onClick={() => setCollapsed(!collapsed)}
                className="absolute -right-3 top-20 w-6 h-6 bg-gray-800 border border-white/10 rounded-full flex items-center justify-center text-gray-400 hover:text-white hover:bg-gray-700 transition-all z-50"
            >
                {collapsed ? <ChevronRight className="w-3 h-3" /> : <ChevronLeft className="w-3 h-3" />}
            </button>

            {/* Footer */}
            <div className={`p-4 border-t border-white/5 ${collapsed ? 'px-2' : ''}`}>
                <div className={`
          flex items-center gap-2 px-3 py-2 rounded-lg bg-white/5 
          ${collapsed ? 'justify-center' : ''}
        `}>
                    <div className={`w-2 h-2 rounded-full ${role === 'ADMIN' ? 'bg-emerald-400' : 'bg-orange-400'} animate-pulse`} />
                    {!collapsed && <span className="text-xs text-gray-400">System Online</span>}
                </div>
            </div>
        </aside>
    )
}
