'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import {
    VENDOR_DASHBOARD_PATH,
    VENDOR_LOGIN_PATH,
    VENDOR_PENDING_PATH,
    AUTH_ERRORS
} from '@/lib/auth/constants'

export async function vendorLogin(formData: FormData) {
    const supabase = await createClient()

    const email = formData.get('email') as string
    const password = formData.get('password') as string

    // Authenticate with Supabase
    const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
    })

    if (error || !data.user) {
        redirect(`${VENDOR_LOGIN_PATH}?error=${encodeURIComponent(AUTH_ERRORS.INVALID_CREDENTIALS)}`)
    }

    // Fetch user role and vendor status
    const { data: profile } = await supabase
        .from('profiles')
        .select('role, vendor_status')
        .eq('id', data.user.id)
        .single()

    const role = profile?.role?.toUpperCase()
    const vendorStatus = profile?.vendor_status?.toUpperCase()

    // Check if user is a vendor
    if (role !== 'VENDOR') {
        await supabase.auth.signOut()
        redirect(`${VENDOR_LOGIN_PATH}?error=${encodeURIComponent(AUTH_ERRORS.WRONG_ROLE_VENDOR)}`)
    }

    // Check vendor approval status
    if (vendorStatus === 'PENDING') {
        revalidatePath('/', 'layout')
        redirect(VENDOR_PENDING_PATH)
    }

    if (vendorStatus === 'REJECTED') {
        await supabase.auth.signOut()
        redirect(`${VENDOR_LOGIN_PATH}?error=${encodeURIComponent(AUTH_ERRORS.VENDOR_REJECTED)}`)
    }

    revalidatePath('/', 'layout')
    redirect(VENDOR_DASHBOARD_PATH)
}

export async function vendorLogout() {
    const supabase = await createClient()
    await supabase.auth.signOut()
    revalidatePath('/', 'layout')
    redirect(VENDOR_LOGIN_PATH)
}
