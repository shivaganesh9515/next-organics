'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'

export async function unifiedLogin(formData: FormData) {
  const supabase = await createClient()

  const email = formData.get('email') as string
  const password = formData.get('password') as string

  // Authenticate with Supabase
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error || !data.user) {
    redirect(`/login?error=${encodeURIComponent('Invalid email or password. Please try again.')}`)
  }

  // Fetch user profile and role
  const { data: profile } = await supabase
    .from('profiles')
    .select('role, full_name')
    .eq('id', data.user.id)
    .single()

  if (!profile) {
    await supabase.auth.signOut()
    redirect(`/login?error=${encodeURIComponent('User profile not found. Please contact support.')}`)
  }

  const role = profile.role // Already enum: 'admin' or 'vendor'

  revalidatePath('/', 'layout')

  // Role-based redirect
  if (role === 'admin') {
    redirect('/admin')
  } else if (role === 'vendor') {
    // Check vendor status from vendors table
    const { data: vendor } = await supabase
      .from('vendors')
      .select('status')
      .eq('user_id', data.user.id)
      .single()

    if (!vendor) {
      // Vendor record doesn't exist yet - redirect to complete onboarding
      redirect('/vendor/onboarding')
    }

    if (vendor.status === 'approved') {
      redirect('/vendor')
    } else if (vendor.status === 'pending') {
      redirect('/vendor/pending')
    } else {
      // Rejected vendor
      await supabase.auth.signOut()
      redirect('/login?error=' + encodeURIComponent('Your vendor application has been rejected.'))
    }
  } else {
    // Unknown role - not allowed in admin panel
    await supabase.auth.signOut()
    redirect('/login?error=' + encodeURIComponent('Access denied. This portal is for admins and vendors only.'))
  }
}

export async function logout() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  revalidatePath('/', 'layout')
  redirect('/login')
}
