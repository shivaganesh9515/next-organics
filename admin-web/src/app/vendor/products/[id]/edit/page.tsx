import { createClient } from '@/utils/supabase/server'
import { redirect } from 'next/navigation'
import { notFound } from 'next/navigation'
import { PageHeader } from '@/components/ui/page-components'
import { EditProductForm } from './edit-form'

interface PageProps {
  params: Promise<{ id: string }>
}

export default async function EditProductPage({ params }: PageProps) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) redirect('/login')

  // Get vendor
  const { data: vendor } = await supabase
    .from('vendors')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!vendor) redirect('/vendor')

  // Get product (must belong to this vendor)
  const { data: product } = await supabase
    .from('products')
    .select('*')
    .eq('id', id)
    .eq('vendor_id', vendor.id)
    .single()

  if (!product) notFound()

  // Get categories
  const { data: categories } = await supabase
    .from('categories')
    .select('id, name')
    .eq('is_active', true)
    .order('name')

  return (
    <div>
      <PageHeader 
        title="Edit Product" 
        description={`Editing: ${product.name}`}
      />

      <div className="dashboard-card max-w-2xl">
        <EditProductForm 
          product={product} 
          categories={categories || []} 
        />
      </div>
    </div>
  )
}
