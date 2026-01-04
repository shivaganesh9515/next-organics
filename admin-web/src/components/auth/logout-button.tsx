'use client'

import { LogOut } from 'lucide-react'
import { useTransition } from 'react'

interface LogoutButtonProps {
    action: () => Promise<void>
    variant?: 'admin' | 'vendor'
}

export function LogoutButton({ action, variant = 'admin' }: LogoutButtonProps) {
    const [isPending, startTransition] = useTransition()

    const colorClasses = {
        admin: 'text-red-400 hover:text-red-300 hover:bg-red-500/10',
        vendor: 'text-gray-400 hover:text-white hover:bg-white/5',
    }

    return (
        <button
            onClick={() => startTransition(() => action())}
            disabled={isPending}
            className={`flex items-center gap-3 text-sm transition-colors p-3 rounded-lg w-full ${colorClasses[variant]} disabled:opacity-50`}
        >
            <LogOut className="w-4 h-4" />
            {isPending ? 'Signing out...' : 'Sign Out'}
        </button>
    )
}
