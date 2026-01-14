'use client'

import { useState } from 'react'
import { Calendar } from 'lucide-react'

export type DateRangePreset = 'today' | 'week' | 'month' | 'custom'

interface DateRangePickerProps {
  onRangeChange: (preset: DateRangePreset, start?: Date, end?: Date) => void
  currentPreset?: DateRangePreset
}

export function DateRangePicker({ onRangeChange, currentPreset = 'week' }: DateRangePickerProps) {
  const [selected, setSelected] = useState<DateRangePreset>(currentPreset)

  const handlePresetClick = (preset: DateRangePreset) => {
    setSelected(preset)
    
    const now = new Date()
    let start: Date
    let end: Date = now

    switch (preset) {
      case 'today':
        start = new Date(now.setHours(0, 0, 0, 0))
        break
      case 'week':
        start = new Date(now.setDate(now.getDate() - 7))
        break
      case 'month':
        start = new Date(now.setDate(now.getDate() - 30))
        break
      default:
        return
    }

    onRangeChange(preset, start, end)
  }

  return (
    <div className="flex items-center gap-2">
      <Calendar className="w-4 h-4 text-muted-foreground" />
      <div className="flex gap-1 bg-muted rounded-lg p-1">
        <button
          onClick={() => handlePresetClick('today')}
          className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
            selected === 'today'
              ? 'bg-background text-foreground shadow-sm'
              : 'text-muted-foreground hover:text-foreground'
          }`}
        >
          Today
        </button>
        <button
          onClick={() => handlePresetClick('week')}
          className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
            selected === 'week'
              ? 'bg-background text-foreground shadow-sm'
              : 'text-muted-foreground hover:text-foreground'
          }`}
        >
          7 Days
        </button>
        <button
          onClick={() => handlePresetClick('month')}
          className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
            selected === 'month'
              ? 'bg-background text-foreground shadow-sm'
              : 'text-muted-foreground hover:text-foreground'
          }`}
        >
          30 Days
        </button>
      </div>
    </div>
  )
}
