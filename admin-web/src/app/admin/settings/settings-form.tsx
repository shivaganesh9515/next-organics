'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { toast } from 'sonner'
import { Loader2, Save } from 'lucide-react'

interface SettingsFormProps {
  initialSettings: {
    platform_commission: number
    delivery_fee_base: number
    delivery_fee_per_km: number
    min_order_amount: number
    tax_percentage: number
    free_delivery_threshold: number
    max_delivery_radius_km: number
    order_auto_cancel_hours: number
  }
}

export function SettingsForm({ initialSettings }: SettingsFormProps) {
  const [settings, setSettings] = useState(initialSettings)
  const [isLoading, setIsLoading] = useState(false)

  const handleChange = (key: keyof typeof settings, value: string) => {
    setSettings(prev => ({ ...prev, [key]: parseFloat(value) || 0 }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)

    const supabase = createClient()
    const { error } = await supabase
      .from('platform_settings')
      .upsert({ id: 1, ...settings, updated_at: new Date().toISOString() })

    if (error) {
      toast.error('Failed to save settings')
      console.error(error)
    } else {
      toast.success('Settings saved successfully!')
    }

    setIsLoading(false)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {/* Commission & Fees */}
      <div className="dashboard-card">
        <h3 className="font-semibold mb-4">Commission & Fees</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Platform Commission (%)
            </label>
            <input
              type="number"
              min="0"
              max="50"
              step="0.5"
              value={settings.platform_commission}
              onChange={e => handleChange('platform_commission', e.target.value)}
              className="input"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Tax Percentage (GST %)
            </label>
            <input
              type="number"
              min="0"
              max="28"
              step="0.5"
              value={settings.tax_percentage}
              onChange={e => handleChange('tax_percentage', e.target.value)}
              className="input"
            />
          </div>
        </div>
      </div>

      {/* Delivery Settings */}
      <div className="dashboard-card">
        <h3 className="font-semibold mb-4">Delivery Settings</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Base Delivery Fee (₹)
            </label>
            <input
              type="number"
              min="0"
              value={settings.delivery_fee_base}
              onChange={e => handleChange('delivery_fee_base', e.target.value)}
              className="input"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Per KM Charge (₹)
            </label>
            <input
              type="number"
              min="0"
              step="0.5"
              value={settings.delivery_fee_per_km}
              onChange={e => handleChange('delivery_fee_per_km', e.target.value)}
              className="input"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Free Delivery Above (₹)
            </label>
            <input
              type="number"
              min="0"
              value={settings.free_delivery_threshold}
              onChange={e => handleChange('free_delivery_threshold', e.target.value)}
              className="input"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Max Delivery Radius (KM)
            </label>
            <input
              type="number"
              min="1"
              max="50"
              value={settings.max_delivery_radius_km}
              onChange={e => handleChange('max_delivery_radius_km', e.target.value)}
              className="input"
            />
          </div>
        </div>
      </div>

      {/* Order Rules */}
      <div className="dashboard-card">
        <h3 className="font-semibold mb-4">Order Rules</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Minimum Order Amount (₹)
            </label>
            <input
              type="number"
              min="0"
              value={settings.min_order_amount}
              onChange={e => handleChange('min_order_amount', e.target.value)}
              className="input"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1.5">
              Auto Cancel After (Hours)
            </label>
            <input
              type="number"
              min="1"
              max="72"
              value={settings.order_auto_cancel_hours}
              onChange={e => handleChange('order_auto_cancel_hours', e.target.value)}
              className="input"
            />
            <p className="text-xs text-muted-foreground mt-1">
              Unconfirmed orders will be cancelled after this time
            </p>
          </div>
        </div>
      </div>

      {/* Save Button */}
      <div className="flex justify-end">
        <button type="submit" disabled={isLoading} className="btn btn-primary">
          {isLoading ? (
            <Loader2 className="w-4 h-4 mr-2 animate-spin" />
          ) : (
            <Save className="w-4 h-4 mr-2" />
          )}
          {isLoading ? 'Saving...' : 'Save Settings'}
        </button>
      </div>
    </form>
  )
}
