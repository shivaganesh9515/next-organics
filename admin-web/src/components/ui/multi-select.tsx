'use client'

import { useState, useEffect, useRef } from 'react'
import { X, ChevronDown, Check } from 'lucide-react'

interface Option {
  value: string
  label: string
}

interface MultiSelectProps {
  options: Option[]
  selected: string[]
  onChange: (values: string[]) => void
  placeholder?: string
  label?: string
}

export function MultiSelect({ 
  options, 
  selected, 
  onChange, 
  placeholder = 'Select...',
  label 
}: MultiSelectProps) {
  const [isOpen, setIsOpen] = useState(false)
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setIsOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const toggle = (value: string) => {
    onChange(
      selected.includes(value)
        ? selected.filter(v => v !== value)
        : [...selected, value]
    )
  }

  const clear = () => onChange([])

  const selectedLabels = options
    .filter(o => selected.includes(o.value))
    .map(o => o.label)

  return (
    <div ref={ref} className="relative">
      {label && (
        <label className="block text-sm font-medium mb-1.5">{label}</label>
      )}
      
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between gap-2 px-3 py-2 rounded-lg border border-border bg-background text-left hover:border-primary/50 transition-colors"
      >
        <span className={`text-sm truncate ${selected.length === 0 ? 'text-muted-foreground' : ''}`}>
          {selected.length === 0 
            ? placeholder 
            : selectedLabels.length <= 2 
              ? selectedLabels.join(', ')
              : `${selectedLabels.length} selected`}
        </span>
        <div className="flex items-center gap-1 flex-shrink-0">
          {selected.length > 0 && (
            <button
              type="button"
              onClick={(e) => { e.stopPropagation(); clear() }}
              className="p-0.5 hover:bg-muted rounded"
            >
              <X className="w-3 h-3" />
            </button>
          )}
          <ChevronDown className={`w-4 h-4 text-muted-foreground transition-transform ${isOpen ? 'rotate-180' : ''}`} />
        </div>
      </button>

      {isOpen && (
        <div className="absolute z-50 w-full mt-1 py-1 bg-card border border-border rounded-lg shadow-lg max-h-60 overflow-auto">
          {options.map(option => (
            <button
              key={option.value}
              type="button"
              onClick={() => toggle(option.value)}
              className="w-full flex items-center gap-2 px-3 py-2 text-sm hover:bg-muted transition-colors"
            >
              <div className={`w-4 h-4 rounded border flex items-center justify-center ${
                selected.includes(option.value) 
                  ? 'bg-primary border-primary text-primary-foreground' 
                  : 'border-border'
              }`}>
                {selected.includes(option.value) && <Check className="w-3 h-3" />}
              </div>
              <span>{option.label}</span>
            </button>
          ))}
          {options.length === 0 && (
            <p className="px-3 py-2 text-sm text-muted-foreground">No options</p>
          )}
        </div>
      )}
    </div>
  )
}

interface FilterChipsProps {
  filters: { key: string; label: string; value: string }[]
  onRemove: (key: string) => void
  onClearAll: () => void
}

export function FilterChips({ filters, onRemove, onClearAll }: FilterChipsProps) {
  if (filters.length === 0) return null

  return (
    <div className="flex flex-wrap items-center gap-2 py-2">
      {filters.map(filter => (
        <span
          key={filter.key}
          className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-primary/10 text-primary text-xs font-medium"
        >
          <span className="text-muted-foreground">{filter.label}:</span>
          {filter.value}
          <button
            onClick={() => onRemove(filter.key)}
            className="hover:bg-primary/20 rounded-full p-0.5 transition-colors"
          >
            <X className="w-3 h-3" />
          </button>
        </span>
      ))}
      <button
        onClick={onClearAll}
        className="text-xs text-muted-foreground hover:text-foreground transition-colors"
      >
        Clear all
      </button>
    </div>
  )
}
