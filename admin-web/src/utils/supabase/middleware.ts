import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

// Route definitions
const PUBLIC_ROUTES = ['/login', '/admin/login', '/vendor/login', '/auth/callback', '/forgot-password']

const ADMIN_ROUTES = ['/', '/banners', '/manufacturers', '/users', '/settings', '/admin/dashboard', '/dashboard/admin']
const VENDOR_ROUTES = ['/inventory', '/orders', '/earnings', '/vendor/dashboard', '/vendor/pending', '/dashboard/vendor']

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

  // Allow public routes
  if (PUBLIC_ROUTES.some(route => pathname.startsWith(route))) {
    // Check if user is already logged in on login pages
    const { data: { user } } = await supabase.auth.getUser()

    if (user && (pathname === '/login' || pathname === '/admin/login' || pathname === '/vendor/login')) {
      // Get user role to redirect appropriately
      const { data: profile } = await supabase
        .from('profiles')
        .select('role, vendor_status')
        .eq('id', user.id)
        .single()

      const role = profile?.role?.toUpperCase()
      const vendorStatus = profile?.vendor_status?.toUpperCase()

      if (role === 'ADMIN') {
        return NextResponse.redirect(new URL('/dashboard/admin', request.url))
      }

      if (role === 'VENDOR') {
        if (vendorStatus === 'APPROVED') {
          return NextResponse.redirect(new URL('/dashboard/vendor', request.url))
        } else if (vendorStatus === 'PENDING') {
          return NextResponse.redirect(new URL('/dashboard/vendor/pending', request.url))
        }
      }
    }

    return response
  }

  // Get current user
  const { data: { user } } = await supabase.auth.getUser()

  // If not logged in, redirect to appropriate login
  if (!user) {
    const isAdminRoute = ADMIN_ROUTES.some(route =>
      pathname === route || pathname.startsWith(route + '/')
    )

    const loginUrl = isAdminRoute ? '/admin/login' : '/vendor/login'
    return NextResponse.redirect(new URL(loginUrl, request.url))
  }

  // Get user role
  const { data: profile } = await supabase
    .from('profiles')
    .select('role, vendor_status')
    .eq('id', user.id)
    .single()

  const role = profile?.role?.toUpperCase() || 'CUSTOMER'
  const vendorStatus = profile?.vendor_status?.toUpperCase()

  // Check route access
  const isAdminRoute = ADMIN_ROUTES.some(route =>
    pathname === route || pathname.startsWith(route + '/')
  )
  const isVendorRoute = VENDOR_ROUTES.some(route =>
    pathname === route || pathname.startsWith(route + '/')
  )

  // Admin trying to access vendor routes -> redirect to admin dashboard
  if (role === 'ADMIN' && isVendorRoute) {
    return NextResponse.redirect(new URL('/admin/dashboard', request.url))
  }

  // Vendor trying to access admin routes -> redirect to vendor dashboard
  if (role === 'VENDOR' && isAdminRoute) {
    if (vendorStatus === 'APPROVED') {
      return NextResponse.redirect(new URL('/vendor/dashboard', request.url))
    } else if (vendorStatus === 'PENDING') {
      return NextResponse.redirect(new URL('/vendor/pending', request.url))
    } else {
      // Rejected vendor - sign out and redirect
      await supabase.auth.signOut()
      return NextResponse.redirect(new URL('/vendor/login?error=Your+account+has+been+rejected', request.url))
    }
  }

  // Customer or unknown role trying to access admin/vendor routes
  if (role === 'CUSTOMER') {
    await supabase.auth.signOut()
    return NextResponse.redirect(new URL('/vendor/login?error=Access+denied', request.url))
  }

  // Vendor accessing vendor routes - check approval status
  if (role === 'VENDOR' && isVendorRoute) {
    // Pending vendor can only access pending page
    if (vendorStatus === 'PENDING' && pathname !== '/vendor/pending') {
      return NextResponse.redirect(new URL('/vendor/pending', request.url))
    }
    // Approved vendor should not see pending page
    if (vendorStatus === 'APPROVED' && pathname === '/vendor/pending') {
      return NextResponse.redirect(new URL('/vendor/dashboard', request.url))
    }
  }

  return response
}
