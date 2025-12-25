import Link from 'next/link'
import { LayoutDashboard, ShoppingBag, Image as ImageIcon, Users } from 'lucide-react'

export default function Home() {
  return (
    <div className="max-w-6xl mx-auto space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
          <p className="text-muted-foreground mt-1">Manage your Organic Ecosystem.</p>
        </div>
        <div className="flex gap-2">
          <div className="h-10 w-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
            GN
          </div>
        </div>
      </div>

      {/* Grid Menu */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        
        {/* Banner Manager Card */}
        <Link href="/banners" className="glass-panel p-6 hover:scale-[1.02] transition-transform cursor-pointer group">
          <div className="h-12 w-12 rounded-lg bg-blue-500/10 flex items-center justify-center mb-4 group-hover:bg-blue-500/20 transition-colors">
            <ImageIcon className="h-6 w-6 text-blue-400" />
          </div>
          <h3 className="text-lg font-semibold">Banner Studio</h3>
          <p className="text-sm text-gray-400 mt-2">Update Home Screen promos & offers dynamically.</p>
        </Link>

        {/* Products Card */}
        <div className="glass-panel p-6 opacity-60">
          <div className="h-12 w-12 rounded-lg bg-green-500/10 flex items-center justify-center mb-4">
            <ShoppingBag className="h-6 w-6 text-green-400" />
          </div>
          <h3 className="text-lg font-semibold">Products</h3>
          <p className="text-sm text-gray-400 mt-2">Manage inventory & prices (Coming Soon).</p>
        </div>

        {/* Manufacturers Card */}
        <div className="glass-panel p-6 opacity-60">
          <div className="h-12 w-12 rounded-lg bg-orange-500/10 flex items-center justify-center mb-4">
            <LayoutDashboard className="h-6 w-6 text-orange-400" />
          </div>
          <h3 className="text-lg font-semibold">Manufacturers</h3>
          <p className="text-sm text-gray-400 mt-2">Onboard farms & hubs (Coming Soon).</p>
        </div>

        {/* Users Card */}
        <div className="glass-panel p-6 opacity-60">
          <div className="h-12 w-12 rounded-lg bg-purple-500/10 flex items-center justify-center mb-4">
            <Users className="h-6 w-6 text-purple-400" />
          </div>
          <h3 className="text-lg font-semibold">Customers</h3>
          <p className="text-sm text-gray-400 mt-2">View analytics & orders (Coming Soon).</p>
        </div>

      </div>
    </div>
  )
}
