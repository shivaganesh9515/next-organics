import { createClient } from '@/utils/supabase/server'
import { redirect } from 'next/navigation'
import { Leaf } from 'lucide-react'
import { OnboardingForm } from './onboarding-form'

export default async function VendorOnboardingPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) {
    redirect('/login')
  }

  // Check if already has vendor record
  const { data: vendor } = await supabase
    .from('vendors')
    .select('id, status')
    .eq('user_id', user.id)
    .single()

  if (vendor) {
    if (vendor.status === 'approved') {
      redirect('/vendor')
    } else {
      redirect('/vendor/pending')
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-background">
      <div className="w-full max-w-lg">
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-xl bg-primary flex items-center justify-center mx-auto mb-4">
            <Leaf className="w-8 h-8 text-primary-foreground" />
          </div>
          <h1 className="text-xl font-semibold">Complete Your Vendor Profile</h1>
          <p className="text-muted-foreground mt-1 text-sm">
            Fill in your shop details to start selling
          </p>
        </div>

        <div className="bg-card border border-border rounded-lg p-6">
          <OnboardingForm userId={user.id} />
        </div>
      </div>
    </div>
  )
}
