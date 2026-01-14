import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { FileText } from 'lucide-react'

export default async function AdminLogsPage() {
  const supabase = await createClient()

  const { data: logs } = await supabase
    .from('admin_actions')
    .select(`
      id,
      action,
      target_id,
      created_at,
      profiles:admin_id (
        full_name,
        email
      )
    `)
    .order('created_at', { ascending: false })
    .limit(50)

  return (
    <div>
      <PageHeader 
        title="Admin Activity Log" 
        description="Track all administrative actions"
      />

      <div className="dashboard-card">
        {!logs || logs.length === 0 ? (
          <div className="text-center py-12 text-muted-foreground">
            <FileText className="w-8 h-8 mx-auto mb-2 opacity-50" />
            <p>No admin actions recorded yet</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Admin</th>
                  <th>Action</th>
                  <th>Target ID</th>
                  <th>Timestamp</th>
                </tr>
              </thead>
              <tbody>
                {logs.map((log) => {
                  const admin = log.profiles as { full_name: string; email: string } | null
                  return (
                    <tr key={log.id}>
                      <td>
                        <div>
                          <p className="text-sm font-medium">{admin?.full_name || 'Unknown'}</p>
                          <p className="text-xs text-muted-foreground">{admin?.email}</p>
                        </div>
                      </td>
                      <td className="font-medium">{log.action}</td>
                      <td className="text-muted-foreground font-mono text-xs">
                        {log.target_id?.slice(0, 8) || '—'}
                      </td>
                      <td className="text-muted-foreground text-sm">
                        {new Date(log.created_at).toLocaleString()}
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
