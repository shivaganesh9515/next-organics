'use client'

import { useState } from 'react'
import { Bell, X, Check, Package, ShoppingCart, AlertTriangle, Clock } from 'lucide-react'

interface Notification {
  id: string
  type: 'order' | 'stock' | 'vendor' | 'system'
  title: string
  message: string
  time: Date
  read: boolean
}

// Demo notifications
const demoNotifications: Notification[] = [
  {
    id: '1',
    type: 'order',
    title: 'New Order Received',
    message: 'Order #001234 from Demo Customer - ₹540.00',
    time: new Date(Date.now() - 5 * 60 * 1000),
    read: false
  },
  {
    id: '2',
    type: 'stock',
    title: 'Low Stock Alert',
    message: '5 products have stock below 10 units',
    time: new Date(Date.now() - 30 * 60 * 1000),
    read: false
  },
  {
    id: '3',
    type: 'vendor',
    title: 'New Vendor Application',
    message: 'Fresh Farm Store has applied for vendor status',
    time: new Date(Date.now() - 2 * 60 * 60 * 1000),
    read: true
  },
  {
    id: '4',
    type: 'system',
    title: 'System Update',
    message: 'Dashboard analytics have been updated',
    time: new Date(Date.now() - 24 * 60 * 60 * 1000),
    read: true
  }
]

export function NotificationCenter() {
  const [isOpen, setIsOpen] = useState(false)
  const [notifications, setNotifications] = useState(demoNotifications)

  const unreadCount = notifications.filter(n => !n.read).length

  const markAsRead = (id: string) => {
    setNotifications(prev => 
      prev.map(n => n.id === id ? { ...n, read: true } : n)
    )
  }

  const markAllAsRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, read: true })))
  }

  const clearAll = () => {
    setNotifications([])
    setIsOpen(false)
  }

  const getIcon = (type: Notification['type']) => {
    switch (type) {
      case 'order': return <ShoppingCart className="w-4 h-4 text-primary" />
      case 'stock': return <AlertTriangle className="w-4 h-4 text-warning" />
      case 'vendor': return <Package className="w-4 h-4 text-info" />
      case 'system': return <Bell className="w-4 h-4 text-muted-foreground" />
    }
  }

  const formatTime = (date: Date) => {
    const diff = Date.now() - date.getTime()
    const mins = Math.floor(diff / 60000)
    if (mins < 60) return `${mins}m ago`
    const hours = Math.floor(mins / 60)
    if (hours < 24) return `${hours}h ago`
    return `${Math.floor(hours / 24)}d ago`
  }

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="relative p-2 rounded-lg hover:bg-muted transition-colors"
      >
        <Bell className="w-5 h-5" />
        {unreadCount > 0 && (
          <span className="absolute top-1 right-1 w-4 h-4 bg-destructive text-destructive-foreground text-[10px] font-bold rounded-full flex items-center justify-center">
            {unreadCount}
          </span>
        )}
      </button>

      {isOpen && (
        <>
          <div 
            className="fixed inset-0 z-40"
            onClick={() => setIsOpen(false)}
          />
          <div className="absolute right-0 mt-2 w-80 bg-card border border-border rounded-xl shadow-2xl z-50 overflow-hidden">
            {/* Header */}
            <div className="flex items-center justify-between px-4 py-3 border-b border-border">
              <h3 className="font-semibold">Notifications</h3>
              <div className="flex items-center gap-2">
                {unreadCount > 0 && (
                  <button
                    onClick={markAllAsRead}
                    className="text-xs text-primary hover:underline"
                  >
                    Mark all read
                  </button>
                )}
                <button
                  onClick={() => setIsOpen(false)}
                  className="p-1 hover:bg-muted rounded"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            </div>

            {/* Notifications List */}
            <div className="max-h-96 overflow-auto">
              {notifications.length === 0 ? (
                <div className="py-12 text-center text-muted-foreground">
                  <Bell className="w-8 h-8 mx-auto mb-2 opacity-50" />
                  <p className="text-sm">No notifications</p>
                </div>
              ) : (
                notifications.map(notification => (
                  <div
                    key={notification.id}
                    onClick={() => markAsRead(notification.id)}
                    className={`px-4 py-3 border-b border-border last:border-0 hover:bg-muted/50 cursor-pointer transition-colors ${
                      !notification.read ? 'bg-primary/5' : ''
                    }`}
                  >
                    <div className="flex items-start gap-3">
                      <div className="mt-0.5">
                        {getIcon(notification.type)}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2">
                          <p className="text-sm font-medium truncate">
                            {notification.title}
                          </p>
                          {!notification.read && (
                            <span className="w-2 h-2 bg-primary rounded-full flex-shrink-0" />
                          )}
                        </div>
                        <p className="text-xs text-muted-foreground mt-0.5 line-clamp-2">
                          {notification.message}
                        </p>
                        <p className="text-xs text-muted-foreground mt-1 flex items-center gap-1">
                          <Clock className="w-3 h-3" />
                          {formatTime(notification.time)}
                        </p>
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>

            {/* Footer */}
            {notifications.length > 0 && (
              <div className="px-4 py-2 border-t border-border">
                <button
                  onClick={clearAll}
                  className="text-xs text-muted-foreground hover:text-foreground transition-colors"
                >
                  Clear all notifications
                </button>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  )
}
