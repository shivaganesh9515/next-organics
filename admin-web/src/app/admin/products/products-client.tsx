'use client'

import { useState, useMemo } from 'react'
import { StatusBadge } from '@/components/ui/status-badge'
import { ProductSearch } from '@/components/ui/product-search'
import { Package } from 'lucide-react'

interface Product {
  id: string
  name: string
  description: string | null
  price: number
  stock: number
  is_active: boolean
  image_url: string | null
  vendors: { shop_name: string } | null
  categories: { id: string; name: string } | null
}

interface AdminProductsClientProps {
  products: Product[]
}

export function AdminProductsClient({ products }: AdminProductsClientProps) {
  const [searchQuery, setSearchQuery] = useState('')

  // Filter products based on search query
  const filteredProducts = useMemo(() => {
    if (!searchQuery.trim()) return products

    const query = searchQuery.toLowerCase()
    return products.filter(product => 
      product.name.toLowerCase().includes(query) ||
      product.description?.toLowerCase().includes(query) ||
      product.vendors?.shop_name.toLowerCase().includes(query) ||
      product.categories?.name.toLowerCase().includes(query)
    )
  }, [products, searchQuery])

  // Group filtered products by category
  const productsByCategory = useMemo(() => {
    return filteredProducts.reduce((acc, product) => {
      const category = product.categories
      const categoryName = category?.name || 'Uncategorized'
      const categoryId = category?.id || 'uncategorized'
      
      if (!acc[categoryId]) {
        acc[categoryId] = {
          name: categoryName,
          products: []
        }
      }
      acc[categoryId].products.push(product)
      return acc
    }, {} as Record<string, { name: string; products: Product[] }>)
  }, [filteredProducts])

  // Sort categories alphabetically
  const sortedCategories = useMemo(() => {
    return Object.entries(productsByCategory).sort(([, a], [, b]) => 
      a.name.localeCompare(b.name)
    )
  }, [productsByCategory])

  return (
    <div className="space-y-6">
      {/* Search Bar */}
      <div className="dashboard-card">
        <ProductSearch 
          onSearch={setSearchQuery}
          placeholder="Search by product, vendor, category, or description..."
        />
        {searchQuery && (
          <p className="text-sm text-muted-foreground mt-2">
            Found {filteredProducts.length} product{filteredProducts.length !== 1 ? 's' : ''}
          </p>
        )}
      </div>

      {/* Products by Category */}
      {sortedCategories.length === 0 ? (
        <div className="dashboard-card text-center py-12">
          <Package className="w-8 h-8 mx-auto mb-2 opacity-50 text-muted-foreground" />
          <p className="text-muted-foreground">
            {searchQuery ? 'No products found matching your search' : 'No products yet'}
          </p>
        </div>
      ) : (
        sortedCategories.map(([categoryId, { name, products: categoryProducts }]) => (
          <div key={categoryId} className="dashboard-card">
            <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
              <Package className="w-5 h-5 text-primary" />
              {name}
              <span className="text-sm font-normal text-muted-foreground">
                ({categoryProducts.length} product{categoryProducts.length !== 1 ? 's' : ''})
              </span>
            </h3>
            <div className="overflow-x-auto">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>Vendor</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {categoryProducts.map((product) => {
                    const vendor = product.vendors
                    return (
                      <tr key={product.id}>
                        <td>
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center overflow-hidden flex-shrink-0 border border-border">
                              {product.image_url ? (
                                <img 
                                  src={product.image_url} 
                                  alt={product.name}
                                  className="w-full h-full object-cover"
                                />
                              ) : (
                                <Package className="w-5 h-5 text-muted-foreground opacity-50" />
                              )}
                            </div>
                            <div>
                              <p className="font-medium">{product.name}</p>
                              <p className="text-xs text-muted-foreground line-clamp-1">
                                {product.description || 'No description'}
                              </p>
                            </div>
                          </div>
                        </td>
                        <td>
                          <span className="text-sm bg-muted px-2 py-1 rounded">
                            {vendor?.shop_name || 'Unknown'}
                          </span>
                        </td>
                        <td className="font-medium">₹{product.price}</td>
                        <td>
                          <span className={product.stock <= 10 ? 'text-destructive font-medium' : ''}>
                            {product.stock}
                          </span>
                        </td>
                        <td>
                          <StatusBadge status={product.is_active ? 'Active' : 'Disabled'} />
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          </div>
        ))
      )}
    </div>
  )
}
