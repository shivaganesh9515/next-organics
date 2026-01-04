'use client'

import { Bell, Search, Settings, LogOut, User, ChevronDown, Menu } from 'lucide-react'
import { useState } from 'react'
import { logout } from '@/app/login/actions'

interface TopbarProps {
    role: 'ADMIN' | 'VENDOR'
    userName?: string
    userEmail?: string
}

export function Topbar({ role, userName, userEmail }: TopbarProps) {
    const [profileOpen, setProfileOpen] = useState(false)
    const [notificationsOpen, setNotificationsOpen] = useState(false)

    const notifications = [
        { id: 1, title: 'New order received', time: '2 min ago', unread: true },
        { id: 2, title: 'Vendor approved', time: '1 hour ago', unread: true },
        { id: 3, title: 'Low stock alert', time: '3 hours ago', unread: false },
    ]

    return (
        <header className="h-16 bg-gray-900/30 backdrop-blur-xl border-b border-white/5 flex items-center justify-between px-6 sticky top-0 z-20">
            {/* Left Side - Search */}
            <div className="flex items-center gap-4">
                <button className="md:hidden p-2 hover:bg-white/5 rounded-lg transition-colors">
                    <Menu className="w-5 h-5 text-gray-400" />
                </button>

                <div className="hidden md:flex items-center gap-2 bg-white/5 border border-white/10 rounded-xl px-4 py-2 min-w-[300px] focus-within:border-white/20 focus-within:bg-white/10 transition-all">
                    <Search className="w-4 h-4 text-gray-500" />
                    <input
                        type="text"
                        placeholder="Search orders, products, vendors..."
                        className="bg-transparent text-sm text-white placeholder:text-gray-500 outline-none flex-1"
                    />
                    <kbd className="hidden lg:flex items-center gap-1 text-xs text-gray-600 bg-gray-800 px-1.5 py-0.5 rounded">
                        ⌘K
                    </kbd>
                </div>
            </div>

            {/* Right Side - Actions */}
            <div className="flex items-center gap-2">
                {/* Notifications */}
                <div className="relative">
                    <button
                        onClick={() => { setNotificationsOpen(!notificationsOpen); setProfileOpen(false) }}
                        className="p-2.5 hover:bg-white/5 rounded-xl transition-colors relative"
                    >
                        <Bell className="w-5 h-5 text-gray-400" />
                        <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full" />
                    </button>

                    {notificationsOpen && (
                        <div className="absolute right-0 top-12 w-80 bg-gray-900 border border-white/10 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
                            <div className="p-4 border-b border-white/5">
                                <h3 className="font-semibold text-white">Notifications</h3>
                            </div>
                            <div className="max-h-80 overflow-y-auto">
                                {notifications.map((notif) => (
                                    <div
                                        key={notif.id}
                                        className={`p-4 border-b border-white/5 hover:bg-white/5 transition-colors cursor-pointer ${notif.unread ? 'bg-white/[0.02]' : ''}`}
                                    >
                                        <div className="flex items-start gap-3">
                                            {notif.unread && <span className="w-2 h-2 bg-emerald-500 rounded-full mt-1.5 flex-shrink-0" />}
                                            <div className={notif.unread ? '' : 'ml-5'}>
                                                <p className="text-sm text-white">{notif.title}</p>
                                                <p className="text-xs text-gray-500 mt-0.5">{notif.time}</p>
                                            </div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                            <div className="p-3 border-t border-white/5">
                                <button className="w-full text-center text-sm text-emerald-400 hover:text-emerald-300 transition-colors">
                                    View all notifications
                                </button>
                            </div>
                        </div>
                    )}
                </div>

                {/* Settings */}
                <button className="p-2.5 hover:bg-white/5 rounded-xl transition-colors hidden md:block">
                    <Settings className="w-5 h-5 text-gray-400" />
                </button>

                {/* Profile Dropdown */}
                <div className="relative ml-2">
                    <button
                        onClick={() => { setProfileOpen(!profileOpen); setNotificationsOpen(false) }}
                        className="flex items-center gap-3 p-1.5 pr-3 hover:bg-white/5 rounded-xl transition-colors"
                    >
                        <div className={`
              w-8 h-8 rounded-lg flex items-center justify-center text-sm font-bold text-white
              ${role === 'ADMIN' ? 'bg-gradient-to-br from-emerald-500 to-lime-500' : 'bg-gradient-to-br from-orange-500 to-amber-500'}
            `}>
                            {userName?.charAt(0)?.toUpperCase() || (role === 'ADMIN' ? 'A' : 'V')}
                        </div>
                        <div className="hidden md:block text-left">
                            <p className="text-sm font-medium text-white">{userName || (role === 'ADMIN' ? 'Admin' : 'Vendor')}</p>
                            <p className="text-xs text-gray-500">{role}</p>
                        </div>
                        <ChevronDown className="w-4 h-4 text-gray-400 hidden md:block" />
                    </button>

                    {profileOpen && (
                        <div className="absolute right-0 top-12 w-56 bg-gray-900 border border-white/10 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
                            <div className="p-4 border-b border-white/5">
                                <p className="text-sm font-medium text-white">{userName || 'User'}</p>
                                <p className="text-xs text-gray-500 truncate">{userEmail || 'user@example.com'}</p>
                            </div>
                            <div className="p-2">
                                <button className="w-full flex items-center gap-3 px-3 py-2 text-sm text-gray-400 hover:text-white hover:bg-white/5 rounded-lg transition-colors">
                                    <User className="w-4 h-4" />
                                    Profile Settings
                                </button>
                                <form action={logout}>
                                    <button
                                        type="submit"
                                        className="w-full flex items-center gap-3 px-3 py-2 text-sm text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-lg transition-colors"
                                    >
                                        <LogOut className="w-4 h-4" />
                                        Sign Out
                                    </button>
                                </form>
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </header>
    )
}
