'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { Leaf, Upload, Loader2, Check } from 'lucide-react'
import { createClient } from '@/utils/supabase/client'
import { toast } from 'sonner'

export default function RegisterPage() {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [file, setFile] = useState<File | null>(null)
  
  const [formData, setFormData] = useState({
    shopName: '',
    ownerName: '',
    email: '',
    phone: '',
    address: '',
    password: '',
    confirmPassword: ''
  })

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }))
  }

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0])
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (formData.password !== formData.confirmPassword) {
      toast.error("Passwords don't match")
      return
    }

    if (!file) {
      toast.error("Please upload a verification document")
      return
    }

    setIsLoading(true)
    const supabase = createClient()

    try {
      // 1. Sign up user
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: formData.email,
        password: formData.password,
        options: {
          data: {
            full_name: formData.ownerName,
            role: 'vendor'
          }
        }
      })

      if (authError) throw authError
      if (!authData.user) throw new Error("Failed to create user")

      const userId = authData.user.id

      // 2. Upload Document
      const fileExt = file.name.split('.').pop()
      const fileName = `${userId}/${Date.now()}.${fileExt}`
      const { error: uploadError } = await supabase.storage
        .from('vendor-documents')
        .upload(fileName, file)

      if (uploadError) throw uploadError

      const docUrl = supabase.storage.from('vendor-documents').getPublicUrl(fileName).data.publicUrl

      // 3. Create Vendor Record
      // Insert into vendors table with link to profile (created by trigger)
      const { error: vendorError } = await supabase
        .from('vendors')
        .insert({
          user_id: userId,
          shop_name: formData.shopName,
          phone: formData.phone,
          address: formData.address,
          owner_name: formData.ownerName,
          email: formData.email,
          status: 'pending',
          documents: [{ name: file.name, url: docUrl, uploaded_at: new Date().toISOString() }]
        })

      if (vendorError) throw vendorError

      toast.success('Application submitted successfully!')
      router.push('/login?registered=true')

    } catch (error: any) {
      console.error('Registration error:', error)
      toast.error(error.message || 'Failed to register')
      // Clean up auth user if vendor creation failed? 
      // For now, assume manual cleanup or retry needed in real production
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-background flex flex-col items-center justify-center p-4">
      <div className="w-full max-w-xl">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mx-auto mb-4 hover:scale-105 transition-transform duration-300 shadow-lg shadow-primary/20">
            <Leaf className="w-6 h-6 text-primary-foreground" />
          </div>
          <h1 className="text-3xl font-bold tracking-tight text-foreground">Join as a Vendor</h1>
          <p className="text-muted-foreground mt-2">Start your selling journey with Nextgen Organics</p>
        </div>

        {/* Form Card */}
        <div className="bg-card rounded-2xl shadow-xl border border-border p-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
          <form onSubmit={handleSubmit} className="space-y-6">
            
            {/* Business Details */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs">1</span>
                Business Details
              </h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1.5">Shop Name</label>
                  <input
                    required
                    name="shopName"
                    value={formData.shopName}
                    onChange={handleChange}
                    className="input"
                    placeholder="Green Valley Farms"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1.5">Owner Name</label>
                  <input
                    required
                    name="ownerName"
                    value={formData.ownerName}
                    onChange={handleChange}
                    className="input"
                    placeholder="John Doe"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium mb-1.5">Business Address</label>
                <textarea
                  required
                  rows={2}
                  name="address"
                  value={formData.address}
                  onChange={handleChange}
                  className="input min-h-[80px]"
                  placeholder="Full business address..."
                />
              </div>
            </div>

            {/* Contact & Login */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs">2</span>
                Contact & Login
              </h3>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1.5">Email</label>
                  <input
                    required
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    className="input"
                    placeholder="you@company.com"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1.5">Phone Number</label>
                  <input
                    required
                    type="tel"
                    name="phone"
                    value={formData.phone}
                    onChange={handleChange}
                    className="input"
                    placeholder="+91 98765 43210"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1.5">Password</label>
                  <input
                    required
                    type="password"
                    name="password"
                    value={formData.password}
                    onChange={handleChange}
                    className="input"
                    placeholder="••••••••"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1.5">Confirm Password</label>
                  <input
                    required
                    type="password"
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    className="input"
                    placeholder="••••••••"
                  />
                </div>
              </div>
            </div>

            {/* Documents */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs">3</span>
                Verification
              </h3>

              <div className="border-2 border-dashed border-border rounded-xl p-6 hover:border-primary/50 transition-colors text-center cursor-pointer relative group">
                <input
                  type="file"
                  required
                  onChange={handleFileChange}
                  accept=".pdf,.jpg,.jpeg,.png"
                  className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                />
                
                {file ? (
                  <div className="flex flex-col items-center text-success">
                    <div className="w-10 h-10 rounded-full bg-success/10 flex items-center justify-center mb-2">
                      <Check className="w-5 h-5" />
                    </div>
                    <p className="font-medium text-sm">{file.name}</p>
                    <p className="text-xs text-muted-foreground mt-1">{(file.size / 1024 / 1024).toFixed(2)} MB</p>
                  </div>
                ) : (
                  <div className="flex flex-col items-center">
                    <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center mb-2 text-primary group-hover:scale-110 transition-transform">
                      <Upload className="w-5 h-5" />
                    </div>
                    <p className="font-medium text-sm">Upload Government ID</p>
                    <p className="text-xs text-muted-foreground mt-1">GST Certificate, Shop License, or Aadhaar (PDF/JPG)</p>
                  </div>
                )}
              </div>
            </div>

            {/* Submit */}
            <button
              type="submit"
              disabled={isLoading}
              className="btn btn-primary w-full h-11 text-base mt-4"
            >
              {isLoading ? (
                <>
                  <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                  Submitting Application...
                </>
              ) : (
                'Submit Application'
              )}
            </button>
            
            <p className="text-center text-sm text-muted-foreground">
              Already have an account?{' '}
              <Link href="/login" className="text-primary hover:underline font-medium">
                Sign In
              </Link>
            </p>
          </form>
        </div>
      </div>
    </div>
  )
}
