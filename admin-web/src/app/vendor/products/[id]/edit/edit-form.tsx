'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'
import { toast } from 'sonner'

interface EditProductFormProps {
  product: {
    id: string
    name: string
    description: string | null
    price: number
    stock: number
    category_id: string | null
    is_active: boolean
  }
  categories: { id: string; name: string }[]
}

export function EditProductForm({ product, categories }: EditProductFormProps) {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [formData, setFormData] = useState({
    name: product.name,
    description: product.description || '',
    price: product.price.toString(),
    stock: product.stock.toString(),
    category_id: product.category_id || '',
    is_active: product.is_active,
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!formData.name || !formData.price || !formData.stock) return

    setIsLoading(true)
    const supabase = createClient()

    const { error } = await supabase
      .from('products')
      .update({
        name: formData.name,
        description: formData.description || null,
        price: parseFloat(formData.price),
        stock: parseInt(formData.stock),
        category_id: formData.category_id || null,
        is_active: formData.is_active,
      })
      .eq('id', product.id)

    if (!error) {
      toast.success('Product updated successfully!')
      router.refresh() // Refresh data without navigation
    } else {
      toast.error('Failed to update product: ' + error.message)
    }
    setIsLoading(false)
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value, type } = e.target
    setFormData(prev => ({ 
      ...prev, 
      [name]: type === 'checkbox' ? (e.target as HTMLInputElement).checked : value 
    }))
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Product Name *</label>
        <input
          name="name"
          type="text"
          required
          value={formData.name}
          onChange={handleChange}
          className="input"
          disabled={isLoading}
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Description</label>
        <textarea
          name="description"
          value={formData.description}
          onChange={handleChange}
          className="input min-h-[100px] resize-none"
          disabled={isLoading}
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Price (₹) *</label>
        <input
          name="price"
          type="number"
          step="0.01"
          min="0"
          required
          value={formData.price}
          onChange={handleChange}
          className="input"
          disabled={isLoading}
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Stock Quantity *</label>
        <input
          name="stock"
          type="number"
          min="0"
          required
          value={formData.stock}
          onChange={handleChange}
          className="input"
          disabled={isLoading}
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Category</label>
        <select
          name="category_id"
          value={formData.category_id}
          onChange={handleChange}
          className="input"
          disabled={isLoading}
        >
          <option value="">Select a category</option>
          {categories.map((cat) => (
            <option key={cat.id} value={cat.id}>
              {cat.name}
            </option>
          ))}
        </select>
      </div>

      <div className="flex items-center gap-2">
        <input
          type="checkbox"
          id="is_active"
          name="is_active"
          checked={formData.is_active}
          onChange={handleChange}
          className="w-4 h-4"
          disabled={isLoading}
        />
        <label htmlFor="is_active" className="text-sm font-medium text-foreground cursor-pointer">
          Product is active and available for purchase
        </label>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="button"
          onClick={() => router.back()}
          className="btn btn-secondary"
          disabled={isLoading}
        >
          Cancel
        </button>
        <button
          type="submit"
          disabled={isLoading || !formData.name || !formData.price || !formData.stock}
          className="btn btn-primary"
        >
          {isLoading ? 'Saving...' : 'Save Changes'}
        </button>
      </div>
    </form>
  )
}
