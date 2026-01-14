'use client'

import { ChevronLeft, ChevronRight } from 'lucide-react'

interface PaginationProps {
  currentPage: number
  totalItems: number
  itemsPerPage: number
  onPageChange: (page: number) => void
}

export function Pagination({ currentPage, totalItems, itemsPerPage, onPageChange }: PaginationProps) {
  const totalPages = Math.ceil(totalItems / itemsPerPage)
  
  if (totalPages <= 1) return null

  const pages = []
  const showEllipsis = totalPages > 7

  if (showEllipsis) {
    if (currentPage <= 3) {
      for (let i = 1; i <= 5; i++) pages.push(i)
      pages.push(-1) // Ellipsis
      pages.push(totalPages)
    } else if (currentPage >= totalPages - 2) {
      pages.push(1)
      pages.push(-1)
      for (let i = totalPages - 4; i <= totalPages; i++) pages.push(i)
    } else {
      pages.push(1)
      pages.push(-1)
      for (let i = currentPage - 1; i <= currentPage + 1; i++) pages.push(i)
      pages.push(-2)
      pages.push(totalPages)
    }
  } else {
    for (let i = 1; i <= totalPages; i++) pages.push(i)
  }

  return (
    <div className="flex items-center justify-between mt-6">
      <p className="text-sm text-muted-foreground">
        Showing {Math.min((currentPage - 1) * itemsPerPage + 1, totalItems)} to{' '}
        {Math.min(currentPage * itemsPerPage, totalItems)} of {totalItems} results
      </p>

      <div className="flex items-center gap-1">
        <button
          onClick={() => onPageChange(currentPage - 1)}
          disabled={currentPage === 1}
          className="p-2 rounded-md hover:bg-accent disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          aria-label="Previous page"
        >
          <ChevronLeft className="w-4 h-4" />
        </button>

        {pages.map((page, index) => {
          if (page < 0) {
            return (
              <span key={`ellipsis-${index}`} className="px-3 py-2 text-muted-foreground">
                ...
              </span>
            )
          }

          return (
            <button
              key={page}
              onClick={() => onPageChange(page)}
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                currentPage === page
                  ? 'bg-primary text-primary-foreground'
                  : 'hover:bg-accent'
              }`}
            >
              {page}
            </button>
          )
        })}

        <button
          onClick={() => onPageChange(currentPage + 1)}
          disabled={currentPage === totalPages}
          className="p-2 rounded-md hover:bg-accent disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          aria-label="Next page"
        >
          <ChevronRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  )
}
