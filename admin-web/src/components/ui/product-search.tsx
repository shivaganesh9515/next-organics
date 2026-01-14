'use client'

import { Search, X } from 'lucide-react'
import { useState } from 'react'

interface ProductSearchProps {
  onSearch: (query: string) => void
  placeholder?: string
}

export function ProductSearch({ onSearch, placeholder = "Search products..." }: ProductSearchProps) {
  const [query, setQuery] = useState('')

  const handleChange = (value: string) => {
    setQuery(value)
    onSearch(value)
  }

  const handleClear = () => {
    setQuery('')
    onSearch('')
  }

  return (
    <div className="relative w-full max-w-md">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
        <input
          type="text"
          value={query}
          onChange={(e) => handleChange(e.target.value)}
          placeholder={placeholder}
          className="input pl-10 pr-10"
        />
        {query && (
          <button
            onClick={handleClear}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
            type="button"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>
    </div>
  )
}
