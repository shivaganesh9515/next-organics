import Link from 'next/link'
import Image from 'next/image'
import { 
  LayoutDashboard, 
  Package, 
  Boxes,
  ShoppingBag, 
  LogOut,
  Leaf
} from 'lucide-react'
import { createClient } from '@/utils/supabase/server'
import { redirect } from 'next/navigation'
import { logout } from '@/app/login/actions'

export default async function VendorLayout({
  children,
}: {
  children: React.ReactNode
}) {
  // Verify vendor role
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) {
    redirect('/login')
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('role, full_name')
    .eq('id', user.id)
    .single()

  if (!profile || profile.role !== 'vendor') {
    redirect('/login?error=' + encodeURIComponent('Access denied. Vendor only.'))
  }

  // Get vendor info
  const { data: vendor } = await supabase
    .from('vendors')
    .select('shop_name, status')
    .eq('user_id', user.id)
    .single()

  const navItems = [
    { href: '/vendor', icon: LayoutDashboard, label: 'Dashboard' },
    { href: '/vendor/products', icon: Package, label: 'My Products' },
    { href: '/vendor/stock', icon: Boxes, label: 'Stock' },
    { href: '/vendor/orders', icon: ShoppingBag, label: 'Orders' },
  ]

  return (
    <div className="flex min-h-screen bg-background">
      {/* Sidebar */}
      <aside className="w-64 bg-sidebar border-r border-sidebar-border flex flex-col">
        {/* Brand */}
        <div className="p-6 border-b border-sidebar-border">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 relative flex items-center justify-center">
              <Image 
                src="/images/logo-icon.png" 
                alt="Nextgen Organics" 
                width={40} 
                height={40} 
                className="object-contain"
              />
            </div>
            <div>
              <h1 className="font-semibold text-sm text-sidebar-foreground">Nextgen Organics</h1>
              <p className="text-xs text-muted-foreground">Vendor Portal</p>
            </div>
          </div>
        </div>

        {/* Shop Info */}
        <div className="px-6 py-4 border-b border-sidebar-border">
          <p className="text-xs text-muted-foreground uppercase tracking-wider mb-1">Your Shop</p>
          <p className="text-sm font-medium text-sidebar-foreground truncate">
            {vendor?.shop_name || 'Not Set'}
          </p>
          <span className={`text-xs ${vendor?.status === 'approved' ? 'text-success' : 'text-warning'}`}>
            {vendor?.status || 'Unknown'}
          </span>
        </div>

        {/* Navigation */}
        <nav className="flex-1 p-4 space-y-1">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="nav-item"
            >
              <item.icon className="w-5 h-5" />
              <span>{item.label}</span>
            </Link>
          ))}
        </nav>

        {/* User & Logout */}
        <div className="p-4 border-t border-sidebar-border">
          <div className="flex items-center gap-3 mb-4 px-3">
            <div className="w-8 h-8 rounded-full bg-muted flex items-center justify-center text-xs font-medium text-muted-foreground">
              {profile.full_name?.charAt(0) || 'V'}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-sidebar-foreground truncate">
                {profile.full_name || 'Vendor'}
              </p>
              <p className="text-xs text-muted-foreground">Vendor</p>
            </div>
          </div>
          <form action={logout}>
            <button type="submit" className="nav-item w-full text-destructive hover:bg-destructive/10">
              <LogOut className="w-5 h-5" />
              <span>Sign Out</span>
            </button>
          </form>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        <div className="p-8">
          {children}
        </div>
      </main>
    </div>
  )
}
