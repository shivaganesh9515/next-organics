'use client'

import { useState } from 'react'
import Link from 'next/link'
import { ArrowLeft, Plus, Search, MapPin, Store, MoreHorizontal, CheckCircle2 } from 'lucide-react'

// Mock Data
const INITIAL_VENDORS = [
  { id: '1', name: 'Green Valley Farms', location: 'Nashik, MH', status: 'Verified', products: 12, rating: 4.8 },
  { id: '2', name: 'Organic Roots Co.', location: 'Pune, MH', status: 'Pending', products: 5, rating: 0.0 },
  { id: '3', name: 'Pure Daily Dairy', location: 'Mumbai, MH', status: 'Verified', products: 8, rating: 4.9 },
]

export default function ManufacturersPage() {
  const [vendors, setVendors] = useState(INITIAL_VENDORS)

  return (
    <div className="max-w-6xl mx-auto space-y-8">
      
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link href="/" className="p-2 hover:bg-white/10 rounded-full transition-colors">
            <ArrowLeft className="w-6 h-6" />
          </Link>
          <div>
            <h1 className="text-3xl font-bold tracking-tight">Manufacturer Portal</h1>
            <p className="text-muted-foreground">Onboard & manage your ecosystem partners.</p>
          </div>
        </div>
        <button className="bg-primary text-white px-5 py-2.5 rounded-full font-semibold flex items-center gap-2 hover:bg-green-700 transition-all shadow-lg shadow-green-900/20 active:scale-95">
          <Plus className="w-5 h-5" />
          Onboard Vendor
        </button>
      </div>

      {/* Stats Row */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="glass-panel p-6">
          <h3 className="text-gray-400 text-sm font-medium uppercase tracking-wider">Total Partners</h3>
          <p className="text-4xl font-bold mt-2">24</p>
        </div>
        <div className="glass-panel p-6">
          <h3 className="text-gray-400 text-sm font-medium uppercase tracking-wider">Verified Farms</h3>
          <p className="text-4xl font-bold mt-2 text-green-400">18</p>
        </div>
        <div className="glass-panel p-6">
          <h3 className="text-gray-400 text-sm font-medium uppercase tracking-wider">Pending Review</h3>
          <p className="text-4xl font-bold mt-2 text-orange-400">6</p>
        </div>
      </div>

      {/* Search & Filter */}
      <div className="flex gap-4">
        <div className="glass-panel px-4 py-3 flex items-center gap-3 flex-1">
          <Search className="w-5 h-5 text-gray-500" />
          <input 
            type="text" 
            placeholder="Search by name, ID, or location..." 
            className="bg-transparent border-none focus:outline-none w-full placeholder:text-gray-600"
          />
        </div>
        <button className="glass-panel px-6 font-semibold hover:bg-white/5 transition-colors">
          Filters
        </button>
      </div>

      {/* Vendors Table/Grid */}
      <div className="glass-panel overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="border-b border-white/10 text-gray-400 text-sm">
              <th className="p-6 font-medium">Vendor Name</th>
              <th className="p-6 font-medium">Status</th>
              <th className="p-6 font-medium">Location</th>
              <th className="p-6 font-medium">Inventory</th>
              <th className="p-6 font-medium text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {vendors.map((vendor) => (
              <tr key={vendor.id} className="border-b border-white/5 last:border-0 hover:bg-white/5 transition-colors group">
                <td className="p-6">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-gray-700 to-gray-900 flex items-center justify-center font-bold text-sm">
                      {vendor.name.substring(0, 2).toUpperCase()}
                    </div>
                    <div>
                      <div className="font-semibold">{vendor.name}</div>
                      <div className="text-xs text-gray-500">ID: #{vendor.id.padStart(4, '0')}</div>
                    </div>
                  </div>
                </td>
                <td className="p-6">
                  {vendor.status === 'Verified' ? (
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-green-500/10 text-green-400 border border-green-500/20">
                      <CheckCircle2 className="w-3 h-3" /> Verified
                    </span>
                  ) : (
                     <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-orange-500/10 text-orange-400 border border-orange-500/20">
                      Pending
                    </span>
                  )}
                </td>
                <td className="p-6">
                  <div className="flex items-center gap-2 text-gray-400">
                    <MapPin className="w-4 h-4" />
                    {vendor.location}
                  </div>
                </td>
                <td className="p-6">
                  <div className="flex items-center gap-2 text-gray-400">
                    <Store className="w-4 h-4" />
                    {vendor.products} Products
                  </div>
                </td>
                <td className="p-6 text-right">
                  <button className="p-2 hover:bg-white/10 rounded-full transition-colors opacity-0 group-hover:opacity-100">
                    <MoreHorizontal className="w-5 h-5 text-gray-400" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

    </div>
  )
}
