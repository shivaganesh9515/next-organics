import Link from 'next/link'
import { ArrowRight, ShoppingBag, ShieldCheck } from 'lucide-react'

export default function LandingPage() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-background p-4 relative overflow-hidden">
      {/* Abstract Background Shapes */}
      <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500/10 rounded-full blur-3xl" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl" />

      <div className="z-10 text-center max-w-2xl mx-auto space-y-8">
        <div className="flex justify-center mb-4">
          <div className="p-4 bg-blue-100 dark:bg-blue-900/20 rounded-2xl">
            <ShoppingBag className="w-12 h-12 text-blue-600 dark:text-blue-400" />
          </div>
        </div>

        <div className="space-y-4">
          <h1 className="text-4xl md:text-5xl font-bold tracking-tight text-foreground">
            Nextgen Organics
            <span className="block text-primary mt-1">Admin & Vendor Portal</span>
          </h1>
          <p className="text-xl text-muted-foreground">
            The central hub for managing organic produce, vendors, and orders.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
          <Link 
            href="/login" 
            className="w-full sm:w-auto px-8 py-3 bg-primary text-primary-foreground font-medium rounded-xl hover:bg-primary/90 transition-colors flex items-center justify-center gap-2"
          >
            Sign In
            <ArrowRight className="w-4 h-4" />
          </Link>
          
          <Link 
            href="/register" 
            className="w-full sm:w-auto px-8 py-3 bg-secondary text-secondary-foreground font-medium rounded-xl hover:bg-secondary/80 transition-colors border border-border flex items-center justify-center gap-2"
          >
            Join as Vendor
            <ShieldCheck className="w-4 h-4" />
          </Link>
        </div>

        <div className="pt-12 grid grid-cols-1 sm:grid-cols-3 gap-8 text-center">
          <div className="space-y-2">
            <div className="font-semibold text-foreground">For Admins</div>
            <p className="text-sm text-muted-foreground">Monitor sales, approve vendors, and manage catalog</p>
          </div>
          <div className="px-px bg-border/50 h-full hidden sm:block" />
          <div className="space-y-2">
            <div className="font-semibold text-foreground">For Vendors</div>
            <p className="text-sm text-muted-foreground">List products, track orders, and grow your business</p>
          </div>
          <div className="px-px bg-border/50 h-full hidden sm:block" />
          <div className="space-y-2">
            <div className="font-semibold text-foreground">Secure Platform</div>
            <p className="text-sm text-muted-foreground">Role-based access with Supabase authentication</p>
          </div>
        </div>
      </div>
      
      <div className="absolute bottom-6 text-center text-xs text-muted-foreground">
        © {new Date().getFullYear()} Nextgen Organics. All rights reserved.
      </div>
    </div>
  )
}
