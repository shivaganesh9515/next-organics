import Link from 'next/link'
import { LayoutDashboard, Package, ShoppingBag } from 'lucide-react'
import { LogoutButton } from '@/components/auth/logout-button'
import { vendorLogout } from '@/app/vendor/login/actions'

export default function VendorLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex min-h-screen">
      {/* Vendor Sidebar */}
      <aside className="w-64 bg-black/30 backdrop-blur-xl border-r border-white/10 hidden md:flex flex-col p-6">

        {/* Vendor Profile */}
        <div className="flex items-center gap-3 mb-10">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center text-white font-bold shadow-lg shadow-orange-900/20">
            V
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Vendor Portal</h3>
            <p className="text-xs text-orange-300/70">Nextgen Organics</p>
          </div>
        </div>

        {/* Navigation */}
        <nav className="space-y-1.5 flex-1">
          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 px-3">Main</p>
          <NavItem href="/vendor/dashboard" icon={LayoutDashboard} label="Dashboard" />
          <NavItem href="/inventory" icon={Package} label="Inventory" />
          <NavItem href="/orders" icon={ShoppingBag} label="Orders" />
        </nav>

        {/* Footer */}
        <div className="pt-4 border-t border-white/5">
          <LogoutButton action={vendorLogout} variant="vendor" />
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto relative">
        {/* Background */}
        <div className="absolute inset-0 z-0 bg-gradient-to-br from-orange-900/5 via-black to-amber-900/5 pointer-events-none" />

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
      <Icon className="w-5 h-5 group-hover:text-orange-400 transition-colors" />
      <span className="text-sm font-medium">{label}</span>
    </Link>
  )
}
