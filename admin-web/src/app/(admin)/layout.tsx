import Link from 'next/link'
import { LayoutDashboard, Image as ImageIcon, Store, Settings, Users } from 'lucide-react'
import { LogoutButton } from '@/components/auth/logout-button'
import { adminLogout } from '@/app/admin/login/actions'

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex min-h-screen">
      {/* Super Admin Sidebar */}
      <aside className="w-64 bg-black/40 backdrop-blur-xl border-r border-white/10 hidden md:flex flex-col p-6 shadow-2xl z-20">

        {/* Admin Profile */}
        <div className="flex items-center gap-3 mb-10">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500 to-indigo-600 flex items-center justify-center text-white font-bold shadow-lg shadow-purple-900/30">
            SA
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Super Admin</h3>
            <p className="text-xs text-purple-300/70">Platform Manager</p>
          </div>
        </div>

        {/* Navigation */}
        <nav className="space-y-1.5 flex-1">
          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 px-3">Dashboard</p>
          <NavItem href="/admin/dashboard" icon={LayoutDashboard} label="Overview" />

          <div className="h-4"></div>

          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 px-3">Content</p>
          <NavItem href="/banners" icon={ImageIcon} label="Banner Studio" />

          <div className="h-4"></div>

          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 px-3">Network</p>
          <NavItem href="/manufacturers" icon={Store} label="Vendors" />
          <NavItem href="/users" icon={Users} label="User Base" />

          <div className="h-4"></div>

          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 px-3">System</p>
          <NavItem href="/settings" icon={Settings} label="Global Config" />
        </nav>

        {/* Footer */}
        <div className="pt-4 border-t border-white/5">
          <LogoutButton action={adminLogout} variant="admin" />
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 overflow-auto relative">
        {/* Background Decoration */}
        <div className="absolute inset-0 z-0 bg-gradient-to-br from-purple-900/5 via-black to-emerald-900/5 pointer-events-none" />

        <div className="relative z-10 p-8">
          {children}
        </div>
      </main>
    </div>
  )
}

function NavItem({ href, icon: Icon, label }: { href: string; icon: any; label: string }) {
  return (
    <Link href={href} className="flex items-center gap-3 p-3 rounded-lg text-gray-400 hover:text-white hover:bg-white/5 transition-all group">
      <Icon className="w-5 h-5 group-hover:text-purple-400 transition-colors" />
      <span className="text-sm font-medium">{label}</span>
    </Link>
  )
}
