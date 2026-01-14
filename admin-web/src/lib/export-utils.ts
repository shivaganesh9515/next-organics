/**
 * Export utilities for CSV and PDF generation
 */

export function exportToCSV<T extends Record<string, unknown>>(
  data: T[],
  filename: string,
  columns?: { key: keyof T; label: string }[]
): void {
  if (!data.length) {
    alert('No data to export')
    return
  }

  // Get columns from first item if not provided
  const cols = columns || Object.keys(data[0]).map(key => ({ 
    key: key as keyof T, 
    label: String(key).replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase()) 
  }))

  // Create CSV header
  const header = cols.map(c => `"${c.label}"`).join(',')

  // Create CSV rows
  const rows = data.map(item => 
    cols.map(col => {
      const value = item[col.key]
      if (value === null || value === undefined) return '""'
      if (typeof value === 'string') return `"${value.replace(/"/g, '""')}"`
      if (value instanceof Date) return `"${value.toISOString()}"`
      return `"${String(value)}"`
    }).join(',')
  )

  // Combine and create blob
  const csv = [header, ...rows].join('\n')
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })

  // Download
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = `${filename}_${new Date().toISOString().split('T')[0]}.csv`
  link.click()
  URL.revokeObjectURL(link.href)
}

export function exportOrdersToCSV(orders: Array<{
  order_number: string
  total_amount: number
  status: string
  payment_status: string
  created_at: string
  customer_name?: string
  vendor_name?: string
}>) {
  exportToCSV(orders, 'orders', [
    { key: 'order_number', label: 'Order #' },
    { key: 'customer_name', label: 'Customer' },
    { key: 'vendor_name', label: 'Vendor' },
    { key: 'total_amount', label: 'Amount (₹)' },
    { key: 'status', label: 'Status' },
    { key: 'payment_status', label: 'Payment' },
    { key: 'created_at', label: 'Date' },
  ])
}

export function exportProductsToCSV(products: Array<{
  name: string
  description: string
  price: number
  stock: number
  category_name?: string
  vendor_name?: string
  is_active: boolean
}>) {
  exportToCSV(products, 'products', [
    { key: 'name', label: 'Product Name' },
    { key: 'category_name', label: 'Category' },
    { key: 'vendor_name', label: 'Vendor' },
    { key: 'price', label: 'Price (₹)' },
    { key: 'stock', label: 'Stock' },
    { key: 'is_active', label: 'Active' },
  ])
}

export function exportVendorsToCSV(vendors: Array<{
  shop_name: string
  owner_name: string
  email: string
  phone: string
  status: string
  created_at: string
}>) {
  exportToCSV(vendors, 'vendors', [
    { key: 'shop_name', label: 'Shop Name' },
    { key: 'owner_name', label: 'Owner' },
    { key: 'email', label: 'Email' },
    { key: 'phone', label: 'Phone' },
    { key: 'status', label: 'Status' },
    { key: 'created_at', label: 'Joined' },
  ])
}
