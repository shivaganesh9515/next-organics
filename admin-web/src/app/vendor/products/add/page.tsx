import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { redirect } from 'next/navigation'
import { AddProductForm } from './add-form'

export default async function AddProductPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) redirect('/login')

  // Get vendor
  const { data: vendor } = await supabase
    .from('vendors')
    .select('id, status')
    .eq('user_id', user.id)
    .single()

  if (!vendor || vendor.status !== 'approved') {
    redirect('/vendor')
  }

  // Get categories
  const { data: categories } = await supabase
    .from('categories')
    .select('id, name')
    .eq('is_active', true)
    .order('name')

  return (
    <div>
      <PageHeader 
        title="Add New Product" 
        description="Create a new product listing"
      />

      <div className="dashboard-card max-w-2xl">
        <AddProductForm vendorId={vendor.id} categories={categories || []} />
      </div>
    </div>
  )
}
