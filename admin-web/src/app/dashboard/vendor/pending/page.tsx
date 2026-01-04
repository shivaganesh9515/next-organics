import { redirect } from 'next/navigation'
import { getUserWithRole, isVendor, isVendorPending } from '@/lib/auth/utils'
import { Clock, Mail, Phone, CheckCircle } from 'lucide-react'
import { logout } from '@/app/login/actions'

export default async function VendorPendingPage() {
    const user = await getUserWithRole()

    if (!user || !isVendor(user)) {
        redirect('/login')
    }

    // If approved, redirect to dashboard
    if (!isVendorPending(user)) {
        redirect('/dashboard/vendor')
    }

    return (
        <div className="min-h-[80vh] flex items-center justify-center p-4">
            <div className="w-full max-w-lg text-center">
                {/* Pending Card */}
                <div className="bg-gray-900/50 backdrop-blur-xl border border-orange-500/20 rounded-3xl p-10">

                    {/* Icon */}
                    <div className="w-20 h-20 rounded-full bg-orange-500/20 flex items-center justify-center mx-auto mb-6 border border-orange-500/30">
                        <Clock className="w-10 h-10 text-orange-400 animate-pulse" />
                    </div>

                    {/* Header */}
                    <h1 className="text-2xl font-bold text-white">Application Under Review</h1>
                    <p className="text-gray-400 mt-3 leading-relaxed">
                        Thank you for registering as a vendor with Nextgen Organics!
                        Your application is currently being reviewed by our team.
                    </p>

                    {/* Status Steps */}
                    <div className="mt-8 space-y-3">
                        <StatusStep
                            icon={CheckCircle}
                            text="Application Submitted"
                            completed
                        />
                        <StatusStep
                            icon={Clock}
                            text="Under Review"
                            active
                        />
                        <StatusStep
                            icon={CheckCircle}
                            text="Approval & Dashboard Access"
                        />
                    </div>

                    {/* Info */}
                    <div className="mt-8 p-4 bg-gray-800/50 rounded-xl border border-white/5">
                        <p className="text-gray-400 text-sm">
                            This usually takes <span className="text-white font-medium">1-2 business days</span>.
                            We'll notify you via email once approved.
                        </p>
                    </div>

                    {/* Contact */}
                    <div className="mt-6 flex items-center justify-center gap-6 text-sm text-gray-500">
                        <a href="mailto:vendors@nextgenorganics.com" className="flex items-center gap-2 hover:text-gray-400 transition-colors">
                            <Mail className="w-4 h-4" />
                            Contact Support
                        </a>
                        <a href="tel:+919876543210" className="flex items-center gap-2 hover:text-gray-400 transition-colors">
                            <Phone className="w-4 h-4" />
                            +91 98765 43210
                        </a>
                    </div>

                    {/* Logout */}
                    <form action={logout} className="mt-8">
                        <button
                            type="submit"
                            className="text-gray-500 hover:text-gray-400 text-sm transition-colors"
                        >
                            Sign out and try another account
                        </button>
                    </form>
                </div>
            </div>
        </div>
    )
}

function StatusStep({
    icon: Icon,
    text,
    completed,
    active
}: {
    icon: any
    text: string
    completed?: boolean
    active?: boolean
}) {
    return (
        <div className={`flex items-center gap-3 p-3 rounded-lg ${active ? 'bg-orange-500/10 border border-orange-500/20' : ''}`}>
            <div className={`
        w-8 h-8 rounded-full flex items-center justify-center
        ${completed ? 'bg-emerald-500/20 text-emerald-400' : ''}
        ${active ? 'bg-orange-500/20 text-orange-400' : ''}
        ${!completed && !active ? 'bg-gray-800 text-gray-600' : ''}
      `}>
                <Icon className="w-4 h-4" />
            </div>
            <span className={`text-sm ${completed || active ? 'text-white' : 'text-gray-600'}`}>
                {text}
            </span>
        </div>
    )
}
