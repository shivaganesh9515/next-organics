import { cn } from '@/lib/utils'
import { LucideIcon } from 'lucide-react'

interface PageHeaderProps {
  title: string
  description?: string
  children?: React.ReactNode
  className?: string
}

export function PageHeader({ title, description, children, className }: PageHeaderProps) {
  return (
    <div className={cn('page-header', className)}>
      <div>
        <h1 className="page-title">{title}</h1>
        {description && <p className="page-description">{description}</p>}
      </div>
      {children && <div className="flex items-center gap-3">{children}</div>}
    </div>
  )
}

interface StatsCardProps {
  label: string
  value: string | number
  change?: {
    value: string
    positive: boolean
  }
  icon?: LucideIcon
  className?: string
}

export function StatsCard({ label, value, change, icon: Icon, className }: StatsCardProps) {
  return (
    <div className={cn('stats-card', className)}>
      <div className="flex items-center justify-between">
        <span className="stats-label">{label}</span>
        {Icon && <Icon className="w-5 h-5 text-muted-foreground" />}
      </div>
      <span className="stats-value">{value}</span>
      {change && (
        <span className={cn('stats-change', change.positive ? 'positive' : 'negative')}>
          {change.positive ? '↑' : '↓'} {change.value}
        </span>
      )}
    </div>
  )
}

interface EmptyStateProps {
  icon?: LucideIcon
  title: string
  description?: string
  action?: React.ReactNode
  className?: string
}

export function EmptyState({ icon: Icon, title, description, action, className }: EmptyStateProps) {
  return (
    <div className={cn('empty-state', className)}>
      {Icon && <Icon className="empty-state-icon" />}
      <h3 className="empty-state-title">{title}</h3>
      {description && <p className="empty-state-description">{description}</p>}
      {action && <div className="mt-4">{action}</div>}
    </div>
  )
}
