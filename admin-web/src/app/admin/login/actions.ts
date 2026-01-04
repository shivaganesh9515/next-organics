'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { ADMIN_DASHBOARD_PATH, ADMIN_LOGIN_PATH, AUTH_ERRORS } from '@/lib/auth/constants'

export async function adminLogin(formData: FormData) {
    const supabase = await createClient()

    const email = formData.get('email') as string
    const password = formData.get('password') as string

    // Authenticate with Supabase
    const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
    })

    if (error || !data.user) {
        redirect(`${ADMIN_LOGIN_PATH}?error=${encodeURIComponent(AUTH_ERRORS.INVALID_CREDENTIALS)}`)
    }

    // Fetch user role from profiles
    const { data: profile } = await supabase
        .from('profiles')
        .select('role')
        .eq('id', data.user.id)
        .single()

    const role = profile?.role?.toUpperCase()

    // Check if user is an admin
    if (role !== 'ADMIN') {
        // Sign out the non-admin user
        await supabase.auth.signOut()
        redirect(`${ADMIN_LOGIN_PATH}?error=${encodeURIComponent(AUTH_ERRORS.WRONG_ROLE_ADMIN)}`)
    }

    revalidatePath('/', 'layout')
    redirect(ADMIN_DASHBOARD_PATH)
}

export async function adminLogout() {
    const supabase = await createClient()
    await supabase.auth.signOut()
    revalidatePath('/', 'layout')
    redirect(ADMIN_LOGIN_PATH)
}
