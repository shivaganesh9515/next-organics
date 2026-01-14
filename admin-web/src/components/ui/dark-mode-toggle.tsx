'use client'

import { useState, useEffect } from 'react'
import { Sun, Moon } from 'lucide-react'

export function DarkModeToggle() {
  const [isDark, setIsDark] = useState(false)

  useEffect(() => {
    // Check initial preference
    const stored = localStorage.getItem('theme')
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
    const shouldBeDark = stored === 'dark' || (!stored && prefersDark)
    
    setIsDark(shouldBeDark)
    document.documentElement.classList.toggle('dark', shouldBeDark)
  }, [])

  const toggle = () => {
    const newValue = !isDark
    setIsDark(newValue)
    localStorage.setItem('theme', newValue ? 'dark' : 'light')
    document.documentElement.classList.toggle('dark', newValue)
  }

  return (
    <button
      onClick={toggle}
      className="p-2 rounded-lg hover:bg-muted transition-colors"
      title={isDark ? 'Switch to light mode' : 'Switch to dark mode'}
    >
      {isDark ? (
        <Sun className="w-5 h-5" />
      ) : (
        <Moon className="w-5 h-5" />
      )}
    </button>
  )
}
