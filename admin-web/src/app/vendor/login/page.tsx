import { Store, AlertCircle } from 'lucide-react'
import { vendorLogin } from './actions'
import Link from 'next/link'

interface Props {
    searchParams: Promise<{ error?: string }>
}

export default async function VendorLoginPage({ searchParams }: Props) {
    const { error } = await searchParams

    return (
        <div className="min-h-screen flex items-center justify-center p-4 bg-gradient-to-br from-gray-950 via-orange-950/10 to-gray-950">
            {/* Background Effects */}
            <div className="absolute inset-0 overflow-hidden pointer-events-none">
                <div className="absolute top-1/4 -left-20 w-96 h-96 bg-orange-600/10 rounded-full blur-3xl" />
                <div className="absolute bottom-1/4 -right-20 w-96 h-96 bg-amber-600/10 rounded-full blur-3xl" />
            </div>

            <div className="relative w-full max-w-md">
                {/* Vendor Card */}
                <div className="bg-gray-900/80 backdrop-blur-xl border border-orange-500/20 rounded-3xl p-8 shadow-2xl shadow-orange-900/10">

                    {/* Header */}
                    <div className="text-center mb-8">
                        <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center mx-auto mb-4 shadow-lg shadow-orange-500/30">
                            <Store className="w-8 h-8 text-white" />
                        </div>
                        <h1 className="text-2xl font-bold text-white tracking-tight">Vendor Portal</h1>
                        <p className="text-gray-400 mt-2 text-sm">Manage your products & orders</p>
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
                            <label className="text-sm font-medium text-gray-300 ml-1">Email or Phone</label>
                            <input
                                name="email"
                                type="email"
                                required
                                autoComplete="email"
                                className="w-full bg-gray-800/50 border border-gray-700 rounded-xl px-4 py-3.5 text-white placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-orange-500/50 focus:border-orange-500/50 transition-all"
                                placeholder="vendor@example.com"
                            />
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-medium text-gray-300 ml-1">Password</label>
                            <input
                                name="password"
                                type="password"
                                required
                                autoComplete="current-password"
                                className="w-full bg-gray-800/50 border border-gray-700 rounded-xl px-4 py-3.5 text-white placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-orange-500/50 focus:border-orange-500/50 transition-all"
                                placeholder="••••••••"
                            />
                        </div>

                        <div className="pt-2">
                            <button
                                formAction={vendorLogin}
                                className="w-full bg-gradient-to-r from-orange-600 to-amber-600 text-white font-semibold py-3.5 rounded-xl hover:from-orange-500 hover:to-amber-500 transition-all shadow-lg shadow-orange-900/30 active:scale-[0.98] flex items-center justify-center gap-2"
                            >
                                <Store className="w-4 h-4" />
                                Sign In as Vendor
                            </button>
                        </div>
                    </form>

                    {/* Footer Links */}
                    <div className="mt-8 pt-6 border-t border-gray-800 space-y-3 text-center">
                        <p className="text-gray-500 text-sm">
                            Don't have an account?{' '}
                            <Link href="/vendor/register" className="text-orange-400 hover:text-orange-300 font-medium transition-colors">
                                Apply as Vendor
                            </Link>
                        </p>
                        <p className="text-gray-600 text-xs">
                            Admin?{' '}
                            <Link href="/admin/login" className="text-gray-400 hover:text-gray-300 transition-colors">
                                Go to Admin Portal
                            </Link>
                        </p>
                    </div>
                </div>

                {/* Trust Badge */}
                <div className="mt-6 text-center">
                    <p className="text-xs text-gray-600">🌿 Nextgen Organics Partner Network</p>
                </div>
            </div>
        </div>
    )
}
