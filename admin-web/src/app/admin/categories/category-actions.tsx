'use client'

import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'

interface CategoryActionsProps {
  categoryId: string
  isActive: boolean
}

export function CategoryActions({ categoryId, isActive }: CategoryActionsProps) {
  const router = useRouter()

  const toggleStatus = async () => {
    const supabase = createClient()
    
    await supabase
      .from('categories')
      .update({ is_active: !isActive })
      .eq('id', categoryId)

    router.refresh()
  }

  return (
    <div className="flex items-center justify-end gap-2">
      <button
        onClick={toggleStatus}
        className={`btn btn-sm ${isActive ? 'btn-secondary' : 'btn-success'}`}
      >
        {isActive ? 'Disable' : 'Enable'}
      </button>
    </div>
  )
}
