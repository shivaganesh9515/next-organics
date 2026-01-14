import Link from 'next/link'
import Image from 'next/image'
import { 
  LayoutDashboard, 
  Store, 
  Package, 
  ShoppingBag, 
  FolderTree, 
  FileText,
  LogOut,
  Leaf,
  Settings
} from 'lucide-react'
import { createClient } from '@/utils/supabase/server'
import { redirect } from 'next/navigation'
import { logout } from '@/app/login/actions'
import { AdminToolbar } from './admin-toolbar'

export default async function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  // Verify admin role
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

  if (!profile || profile.role !== 'admin') {
    redirect('/login?error=' + encodeURIComponent('Access denied. Admin only.'))
  }

  const navItems = [
    { href: '/admin', icon: LayoutDashboard, label: 'Overview' },
    { href: '/admin/vendors', icon: Store, label: 'Vendors' },
    { href: '/admin/products', icon: Package, label: 'Products' },
    { href: '/admin/orders', icon: ShoppingBag, label: 'Orders' },
    { href: '/admin/categories', icon: FolderTree, label: 'Categories' },
    { href: '/admin/settings', icon: Settings, label: 'Settings' },
    { href: '/admin/logs', icon: FileText, label: 'Admin Log' },
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
              <p className="text-xs text-muted-foreground">Admin Panel</p>
            </div>
          </div>
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
              {profile.full_name?.charAt(0) || 'A'}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-sidebar-foreground truncate">
                {profile.full_name || 'Admin'}
              </p>
              <p className="text-xs text-muted-foreground">Administrator</p>
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
        <AdminToolbar />
        <div className="p-8">
          {children}
        </div>
      </main>
    </div>
  )
}

