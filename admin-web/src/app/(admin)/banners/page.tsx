'use client'

import { useState } from 'react'
import Link from 'next/link'
import { ArrowLeft, Plus, Save, Trash2, Image as ImageIcon } from 'lucide-react'

// Mock Data
const INITIAL_BANNERS = [
  { id: '1', title: 'FRESH HARVEST', subtitle: 'Organic & Local', colors: ['#66BB6A', '#43A047'], active: true },
  { id: '2', title: 'Go Green', subtitle: 'at ₹1', colors: ['#AED581', '#7CB342'], active: true },
  { id: '3', title: 'Fruits', subtitle: '30% OFF', colors: ['#FFCC80', '#FB8C00'], active: true },
]

export default function BannersPage() {
  const [banners, setBanners] = useState(INITIAL_BANNERS)
  const [isEditing, setIsEditing] = useState(false)

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link href="/" className="p-2 hover:bg-white/10 rounded-full transition-colors">
            <ArrowLeft className="w-6 h-6" />
          </Link>
          <div>
            <h1 className="text-3xl font-bold tracking-tight">Banner Studio</h1>
            <p className="text-muted-foreground">Manage your home screen highlights.</p>
          </div>
        </div>
        <button 
          onClick={() => setIsEditing(true)}
          className="bg-primary text-white px-4 py-2 rounded-full font-semibold flex items-center gap-2 hover:bg-green-700 transition-colors shadow-lg shadow-green-900/20">
          <Plus className="w-5 h-5" />
          Add Banner
        </button>
      </div>

      {/* Content Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Banner List */}
        <div className="lg:col-span-2 space-y-4">
          {banners.map((banner) => (
            <div key={banner.id} className="glass-panel p-6 flex items-center justify-between group">
              <div className="flex items-center gap-4">
                {/* Preview Thumbnail */}
                <div 
                  className="h-16 w-24 rounded-lg flex items-center justify-center text-white/50 font-bold text-xs"
                  style={{ background: `linear-gradient(135deg, ${banner.colors[0]}, ${banner.colors[1]})` }}
                >
                  PREVIEW
                </div>
                
                <div>
                  <h3 className="font-bold text-lg">{banner.title}</h3>
                  <p className="text-gray-400 text-sm">{banner.subtitle}</p>
                </div>
              </div>

              <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <button className="p-2 hover:text-red-400 transition-colors">
                  <Trash2 className="w-5 h-5" />
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Editor Panel (Right Side Web-App Style) */}
        {isEditing && (
          <div className="glass-panel p-6 animate-in slide-in-from-right-10 fade-in duration-300 border-l border-white/10">
            <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
              <ImageIcon className="w-5 h-5 text-primary" />
              New Banner
            </h2>
            
            <form className="space-y-4" onSubmit={(e) => e.preventDefault()}>
              <div>
                <label className="text-xs uppercase font-bold text-gray-500 tracking-wider">Title</label>
                <input type="text" placeholder="e.g. FRESH HARVEST" className="w-full bg-white/5 border border-white/10 rounded-lg p-3 mt-1 focus:outline-none focus:border-primary/50 transition-colors" />
              </div>

              <div>
                <label className="text-xs uppercase font-bold text-gray-500 tracking-wider">Subtitle</label>
                <input type="text" placeholder="e.g. Organic & Local" className="w-full bg-white/5 border border-white/10 rounded-lg p-3 mt-1 focus:outline-none focus:border-primary/50 transition-colors" />
              </div>

              <div>
                <label className="text-xs uppercase font-bold text-gray-500 tracking-wider">CTA Route</label>
                <select className="w-full bg-white/5 border border-white/10 rounded-lg p-3 mt-1 focus:outline-none focus:border-primary/50 [&>option]:text-black">
                  <option value="/category/all">/category/all</option>
                  <option value="/offers">/offers</option>
                  <option value="/new">/new-arrivals</option>
                </select>
              </div>

              <div className="pt-4">
                <button className="w-full bg-white text-black font-bold py-3 rounded-xl hover:bg-gray-200 transition-colors flex items-center justify-center gap-2">
                  <Save className="w-5 h-5" />
                  Save & Publish
                </button>
              </div>
            </form>
          </div>
        )}

      </div>
    </div>
  )
}
