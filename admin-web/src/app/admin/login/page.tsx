import { Shield, AlertCircle } from 'lucide-react'
import { adminLogin } from './actions'
import Link from 'next/link'

interface Props {
    searchParams: Promise<{ error?: string }>
}

export default async function AdminLoginPage({ searchParams }: Props) {
    const { error } = await searchParams

    return (
        <div className="min-h-screen flex items-center justify-center p-4 bg-gradient-to-br from-gray-950 via-purple-950/20 to-gray-950">
            {/* Background Effects */}
            <div className="absolute inset-0 overflow-hidden pointer-events-none">
                <div className="absolute top-1/4 -left-20 w-96 h-96 bg-purple-600/10 rounded-full blur-3xl" />
                <div className="absolute bottom-1/4 -right-20 w-96 h-96 bg-indigo-600/10 rounded-full blur-3xl" />
            </div>

            <div className="relative w-full max-w-md">
                {/* Admin Card */}
                <div className="bg-gray-900/80 backdrop-blur-xl border border-purple-500/20 rounded-3xl p-8 shadow-2xl shadow-purple-900/20">

                    {/* Header */}
                    <div className="text-center mb-8">
                        <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-purple-500 to-indigo-600 flex items-center justify-center mx-auto mb-4 shadow-lg shadow-purple-500/30">
                            <Shield className="w-8 h-8 text-white" />
                        </div>
                        <h1 className="text-2xl font-bold text-white tracking-tight">Admin Portal</h1>
                        <p className="text-gray-400 mt-2 text-sm">Nextgen Organics Platform Management</p>
                    </div>

                    {/* Error Alert */}
                    {error && (
                        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/30 rounded-xl flex items-start gap-3">
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
                                className="w-full bg-gray-800/50 border border-gray-700 rounded-xl px-4 py-3.5 text-white placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500/50 focus:border-purple-500/50 transition-all"
                                placeholder="admin@nextgenorganics.com"
                            />
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-medium text-gray-300 ml-1">Password</label>
                            <input
                                name="password"
                                type="password"
                                required
                                autoComplete="current-password"
                                className="w-full bg-gray-800/50 border border-gray-700 rounded-xl px-4 py-3.5 text-white placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500/50 focus:border-purple-500/50 transition-all"
                                placeholder="••••••••"
                            />
                        </div>

                        <div className="pt-2">
                            <button
                                formAction={adminLogin}
                                className="w-full bg-gradient-to-r from-purple-600 to-indigo-600 text-white font-semibold py-3.5 rounded-xl hover:from-purple-500 hover:to-indigo-500 transition-all shadow-lg shadow-purple-900/30 active:scale-[0.98] flex items-center justify-center gap-2"
                            >
                                <Shield className="w-4 h-4" />
                                Sign In as Admin
                            </button>
                        </div>
                    </form>

                    {/* Footer */}
                    <div className="mt-8 pt-6 border-t border-gray-800 text-center">
                        <p className="text-gray-500 text-sm">
                            Are you a vendor?{' '}
                            <Link href="/vendor/login" className="text-purple-400 hover:text-purple-300 font-medium transition-colors">
                                Go to Vendor Portal
                            </Link>
                        </p>
                    </div>
                </div>

                {/* Security Badge */}
                <div className="mt-6 text-center">
                    <p className="text-xs text-gray-600">🔒 Secured by Supabase Authentication</p>
                </div>
            </div>
        </div>
    )
}
