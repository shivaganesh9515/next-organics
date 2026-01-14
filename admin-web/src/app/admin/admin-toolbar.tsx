'use client'

import { NotificationCenter } from '@/components/ui/notification-center'
import { CommandPalette } from '@/components/ui/command-palette'
import { DarkModeToggle } from '@/components/ui/dark-mode-toggle'

export function AdminToolbar() {
  return (
    <div className="sticky top-0 z-30 bg-background/80 backdrop-blur-sm border-b border-border">
      <div className="flex items-center justify-between px-8 py-3">
        <CommandPalette />
        <div className="flex items-center gap-2">
          <DarkModeToggle />
          <NotificationCenter />
        </div>
      </div>
    </div>
  )
}
