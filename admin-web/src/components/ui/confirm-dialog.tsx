'use client'

import { useState } from 'react'
import { AlertTriangle, X, Loader2 } from 'lucide-react'

interface ConfirmDialogProps {
  isOpen: boolean
  onClose: () => void
  onConfirm: () => void | Promise<void>
  title: string
  message: string
  confirmText?: string
  variant?: 'danger' | 'warning' | 'default'
  isLoading?: boolean
}

export function ConfirmDialog({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText = 'Confirm',
  variant = 'default',
  isLoading = false
}: ConfirmDialogProps) {
  if (!isOpen) return null

  const handleConfirm = async () => {
    await onConfirm()
  }

  const variantStyles = {
    danger: {
      icon: 'bg-destructive/10 text-destructive',
      button: 'btn-destructive'
    },
    warning: {
      icon: 'bg-warning/10 text-warning',
      button: 'bg-warning text-warning-foreground hover:bg-warning/90'
    },
    default: {
      icon: 'bg-primary/10 text-primary',
      button: 'btn-primary'
    }
  }

  const styles = variantStyles[variant]

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Overlay */}
      <div 
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={!isLoading ? onClose : undefined}
      />
      
      {/* Modal */}
      <div className="relative bg-card rounded-xl p-6 w-full max-w-md mx-4 shadow-2xl border border-border animate-in fade-in zoom-in-95">
        <button
          onClick={onClose}
          disabled={isLoading}
          className="absolute top-4 right-4 text-muted-foreground hover:text-foreground transition-colors disabled:opacity-50"
        >
          <X className="w-5 h-5" />
        </button>

        <div className="flex flex-col items-center text-center">
          <div className={`w-14 h-14 rounded-full ${styles.icon} flex items-center justify-center mb-4`}>
            <AlertTriangle className="w-7 h-7" />
          </div>
          
          <h3 className="text-lg font-semibold mb-2">{title}</h3>
          <p className="text-sm text-muted-foreground mb-6">{message}</p>
          
          <div className="flex gap-3 w-full">
            <button
              onClick={onClose}
              disabled={isLoading}
              className="btn btn-ghost flex-1"
            >
              Cancel
            </button>
            <button
              onClick={handleConfirm}
              disabled={isLoading}
              className={`btn flex-1 ${styles.button}`}
            >
              {isLoading ? (
                <>
                  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  Processing...
                </>
              ) : confirmText}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
