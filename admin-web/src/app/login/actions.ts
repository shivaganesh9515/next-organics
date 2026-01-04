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

  // Fetch user role and vendor status
  const { data: profile } = await supabase
    .from('profiles')
    .select('role, vendor_status, full_name')
    .eq('id', data.user.id)
    .single()

  const role = profile?.role?.toUpperCase() || 'CUSTOMER'
  const vendorStatus = profile?.vendor_status?.toUpperCase()

  revalidatePath('/', 'layout')

  // Role-based redirect
  if (role === 'ADMIN') {
    redirect('/dashboard/admin')
  } else if (role === 'VENDOR') {
    if (vendorStatus === 'APPROVED') {
      redirect('/dashboard/vendor')
    } else if (vendorStatus === 'PENDING') {
      redirect('/dashboard/vendor/pending')
    } else {
      // Rejected vendor
      await supabase.auth.signOut()
      redirect('/login?error=' + encodeURIComponent('Your vendor application has been rejected.'))
    }
  } else {
    // Customer or unknown role - not allowed in admin panel
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
