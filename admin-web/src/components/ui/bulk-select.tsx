'use client'

import { useState } from 'react'
import { Check, Minus } from 'lucide-react'

interface BulkSelectProps<T> {
  items: T[]
  selectedIds: string[]
  onSelectionChange: (ids: string[]) => void
  getId: (item: T) => string
}

export function useBulkSelect<T>(items: T[], getId: (item: T) => string) {
  const [selectedIds, setSelectedIds] = useState<string[]>([])

  const isSelected = (item: T) => selectedIds.includes(getId(item))
  const isAllSelected = items.length > 0 && selectedIds.length === items.length
  const isSomeSelected = selectedIds.length > 0 && selectedIds.length < items.length

  const toggle = (item: T) => {
    const id = getId(item)
    setSelectedIds(prev => 
      prev.includes(id) ? prev.filter(i => i !== id) : [...prev, id]
    )
  }

  const toggleAll = () => {
    if (isAllSelected) {
      setSelectedIds([])
    } else {
      setSelectedIds(items.map(getId))
    }
  }

  const clearSelection = () => setSelectedIds([])

  return {
    selectedIds,
    setSelectedIds,
    isSelected,
    isAllSelected,
    isSomeSelected,
    toggle,
    toggleAll,
    clearSelection,
    selectedCount: selectedIds.length
  }
}

interface CheckboxProps {
  checked: boolean
  indeterminate?: boolean
  onChange: () => void
  disabled?: boolean
}

export function Checkbox({ checked, indeterminate, onChange, disabled }: CheckboxProps) {
  return (
    <button
      onClick={onChange}
      disabled={disabled}
      className={`
        w-5 h-5 rounded border-2 flex items-center justify-center transition-colors
        ${checked || indeterminate 
          ? 'bg-primary border-primary text-primary-foreground' 
          : 'border-border hover:border-primary/50'}
        ${disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}
      `}
    >
      {checked && <Check className="w-3 h-3" />}
      {indeterminate && !checked && <Minus className="w-3 h-3" />}
    </button>
  )
}

interface BulkActionsBarProps {
  selectedCount: number
  onClear: () => void
  children: React.ReactNode
}

export function BulkActionsBar({ selectedCount, onClear, children }: BulkActionsBarProps) {
  if (selectedCount === 0) return null

  return (
    <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 animate-in slide-in-from-bottom-4">
      <div className="bg-card border border-border rounded-xl shadow-2xl px-6 py-3 flex items-center gap-4">
        <div className="flex items-center gap-2">
          <span className="text-sm font-medium">{selectedCount} selected</span>
          <button 
            onClick={onClear}
            className="text-xs text-muted-foreground hover:text-foreground transition-colors"
          >
            Clear
          </button>
        </div>
        <div className="h-6 w-px bg-border" />
        <div className="flex items-center gap-2">
          {children}
        </div>
      </div>
    </div>
  )
}
