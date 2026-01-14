'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'

interface StockUpdateFormProps {
  productId: string
  vendorId: string
  currentStock: number
}

export function StockUpdateForm({ productId, vendorId, currentStock }: StockUpdateFormProps) {
  const router = useRouter()
  const [change, setChange] = useState<string>('')
  const [reason, setReason] = useState<string>('')
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string>('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    const changeValue = parseInt(change)
    if (isNaN(changeValue) || changeValue === 0) return

    setIsLoading(true)
    setError('')
    const supabase = createClient()

    // Use database function for atomic update
    const { data, error: dbError } = await supabase.rpc('update_product_stock', {
      p_product_id: productId,
      p_change: changeValue,
      p_reason: reason || null
    })

    if (dbError) {
      setError(dbError.message)
      setIsLoading(false)
      return
    }

    setChange('')
    setReason('')
    setIsLoading(false)
    router.refresh()
  }

  return (
    <form onSubmit={handleSubmit} className="flex items-center gap-2">
      <input
        type="number"
        value={change}
        onChange={(e) => setChange(e.target.value)}
        placeholder="+10 or -5"
        className="input h-8 w-24 text-sm"
        disabled={isLoading}
      />
      <input
        type="text"
        value={reason}
        onChange={(e) => setReason(e.target.value)}
        placeholder="Reason (optional)"
        className="input h-8 w-32 text-sm"
        disabled={isLoading}
      />
      <button 
        type="submit" 
        disabled={isLoading || !change}
        className="btn btn-primary btn-sm"
      >
        {isLoading ? '...' : 'Update'}
      </button>
      {error && (
        <span className="text-xs text-destructive">{error}</span>
      )}
    </form>
  )
}
