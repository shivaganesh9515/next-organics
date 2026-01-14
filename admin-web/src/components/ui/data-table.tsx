'use client'

import { cn } from '@/lib/utils'

interface Column<T> {
  key: keyof T | string
  header: string
  render?: (item: T) => React.ReactNode
  className?: string
}

interface DataTableProps<T> {
  columns: Column<T>[]
  data: T[]
  keyField: keyof T
  emptyMessage?: string
  className?: string
}

export function DataTable<T extends Record<string, unknown>>({
  columns,
  data,
  keyField,
  emptyMessage = 'No data available',
  className,
}: DataTableProps<T>) {
  if (data.length === 0) {
    return (
      <div className="empty-state">
        <svg className="empty-state-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
        </svg>
        <p className="empty-state-title">{emptyMessage}</p>
      </div>
    )
  }

  return (
    <div className={cn("overflow-x-auto rounded-lg border border-border", className)}>
      <table className="data-table">
        <thead className="bg-muted/50">
          <tr>
            {columns.map((column) => (
              <th key={String(column.key)} className={column.className}>
                {column.header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.map((item) => (
            <tr key={String(item[keyField])}>
              {columns.map((column) => (
                <td key={String(column.key)} className={column.className}>
                  {column.render
                    ? column.render(item)
                    : String(item[column.key as keyof T] ?? '')}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
