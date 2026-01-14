import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { Settings, DollarSign, Truck, Percent, Bell } from 'lucide-react'
import { SettingsForm } from './settings-form'

export default async function AdminSettingsPage() {
  const supabase = await createClient()

  // Fetch current settings (or defaults)
  const { data: settings } = await supabase
    .from('platform_settings')
    .select('*')
    .single()

  const defaultSettings = {
    platform_commission: settings?.platform_commission ?? 10,
    delivery_fee_base: settings?.delivery_fee_base ?? 40,
    delivery_fee_per_km: settings?.delivery_fee_per_km ?? 5,
    min_order_amount: settings?.min_order_amount ?? 100,
    tax_percentage: settings?.tax_percentage ?? 5,
    free_delivery_threshold: settings?.free_delivery_threshold ?? 500,
    max_delivery_radius_km: settings?.max_delivery_radius_km ?? 15,
    order_auto_cancel_hours: settings?.order_auto_cancel_hours ?? 24,
  }

  return (
    <div>
      <PageHeader 
        title="Platform Settings" 
        description="Configure commission rates, delivery fees, and platform rules"
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Settings Form */}
        <div className="lg:col-span-2">
          <SettingsForm initialSettings={defaultSettings} />
        </div>

        {/* Quick Info Sidebar */}
        <div className="space-y-4">
          <div className="dashboard-card">
            <h3 className="font-semibold mb-4 flex items-center gap-2">
              <Settings className="w-4 h-4" />
              Settings Guide
            </h3>
            <div className="space-y-4 text-sm">
              <div className="flex items-start gap-3">
                <DollarSign className="w-4 h-4 text-primary mt-0.5" />
                <div>
                  <p className="font-medium">Commission</p>
                  <p className="text-muted-foreground">Percentage taken from each order</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <Truck className="w-4 h-4 text-info mt-0.5" />
                <div>
                  <p className="font-medium">Delivery Fees</p>
                  <p className="text-muted-foreground">Base fee + per KM charges</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <Percent className="w-4 h-4 text-warning mt-0.5" />
                <div>
                  <p className="font-medium">Tax Rate</p>
                  <p className="text-muted-foreground">GST applied to orders</p>
                </div>
              </div>
            </div>
          </div>

          <div className="dashboard-card border-warning/30 bg-warning/5">
            <div className="flex items-start gap-2">
              <Bell className="w-4 h-4 text-warning mt-0.5" />
              <div className="text-sm">
                <p className="font-medium">Heads up!</p>
                <p className="text-muted-foreground mt-1">
                  Changes to these settings will apply to all new orders immediately.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
