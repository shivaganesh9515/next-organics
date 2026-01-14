import type { Metadata } from "next"
import "./globals.css"
import { Toaster } from 'sonner'

export const metadata: Metadata = {
  title: "Nextgen Organics - Admin & Vendor Portal",
  description: "Manage your organic business with ease",
  icons: {
    icon: '/favicon.ico',
  },
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en" data-theme="light" suppressHydrationWarning>
      <body suppressHydrationWarning>
        {children}
        <Toaster richColors position="top-right" />
      </body>
    </html>
  )
}
