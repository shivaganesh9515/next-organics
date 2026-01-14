'use client'

import { useState, useEffect, useCallback } from 'react'
import { Search, Command, X } from 'lucide-react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'

interface CommandItem {
  id: string
  label: string
  description?: string
  icon?: React.ReactNode
  href?: string
  action?: () => void
  keywords?: string[]
}

const defaultCommands: CommandItem[] = [
  { id: 'dashboard', label: 'Go to Dashboard', href: '/admin', keywords: ['home', 'overview'] },
  { id: 'vendors', label: 'View Vendors', href: '/admin/vendors', keywords: ['shops', 'sellers'] },
  { id: 'products', label: 'View Products', href: '/admin/products', keywords: ['items', 'inventory'] },
  { id: 'orders', label: 'View Orders', href: '/admin/orders', keywords: ['sales', 'transactions'] },
  { id: 'categories', label: 'Manage Categories', href: '/admin/categories', keywords: ['groups'] },
  { id: 'settings', label: 'Platform Settings', href: '/admin/settings', keywords: ['config', 'preferences'] },
]

export function CommandPalette({ commands = defaultCommands }: { commands?: CommandItem[] }) {
  const [isOpen, setIsOpen] = useState(false)
  const [query, setQuery] = useState('')
  const [selectedIndex, setSelectedIndex] = useState(0)
  const router = useRouter()

  const filteredCommands = commands.filter(cmd => {
    const searchStr = query.toLowerCase()
    return (
      cmd.label.toLowerCase().includes(searchStr) ||
      cmd.description?.toLowerCase().includes(searchStr) ||
      cmd.keywords?.some(k => k.includes(searchStr))
    )
  })

  const handleSelect = useCallback((cmd: CommandItem) => {
    setIsOpen(false)
    setQuery('')
    if (cmd.href) {
      router.push(cmd.href)
    } else if (cmd.action) {
      cmd.action()
    }
  }, [router])

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Open with Cmd+K or Ctrl+K
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault()
        setIsOpen(prev => !prev)
      }

      // Close with Escape
      if (e.key === 'Escape') {
        setIsOpen(false)
      }

      // Navigate with arrow keys
      if (isOpen) {
        if (e.key === 'ArrowDown') {
          e.preventDefault()
          setSelectedIndex(prev => Math.min(prev + 1, filteredCommands.length - 1))
        }
        if (e.key === 'ArrowUp') {
          e.preventDefault()
          setSelectedIndex(prev => Math.max(prev - 1, 0))
        }
        if (e.key === 'Enter' && filteredCommands[selectedIndex]) {
          e.preventDefault()
          handleSelect(filteredCommands[selectedIndex])
        }
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [isOpen, filteredCommands, selectedIndex, handleSelect])

  useEffect(() => {
    setSelectedIndex(0)
  }, [query])

  if (!isOpen) {
    return (
      <button
        onClick={() => setIsOpen(true)}
        className="flex items-center gap-2 px-3 py-1.5 rounded-lg border border-border bg-muted/50 text-sm text-muted-foreground hover:text-foreground hover:border-border transition-colors"
      >
        <Search className="w-4 h-4" />
        <span className="hidden md:inline">Search...</span>
        <kbd className="hidden md:inline-flex items-center gap-0.5 px-1.5 py-0.5 rounded bg-background border border-border text-[10px] font-mono">
          <Command className="w-3 h-3" />K
        </kbd>
      </button>
    )
  }

  return (
    <div className="fixed inset-0 z-50">
      {/* Overlay */}
      <div 
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={() => setIsOpen(false)}
      />

      {/* Modal */}
      <div className="relative mx-auto mt-[20vh] max-w-lg animate-in slide-in-from-top-4">
        <div className="bg-card rounded-xl shadow-2xl border border-border overflow-hidden">
          {/* Search Input */}
          <div className="flex items-center gap-3 px-4 border-b border-border">
            <Search className="w-5 h-5 text-muted-foreground" />
            <input
              type="text"
              value={query}
              onChange={e => setQuery(e.target.value)}
              placeholder="Search commands..."
              className="flex-1 py-4 bg-transparent outline-none text-foreground placeholder:text-muted-foreground"
              autoFocus
            />
            <button
              onClick={() => setIsOpen(false)}
              className="p-1 rounded hover:bg-muted"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Results */}
          <div className="max-h-80 overflow-auto py-2">
            {filteredCommands.length === 0 ? (
              <p className="px-4 py-8 text-center text-muted-foreground">
                No results found
              </p>
            ) : (
              filteredCommands.map((cmd, i) => (
                <button
                  key={cmd.id}
                  onClick={() => handleSelect(cmd)}
                  onMouseEnter={() => setSelectedIndex(i)}
                  className={`w-full flex items-center gap-3 px-4 py-3 text-left transition-colors ${
                    i === selectedIndex ? 'bg-muted' : 'hover:bg-muted/50'
                  }`}
                >
                  {cmd.icon && <div className="text-muted-foreground">{cmd.icon}</div>}
                  <div className="flex-1">
                    <p className="text-sm font-medium">{cmd.label}</p>
                    {cmd.description && (
                      <p className="text-xs text-muted-foreground">{cmd.description}</p>
                    )}
                  </div>
                  {i === selectedIndex && (
                    <kbd className="px-2 py-0.5 rounded bg-background border border-border text-[10px] font-mono">
                      Enter
                    </kbd>
                  )}
                </button>
              ))
            )}
          </div>

          {/* Footer */}
          <div className="px-4 py-2 border-t border-border text-xs text-muted-foreground flex items-center gap-4">
            <span className="flex items-center gap-1">
              <kbd className="px-1 rounded bg-muted text-[10px]">↑↓</kbd> Navigate
            </span>
            <span className="flex items-center gap-1">
              <kbd className="px-1 rounded bg-muted text-[10px]">Enter</kbd> Select
            </span>
            <span className="flex items-center gap-1">
              <kbd className="px-1 rounded bg-muted text-[10px]">Esc</kbd> Close
            </span>
          </div>
        </div>
      </div>
    </div>
  )
}
