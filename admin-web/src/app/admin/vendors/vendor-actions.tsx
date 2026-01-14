'use client'

import { useState } from 'react'
import { ConfirmDialog } from '@/components/ui/confirm-dialog'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'
import { FileText, ExternalLink, CheckCircle, XCircle, AlertTriangle } from 'lucide-react'
import { toast } from 'sonner'

interface VendorActionsProps {
  vendorId: string
  currentStatus: string
  documents?: { name: string; url: string; uploaded_at: string }[]
}

export function VendorActions({ vendorId, currentStatus, documents = [] }: VendorActionsProps) {
  const router = useRouter()
  const [modalState, setModalState] = useState<{
    isOpen: boolean
    action: 'approve' | 'reject' | 'suspend' | 'review' | null
  }>({ isOpen: false, action: null })
  
  const [isLoading, setIsLoading] = useState(false)

  const handleAction = async () => {
    if (modalState.action === 'review') return // Review is just viewing docs

    setIsLoading(true)
    const supabase = createClient()
    
    // Simple direct update for now, can move to RPC later if complex logic needed
    const newStatus = {
      approve: 'approved',
      reject: 'rejected',
      suspend: 'suspended', 
    }[modalState.action!]

    const { error } = await supabase
      .from('vendors')
      .update({ status: newStatus })
      .eq('id', vendorId)

    if (error) {
      toast.error(error.message)
      setIsLoading(false)
      return
    }

    toast.success(`Vendor ${newStatus} successfully`)
    setModalState({ isOpen: false, action: null })
    setIsLoading(false)
    router.refresh()
  }

  // Configuration for confirmation modals
  const modalConfig = {
    approve: {
      title: 'Approve Vendor',
      message: 'This vendor will be able to add products and receive orders. Have you verified their documents?',
      variant: 'default' as const,
      confirmText: 'Approve Vendor'
    },
    reject: {
      title: 'Reject Vendor',
      message: 'This vendor will not be able to access the platform. They can re-apply.',
      variant: 'danger' as const,
      confirmText: 'Reject Application'
    },
    suspend: {
      title: 'Suspend Vendor',
      message: 'This vendor will be temporarily blocked from the platform.',
      variant: 'warning' as const,
      confirmText: 'Suspend Account'
    },
    review: {
      title: 'Review Documents',
      message: '', // Not used for review modal
      variant: 'default' as const
    }
  }

  return (
    <>
      <div className="flex items-center justify-end gap-2">
        {currentStatus === 'pending' && (
          <>
             <button
              onClick={() => setModalState({ isOpen: true, action: 'review' })}
              className="btn btn-outline btn-sm gap-2"
              title="Review Documents"
            >
              <FileText className="w-4 h-4" />
              <span className="hidden xl:inline">Review Docs</span>
            </button>
            <button
              onClick={() => setModalState({ isOpen: true, action: 'approve' })}
              className="btn btn-success btn-sm"
              disabled={isLoading}
              title="Approve"
            >
              <CheckCircle className="w-4 h-4" />
            </button>
            <button
              onClick={() => setModalState({ isOpen: true, action: 'reject' })}
              className="btn btn-destructive btn-sm"
              disabled={isLoading}
              title="Reject"
            >
              <XCircle className="w-4 h-4" />
            </button>
          </>
        )}
        {currentStatus === 'approved' && (
          <button
            onClick={() => setModalState({ isOpen: true, action: 'suspend' })}
            className="btn btn-warning btn-sm gap-2"
            disabled={isLoading}
          >
            <AlertTriangle className="w-4 h-4" />
            Suspend
          </button>
        )}
        {(currentStatus === 'rejected' || currentStatus === 'suspended') && (
          <button
            onClick={() => setModalState({ isOpen: true, action: 'approve' })}
            className="btn btn-success btn-sm"
            disabled={isLoading}
          >
            Reactivate
          </button>
        )}
      </div>

      {/* Confirmation Modal */}
      {modalState.action && modalState.action !== 'review' && (
        <ConfirmDialog
          isOpen={modalState.isOpen}
          onClose={() => setModalState({ isOpen: false, action: null })}
          onConfirm={handleAction}
          title={modalConfig[modalState.action].title}
          message={modalConfig[modalState.action].message}
          confirmText={modalConfig[modalState.action].confirmText}
          variant={modalConfig[modalState.action].variant}
          isLoading={isLoading}
        />
      )}

      {/* Document Review Modal - Inline for now */}
      {modalState.action === 'review' && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <div className="bg-card w-full max-w-lg rounded-xl shadow-2xl border border-border flex flex-col max-h-[90vh]">
            <div className="p-4 border-b border-border flex justify-between items-center">
              <h3 className="font-semibold text-lg">Vendor Documents</h3>
              <button onClick={() => setModalState({ isOpen: false, action: null })} className="text-muted-foreground hover:text-foreground">
                <XCircle className="w-5 h-5" />
              </button>
            </div>
            
            <div className="p-4 overflow-y-auto flex-1">
              {documents.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">
                  <FileText className="w-12 h-12 mx-auto mb-2 opacity-20" />
                  <p>No documents uploaded</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {documents.map((doc, i) => (
                    <div key={i} className="flex items-center justify-between p-3 bg-muted/50 rounded-lg border border-border">
                      <div className="flex items-center gap-3 overflow-hidden">
                        <div className="w-10 h-10 bg-primary/10 text-primary rounded-lg flex items-center justify-center flex-shrink-0">
                          <FileText className="w-5 h-5" />
                        </div>
                        <div className="min-w-0">
                          <p className="font-medium text-sm truncate">{doc.name}</p>
                          <p className="text-xs text-muted-foreground">{new Date(doc.uploaded_at).toLocaleDateString()}</p>
                        </div>
                      </div>
                      <a 
                        href={doc.url} 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="btn btn-ghost btn-sm text-primary hover:bg-primary/10"
                      >
                        <ExternalLink className="w-4 h-4" />
                      </a>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="p-4 border-t border-border bg-muted/20 flex justify-end gap-2">
              <button 
                onClick={() => setModalState({ isOpen: false, action: null })}
                className="btn btn-ghost"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
