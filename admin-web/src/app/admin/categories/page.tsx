import { createClient } from '@/utils/supabase/server'
import { PageHeader } from '@/components/ui/page-components'
import { CategoryActions } from './category-actions'
import { AddCategoryForm } from './add-category-form'
import { FolderTree } from 'lucide-react'

export default async function CategoriesPage() {
  const supabase = await createClient()

  const { data: categories } = await supabase
    .from('categories')
    .select('*')
    .order('name')

  return (
    <div>
      <PageHeader 
        title="Category Control" 
        description="Manage product categories"
      >
        <AddCategoryForm />
      </PageHeader>

      <div className="dashboard-card">
        {!categories || categories.length === 0 ? (
          <div className="text-center py-12 text-muted-foreground">
            <FolderTree className="w-8 h-8 mx-auto mb-2 opacity-50" />
            <p>No categories created yet</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Category Name</th>
                  <th>Status</th>
                  <th className="text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                {categories.map((category) => (
                  <tr key={category.id}>
                    <td className="font-medium">{category.name}</td>
                    <td>
                      <span className={`badge ${category.is_active ? 'badge-approved' : 'badge-suspended'}`}>
                        {category.is_active ? 'Active' : 'Disabled'}
                      </span>
                    </td>
                    <td>
                      <CategoryActions categoryId={category.id} isActive={category.is_active} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
