import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { StatusBadge } from '@/components/ui/status-badge'
import { VendorActions } from './vendor-actions'

export default async function VendorsPage() {
  const supabase = await createClient()

  // Fetch all vendors with their profile info
  const { data: vendors, error: vendorsError } = await supabase
    .from('vendors')
    .select(`
      id,
      shop_name,
      phone,
      address,
      status,
      created_at,
      user_id,
      profiles!vendors_user_id_fkey (
        full_name,
        email
      )
    `)
    .order('created_at', { ascending: false })

  // Log errors for debugging
  if (vendorsError) {
    console.error('Vendors fetch error:', vendorsError)
  }
  
  console.log('Admin - Vendors found:', vendors?.length || 0)

  return (
    <div>
      <PageHeader 
        title="Vendor Management" 
        description="Approve, reject, or suspend vendor accounts"
      />

      <div className="dashboard-card">
        {!vendors || vendors.length === 0 ? (
          <div className="text-center py-12 text-muted-foreground">
            <p>No vendors registered yet</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Shop Name</th>
                  <th>Owner</th>
                  <th>Contact</th>
                  <th>Status</th>
                  <th>Registered</th>
                  <th className="text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                {vendors.map((vendor) => {
                  const profile = vendor.profiles as { full_name: string; email: string } | null
                  return (
                    <tr key={vendor.id}>
                      <td>
                        <div>
                          <p className="font-medium">{vendor.shop_name}</p>
                          <p className="text-xs text-muted-foreground">{vendor.address || 'No address'}</p>
                        </div>
                      </td>
                      <td>
                        <div>
                          <p className="text-sm">{profile?.full_name || 'Unknown'}</p>
                          <p className="text-xs text-muted-foreground">{profile?.email}</p>
                        </div>
                      </td>
                      <td className="text-muted-foreground">{vendor.phone || '—'}</td>
                      <td>
                        <StatusBadge status={vendor.status} />
                      </td>
                      <td className="text-muted-foreground text-sm">
                        {new Date(vendor.created_at).toLocaleDateString()}
                      </td>

                      <td>
                        <VendorActions 
                          vendorId={vendor.id} 
                          currentStatus={vendor.status}
                        />
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
