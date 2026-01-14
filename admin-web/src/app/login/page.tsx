import { Leaf, AlertCircle, ArrowRight } from 'lucide-react'
import { unifiedLogin } from './actions'
import Link from 'next/link'
import Image from 'next/image'

interface Props {
  searchParams: Promise<{ error?: string }>
}

export default async function LoginPage({ searchParams }: Props) {
  const { error } = await searchParams

  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-background">
      {/* Subtle Background Pattern */}
      <div 
        className="absolute inset-0 opacity-[0.02]" 
        style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
        }} 
      />

      <div className="relative w-full max-w-md z-10">
        {/* Login Card */}
        <div className="bg-card border border-border rounded-lg p-8 shadow-2xl">

          {/* Brand Header */}
          <div className="text-center mb-8">
            <div className="w-24 h-24 relative mx-auto mb-4">
              <Image 
                src="/images/logo.png" 
                alt="Nextgen Organics" 
                fill
                className="object-contain"
                priority
              />
            </div>
            <h1 className="text-xl font-semibold text-foreground">Nextgen Organics</h1>
            <p className="text-muted-foreground mt-1 text-sm">Admin & Vendor Portal</p>
          </div>

          {/* Error Alert */}
          {error && (
            <div className="mb-6 p-4 bg-destructive/10 border border-destructive/20 rounded-md flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-destructive flex-shrink-0 mt-0.5" />
              <p className="text-destructive text-sm">{error}</p>
            </div>
          )}

          {/* Login Form */}
          <form className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium text-foreground">Email</label>
              <input
                name="email"
                type="email"
                required
                autoComplete="email"
                className="input"
                placeholder="you@example.com"
              />
            </div>

            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <label className="text-sm font-medium text-foreground">Password</label>
                <Link href="/forgot-password" className="text-xs text-muted-foreground hover:text-foreground transition-colors">
                  Forgot password?
                </Link>
              </div>
              <input
                name="password"
                type="password"
                required
                autoComplete="current-password"
                className="input"
                placeholder="••••••••"
              />
            </div>

            <div className="pt-2">
              <button
                formAction={unifiedLogin}
                className="btn btn-primary w-full group"
              >
                <span>Sign In</span>
                <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-0.5 transition-transform" />
              </button>
            </div>
          </form>

          {/* Demo Credentials */}
          <div className="mt-6 p-4 bg-muted/50 border border-border rounded-md">
            <p className="text-xs font-medium text-muted-foreground mb-3">Demo Credentials</p>
            <div className="grid grid-cols-2 gap-3 text-xs">
              <div className="p-2 bg-background rounded">
                <p className="text-muted-foreground mb-1">Admin</p>
                <p className="text-foreground font-mono">admin@demo.com</p>
                <p className="text-muted-foreground font-mono">Admin@123</p>
              </div>
              <div className="p-2 bg-background rounded">
                <p className="text-muted-foreground mb-1">Vendor</p>
                <p className="text-foreground font-mono">vendor@demo.com</p>
                <p className="text-muted-foreground font-mono">Vendor@123</p>
              </div>
            </div>
          </div>

          {/* Join as Vendor */}
          <div className="mt-6 pt-4 border-t border-border text-center">
             <p className="text-sm text-muted-foreground mb-3">
               Want to sell on Nextgen Organics?
             </p>
             <Link 
               href="/register" 
               className="inline-flex items-center text-primary font-medium hover:underline"
             >
               Join as Vendor <ArrowRight className="w-4 h-4 ml-1" />
             </Link>
          </div>

          <div className="mt-4 pt-4 border-t border-border text-center">
            <p className="text-muted-foreground text-xs">
              Secure authentication powered by Supabase
            </p>
          </div>
        </div>

        {/* Brand Badge */}
        <div className="mt-4 text-center">
          <p className="text-xs text-muted-foreground flex items-center justify-center gap-1">
            <Leaf className="w-3 h-3" />
            <span>Organic • Fresh • Sustainable</span>
          </p>
        </div>
      </div>
    </div>
  )
}
