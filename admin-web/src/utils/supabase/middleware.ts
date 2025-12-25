import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
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
          request.cookies.set({
            name,
            value,
            ...options,
          })
          response = NextResponse.next({
            request: {
              headers: request.headers,
            },
          })
          response.cookies.set({
            name,
            value,
            ...options,
          })
        },
        remove(name: string, options: CookieOptions) {
          request.cookies.set({
            name,
            value: '',
            ...options,
          })
          response = NextResponse.next({
            request: {
              headers: request.headers,
            },
          })
          response.cookies.set({
            name,
            value: '',
            ...options,
          })
        },
      },
    }
  )

  const {
    data: { user },
  } = await supabase.auth.getUser()

  // RBAC LOGIC
  
  // 1. If NOT logged in, and trying to access PROTECTED routes -> Redirect to Login
  if (!user && !request.nextUrl.pathname.startsWith('/login')) {
     const url = request.nextUrl.clone()
     url.pathname = '/login'
     return NextResponse.redirect(url)
  }

      // 3. Fetch User Role
      const { data: profile } = await supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single()

      const role = profile?.role || 'customer'

      // 4. Define Route Groups
      // Vendor Routes: /inventory, /orders, /earnings
      const isVendorRoute = 
        request.nextUrl.pathname.startsWith('/inventory') || 
        request.nextUrl.pathname.startsWith('/orders') ||
        request.nextUrl.pathname.startsWith('/earnings');

      // Admin Routes: / (Home), /banners, /manufacturers
      const isAdminRoute = 
        request.nextUrl.pathname === '/' || 
        request.nextUrl.pathname.startsWith('/banners') || 
        request.nextUrl.pathname.startsWith('/manufacturers');

      // 5. Redirect Logic (Enforce Separation)
      
      // If VENDOR tries to access Admin Zones -> Kick to Vendor Dashboard
      if (role === 'vendor' && isAdminRoute) {
        const url = request.nextUrl.clone()
        url.pathname = '/orders'
        return NextResponse.redirect(url)
      }

      // If LOGGED IN (Admin/Vendor) at Login Page -> Send to respective home
      if (request.nextUrl.pathname.startsWith('/login')) {
         const url = request.nextUrl.clone()
         if (role === 'vendor') {
           url.pathname = '/orders'
         } else {
           url.pathname = '/' // Admin Dashboard
         }
         return NextResponse.redirect(url)
      }

  return response
}
