'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'
import { toast } from 'sonner'
import { ImageUpload } from '@/components/ui/image-upload'

interface AddProductFormProps {
  vendorId: string
  categories: { id: string; name: string }[]
}

export function AddProductForm({ vendorId, categories }: AddProductFormProps) {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [imageUrl, setImageUrl] = useState('')
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    price: '',
    stock: '',
    category_id: '',
  })

  // We need to implement handleImageUpload that ImageUpload component expects
  // The ImageUpload component handles the upload logic internally if provided with bucket
  // Or we can handle the file selection and upload here.
  // Let's check ImageUpload props compatibility.
  // It accepts `onUploadComplete` which returns the public URL.

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!formData.name || !formData.price) return

    if (!imageUrl) {
      toast.error('Please upload a product image')
      return
    }

    setIsLoading(true)
    const supabase = createClient()

    const { error } = await supabase.from('products').insert({
      vendor_id: vendorId,
      name: formData.name,
      description: formData.description || null,
      price: parseFloat(formData.price),
      stock: parseInt(formData.stock) || 0,
      category_id: formData.category_id || null,
      image_url: imageUrl,
      is_active: true,
    })

    if (!error) {
      toast.success('Product added successfully!')
      router.push('/vendor/products')
      router.refresh()
    } else {
      toast.error('Failed to add product: ' + error.message)
    }
    setIsLoading(false)
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }))
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Product Image *</label>
        <ImageUpload
          bucket="product-images"
          onUploadComplete={(url) => setImageUrl(url)}
          folderPath={vendorId}
        />
        <p className="text-xs text-muted-foreground">
           Upload a square image (JPG/PNG). Recommended size: 512x512px.
        </p>
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Product Name *</label>
        <input
          name="name"
          type="text"
          required
          value={formData.name}
          onChange={handleChange}
          className="input"
          placeholder="e.g., Organic Tomatoes"
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
          placeholder="Describe your product..."
          disabled={isLoading}
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
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
            placeholder="0.00"
            disabled={isLoading}
          />
        </div>

        <div className="space-y-2">
          <label className="text-sm font-medium text-foreground">Initial Stock</label>
          <input
            name="stock"
            type="number"
            min="0"
            value={formData.stock}
            onChange={handleChange}
            className="input"
            placeholder="0"
            disabled={isLoading}
          />
        </div>
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
          disabled={isLoading || !formData.name || !formData.price || !imageUrl}
          className="btn btn-primary"
        >
          {isLoading ? 'Adding...' : 'Add Product'}
        </button>
      </div>
    </form>
  )
}
