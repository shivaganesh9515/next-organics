import { Leaf, AlertCircle } from 'lucide-react'
import { unifiedLogin } from './actions'
import Link from 'next/link'

interface Props {
  searchParams: Promise<{ error?: string }>
}

export default async function LoginPage({ searchParams }: Props) {
  const { error } = await searchParams

  return (
    <div className="min-h-screen flex items-center justify-center p-4 relative overflow-hidden">
      {/* Organic Gradient Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-emerald-950 via-gray-950 to-gray-900" />

      {/* Decorative Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {/* Large organic blob top-left */}
        <div className="absolute -top-40 -left-40 w-[500px] h-[500px] bg-gradient-to-br from-emerald-600/20 to-lime-500/10 rounded-full blur-3xl" />
        {/* Medium blob bottom-right */}
        <div className="absolute -bottom-32 -right-32 w-[400px] h-[400px] bg-gradient-to-tl from-emerald-700/15 to-teal-500/10 rounded-full blur-3xl" />
        {/* Small accent blob */}
        <div className="absolute top-1/4 right-1/4 w-32 h-32 bg-lime-400/10 rounded-full blur-2xl animate-pulse" />
        {/* Subtle grid pattern */}
        <div className="absolute inset-0 opacity-[0.02]" style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
        }} />
      </div>

      <div className="relative w-full max-w-md z-10">
        {/* Login Card */}
        <div className="bg-gray-900/80 backdrop-blur-2xl border border-white/10 rounded-3xl p-8 shadow-2xl shadow-black/50">

          {/* Brand Header */}
          <div className="text-center mb-8">
            <div className="w-20 h-20 rounded-2xl bg-gradient-to-br from-emerald-500 to-lime-500 flex items-center justify-center mx-auto mb-5 shadow-xl shadow-emerald-900/40 rotate-3 hover:rotate-0 transition-transform duration-300">
              <Leaf className="w-10 h-10 text-white" />
            </div>
            <h1 className="text-2xl font-bold text-white tracking-tight">Nextgen Organics</h1>
            <p className="text-gray-400 mt-2 text-sm">Admin & Vendor Portal</p>
          </div>

          {/* Error Alert */}
          {error && (
            <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 rounded-xl flex items-start gap-3 animate-in slide-in-from-top-2 duration-300">
              <AlertCircle className="w-5 h-5 text-red-400 flex-shrink-0 mt-0.5" />
              <p className="text-red-300 text-sm">{error}</p>
            </div>
          )}

          {/* Login Form */}
          <form className="space-y-5">
            <div className="space-y-2">
              <label className="text-sm font-medium text-gray-300 ml-1">Email</label>
              <input
                name="email"
                type="email"
                required
                autoComplete="email"
                className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3.5 text-white placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500/50 focus:bg-white/10 transition-all"
                placeholder="you@example.com"
              />
            </div>

            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <label className="text-sm font-medium text-gray-300 ml-1">Password</label>
                <Link href="/forgot-password" className="text-xs text-emerald-400 hover:text-emerald-300 transition-colors">
                  Forgot password?
                </Link>
              </div>
              <input
                name="password"
                type="password"
                required
                autoComplete="current-password"
                className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3.5 text-white placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500/50 focus:bg-white/10 transition-all"
                placeholder="••••••••"
              />
            </div>

            <div className="pt-2">
              <button
                formAction={unifiedLogin}
                className="w-full bg-gradient-to-r from-emerald-600 to-emerald-500 text-white font-semibold py-3.5 rounded-xl hover:from-emerald-500 hover:to-emerald-400 transition-all shadow-lg shadow-emerald-900/40 active:scale-[0.98] flex items-center justify-center gap-2 group"
              >
                <span>Sign In</span>
                <svg className="w-4 h-4 group-hover:translate-x-0.5 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </button>
            </div>
          </form>

          {/* Demo Credentials */}
          <div className="mt-6 p-4 bg-emerald-500/5 border border-emerald-500/20 rounded-xl">
            <p className="text-xs font-medium text-emerald-400 mb-3">🔑 Demo Credentials</p>
            <div className="grid grid-cols-2 gap-3 text-xs">
              <div className="p-2 bg-black/20 rounded-lg">
                <p className="text-gray-500 mb-1">Admin</p>
                <p className="text-white font-mono">admin@demo.com</p>
                <p className="text-gray-400 font-mono">demo1234</p>
              </div>
              <div className="p-2 bg-black/20 rounded-lg">
                <p className="text-gray-500 mb-1">Vendor</p>
                <p className="text-white font-mono">vendor@demo.com</p>
                <p className="text-gray-400 font-mono">demo1234</p>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="mt-8 pt-6 border-t border-white/5 text-center">
            <p className="text-gray-500 text-xs">
              Secure authentication powered by Supabase
            </p>
          </div>
        </div>

        {/* Brand Badge */}
        <div className="mt-6 text-center">
          <p className="text-xs text-gray-600 flex items-center justify-center gap-1">
            <Leaf className="w-3 h-3" />
            <span>Organic • Fresh • Sustainable</span>
          </p>
        </div>
      </div>
    </div>
  )
}
