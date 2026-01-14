'use client'

import { useState } from 'react'
import Link from 'next/link'
import { Menu, X, Leaf } from 'lucide-react'

interface MobileSidebarProps {
  navItems: Array<{
    href: string
    icon: React.ComponentType<{ className?: string }>
    label: string
  }>
  userInfo: {
    name: string
    role: string
  }
  logo?: React.ReactNode
  onLogout?: () => void
}

export function MobileSidebar({ navItems, userInfo, logo, onLogout }: MobileSidebarProps) {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <>
      {/* Mobile Header */}
      <div className="md:hidden fixed top-0 left-0 right-0 h-14 bg-card border-b border-border z-40 flex items-center justify-between px-4">
        <div className="flex items-center gap-3">
          {logo || (
            <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
              <Leaf className="w-4 h-4 text-primary-foreground" />
            </div>
          )}
          <span className="font-semibold text-sm">Nextgen Organics</span>
        </div>
        <button
          onClick={() => setIsOpen(true)}
          className="p-2 rounded-lg hover:bg-muted transition-colors"
        >
          <Menu className="w-5 h-5" />
        </button>
      </div>

      {/* Mobile padding for fixed header */}
      <div className="md:hidden h-14" />

      {/* Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/60 z-50 md:hidden"
          onClick={() => setIsOpen(false)}
        />
      )}

      {/* Slide-out sidebar */}
      <div className={`
        fixed inset-y-0 left-0 w-64 bg-card border-r border-border z-50 transform transition-transform duration-300 md:hidden
        ${isOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-border">
          <div className="flex items-center gap-3">
            {logo || (
              <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
                <Leaf className="w-4 h-4 text-primary-foreground" />
              </div>
            )}
            <span className="font-semibold text-sm">Nextgen</span>
          </div>
          <button
            onClick={() => setIsOpen(false)}
            className="p-2 rounded-lg hover:bg-muted transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="p-4 space-y-1">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              onClick={() => setIsOpen(false)}
              className="nav-item"
            >
              <item.icon className="w-5 h-5" />
              <span>{item.label}</span>
            </Link>
          ))}
        </nav>

        {/* User Info */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-border">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-8 h-8 rounded-full bg-muted flex items-center justify-center text-xs font-medium">
              {userInfo.name.charAt(0)}
            </div>
            <div>
              <p className="text-sm font-medium">{userInfo.name}</p>
              <p className="text-xs text-muted-foreground">{userInfo.role}</p>
            </div>
          </div>
          {onLogout && (
            <button
              onClick={onLogout}
              className="nav-item w-full text-destructive hover:bg-destructive/10"
            >
              <span>Sign Out</span>
            </button>
          )}
        </div>
      </div>
    </>
  )
}
