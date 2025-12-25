import Link from 'next/link'
import { LayoutDashboard, Package, ShoppingBag, LogOut } from 'lucide-react'

export default function VendorLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex min-h-screen">
      {/* Sidebar */}
      <aside className="w-64 bg-black/20 backdrop-blur-xl border-r border-white/10 hidden md:flex flex-col p-6">
        
        {/* Vendor Profile */}
        <div className="flex items-center gap-3 mb-10">
          <div className="w-10 h-10 rounded-full bg-orange-500/20 flex items-center justify-center text-orange-400 font-bold border border-orange-500/20">
             GV
          </div>
          <div>
            <h3 className="font-bold text-sm">Green Valley</h3>
            <p className="text-xs text-muted-foreground">Vendor Portal</p>
          </div>
        </div>

        {/* Navigation */}
        <nav className="space-y-2 flex-1">
          <NavItem href="/inventory" icon={Package} label="Inventory" />
          <NavItem href="/orders" icon={ShoppingBag} label="Orders" />
          <NavItem href="/dashboard" icon={LayoutDashboard} label="Insights" />
        </nav>

        {/* Footer */}
        <button className="flex items-center gap-3 text-sm text-gray-400 hover:text-white transition-colors p-3 rounded-lg hover:bg-white/5">
          <LogOut className="w-4 h-4" />
          Sign Out
        </button>
      </aside>

      {/* Main Content */}
      <main className="flex-1 p-8 overflow-auto">
        {children}
      </main>
    </div>
  )
}

function NavItem({ href, icon: Icon, label }: { href: string; icon: any; label: string }) {
  return (
    <Link href={href} className="flex items-center gap-3 p-3 rounded-lg text-gray-400 hover:text-white hover:bg-white/5 transition-all">
      <Icon className="w-5 h-5" />
      <span className="text-sm font-medium">{label}</span>
    </Link>
  )
}
