import { redirect } from 'next/navigation'
import { getUserWithRole } from '@/lib/auth/utils'
import { Sidebar } from '@/components/dashboard/sidebar'
import { Topbar } from '@/components/dashboard/topbar'

export default async function DashboardLayout({
    children,
}: {
    children: React.ReactNode
}) {
    const user = await getUserWithRole()

    if (!user) {
        redirect('/login')
    }

    if (user.role !== 'ADMIN' && user.role !== 'VENDOR') {
        redirect('/login?error=' + encodeURIComponent('Access denied'))
    }

    // For vendors, check approval status
    if (user.role === 'VENDOR' && user.vendorStatus !== 'APPROVED') {
        redirect('/dashboard/vendor/pending')
    }

    return (
        <div className="flex min-h-screen">
            {/* Dynamic Sidebar */}
            <Sidebar
                role={user.role as 'ADMIN' | 'VENDOR'}
                userName={user.name}
            />

            {/* Main Content */}
            <div className="flex-1 flex flex-col overflow-hidden">
                {/* Top Navigation */}
                <Topbar
                    role={user.role as 'ADMIN' | 'VENDOR'}
                    userName={user.name}
                    userEmail={user.email}
                />

                {/* Page Content */}
                <main className="flex-1 overflow-auto">
                    <div className="p-6">
                        {children}
                    </div>
                </main>
            </div>
        </div>
    )
}
