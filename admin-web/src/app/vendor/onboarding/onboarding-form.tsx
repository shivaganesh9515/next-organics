'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'

interface OnboardingFormProps {
  userId: string
}

export function OnboardingForm({ userId }: OnboardingFormProps) {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [formData, setFormData] = useState({
    shop_name: '',
    phone: '',
    address: '',
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!formData.shop_name) return

    setIsLoading(true)
    const supabase = createClient()

    const { error } = await supabase.from('vendors').insert({
      user_id: userId,
      shop_name: formData.shop_name,
      phone: formData.phone || null,
      address: formData.address || null,
      status: 'pending',
    })

    if (error) {
      alert('Error: ' + error.message)
      setIsLoading(false)
      return
    }

    router.push('/vendor/pending')
    router.refresh()
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }))
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Shop Name *</label>
        <input
          name="shop_name"
          type="text"
          required
          value={formData.shop_name}
          onChange={handleChange}
          className="input"
          placeholder="Your shop name"
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Phone Number</label>
        <input
          name="phone"
          type="tel"
          value={formData.phone}
          onChange={handleChange}
          className="input"
          placeholder="+91 9876543210"
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium text-foreground">Address</label>
        <textarea
          name="address"
          value={formData.address}
          onChange={handleChange}
          className="input min-h-[80px] resize-none"
          placeholder="Shop address"
        />
      </div>

      <button
        type="submit"
        disabled={isLoading || !formData.shop_name}
        className="btn btn-primary w-full"
      >
        {isLoading ? 'Submitting...' : 'Submit for Approval'}
      </button>
    </form>
  )
}
