import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

// Public routes that don't require authentication
const PUBLIC_ROUTES = ['/login', '/auth/callback', '/forgot-password']

export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({
    request: { headers: request.headers },
  })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return request.cookies.get(name)?.value
        },
        set(name: string, value: string, options: CookieOptions) {
          request.cookies.set({ name, value, ...options })
          response = NextResponse.next({ request: { headers: request.headers } })
          response.cookies.set({ name, value, ...options })
        },
        remove(name: string, options: CookieOptions) {
          request.cookies.set({ name, value: '', ...options })
          response = NextResponse.next({ request: { headers: request.headers } })
          response.cookies.set({ name, value: '', ...options })
        },
      },
    }
  )

  const pathname = request.nextUrl.pathname

  // Allow public routes without auth check
  if (PUBLIC_ROUTES.some(route => pathname.startsWith(route))) {
    // If user is already logged in on login page, redirect to appropriate dashboard
    const { data: { user } } = await supabase.auth.getUser()

    if (user && pathname === '/login') {
      // Get user role to redirect appropriately
      const { data: profile } = await supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single()

      if (profile?.role === 'admin') {
        return NextResponse.redirect(new URL('/admin', request.url))
      } else if (profile?.role === 'vendor') {
        // Check vendor status
        const { data: vendor } = await supabase
          .from('vendors')
          .select('status')
          .eq('user_id', user.id)
          .single()

        if (vendor?.status === 'approved') {
          return NextResponse.redirect(new URL('/vendor', request.url))
        } else if (vendor?.status === 'pending') {
          return NextResponse.redirect(new URL('/vendor/pending', request.url))
        }
      }
    }

    return response
  }

  // Get current user for protected routes
  const { data: { user } } = await supabase.auth.getUser()

  // If not logged in, redirect to login
  if (!user) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  // Get user role
  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  if (!profile) {
    return NextResponse.redirect(new URL('/login?error=Profile%20not%20found', request.url))
  }

  const role = profile.role

  // Check route access
  const isAdminRoute = pathname.startsWith('/admin')
  const isVendorRoute = pathname.startsWith('/vendor')

  // Admin accessing admin routes - allow
  if (role === 'admin' && isAdminRoute) {
    return response
  }

  // Vendor trying to access admin routes -> redirect to vendor
  if (role === 'vendor' && isAdminRoute) {
    return NextResponse.redirect(new URL('/vendor', request.url))
  }

  // Admin trying to access vendor routes -> redirect to admin
  if (role === 'admin' && isVendorRoute) {
     return NextResponse.redirect(new URL('/admin', request.url))
  }

  // Vendor accessing vendor routes
  if (role === 'vendor' && isVendorRoute) {
    // Check vendor status from vendors table
    const { data: vendor } = await supabase
      .from('vendors')
      .select('status')
      .eq('user_id', user.id)
      .single()

    const status = vendor?.status || 'pending'
    
    // If pending, allow only pending page
    if (status === 'pending' && !pathname.includes('/pending')) {
      return NextResponse.redirect(new URL('/vendor/pending', request.url))
    }

    // If approved, disallow pending page
    if (status === 'approved' && pathname.includes('/pending')) {
       return NextResponse.redirect(new URL('/vendor', request.url))
    }

    return response
  }

  // Default: allow the request
  return response
}
