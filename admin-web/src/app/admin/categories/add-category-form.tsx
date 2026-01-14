'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'
import { Plus } from 'lucide-react'

export function AddCategoryForm() {
  const router = useRouter()
  const [isOpen, setIsOpen] = useState(false)
  const [name, setName] = useState('')
  const [isLoading, setIsLoading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!name.trim()) return

    setIsLoading(true)
    const supabase = createClient()
    
    const { data, error } = await supabase
      .from('categories')
      .insert({ name: name.trim(), is_active: true })
      .select()
    
    if (error) {
      console.error('Category insert error:', error)
      alert(`Failed to add category: ${error.message}`)
      setIsLoading(false)
      return
    }
    
    console.log('Category added successfully:', data)
    setName('')
    setIsOpen(false)
    setIsLoading(false)
    
    // Force a hard refresh to update the list
    router.refresh()
  }

  if (!isOpen) {
    return (
      <button onClick={() => setIsOpen(true)} className="btn btn-primary btn-sm">
        <Plus className="w-4 h-4 mr-1" />
        Add Category
      </button>
    )
  }

  return (
    <form onSubmit={handleSubmit} className="flex items-center gap-2">
      <input
        type="text"
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="Category name"
        className="input h-9 w-48"
        autoFocus
      />
      <button type="submit" disabled={isLoading} className="btn btn-primary btn-sm">
        {isLoading ? 'Adding...' : 'Add'}
      </button>
      <button type="button" onClick={() => setIsOpen(false)} className="btn btn-ghost btn-sm">
        Cancel
      </button>
    </form>
  )
}
