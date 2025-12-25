import { login, signup } from './actions'
import { Store, UserCircle2 } from 'lucide-react'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <div className="glass-panel p-8 w-full max-w-md animate-in zoom-in-95 duration-500">
        
        {/* Logo / Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-primary/20 flex items-center justify-center mx-auto mb-4 backdrop-blur-sm">
            <Store className="w-8 h-8 text-primary" />
          </div>
          <h1 className="text-2xl font-bold tracking-tight">Welcome Back</h1>
          <p className="text-muted-foreground mt-2">Sign in to your dashboard</p>
        </div>

        {/* Login Form */}
        <form className="space-y-4">
          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300 ml-1">Email</label>
            <input 
              name="email" 
              type="email" 
              required
              className="w-full bg-black/20 border border-white/10 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all placeholder:text-gray-600"
              placeholder="admin@nextgen.com"
            />
          </div>
          
          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300 ml-1">Password</label>
            <input 
              name="password" 
              type="password" 
              required
              className="w-full bg-black/20 border border-white/10 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all placeholder:text-gray-600"
              placeholder="••••••••"
            />
          </div>

          <div className="pt-4 space-y-3">
            <button 
              formAction={login} 
              className="w-full bg-primary text-white font-bold py-3.5 rounded-xl hover:bg-green-600 transition-all shadow-lg shadow-green-900/20 active:scale-[0.98] flex items-center justify-center gap-2"
            >
              Sign In
            </button>
            <button 
              formAction={signup} 
              className="w-full bg-white/5 text-gray-300 font-semibold py-3.5 rounded-xl hover:bg-white/10 transition-colors border border-white/5 active:scale-[0.98]"
            >
              Sign Up
            </button>
          </div>
        </form>

        <div className="mt-8 text-center text-xs text-gray-500">
          <p>Protected by Supabase Auth</p>
        </div>
      </div>
    </div>
  )
}
