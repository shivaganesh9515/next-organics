'use client'

import { useState } from 'react'
import { Package, AlertTriangle, XCircle, Search, Edit2, Archive } from 'lucide-react'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

// Mock Data (Ported)
const INITIAL_PRODUCTS = [
  { id: '1', name: 'Alphonso Mangoes', category: 'Fruits', stock: 120, unit: 'doz', status: 'In Stock' },
  { id: '2', name: 'Basmati Rice', category: 'Grains', stock: 450, unit: 'kg', status: 'In Stock' },
  { id: '3', name: 'Organic Honey', category: 'Essentials', stock: 4, unit: 'btl', status: 'Low Stock' },
  { id: '4', name: 'Desi Ghee', category: 'Dairy', stock: 0, unit: 'kg', status: 'Out of Stock' },
]

export default function InventoryPage() {
  const [products] = useState(INITIAL_PRODUCTS)

  // Calcs
  const lowStock = products.filter(p => p.stock > 0 && p.stock <= 5).length
  const outStock = products.filter(p => p.stock === 0).length

  return (
    <div className="max-w-7xl mx-auto space-y-8 animate-in fade-in duration-500">
      
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Inventory</h1>
          <p className="text-muted-foreground">Manage your realtime stock and listings.</p>
        </div>
        <Button className="font-semibold shadow-lg shadow-primary/20">
          <Archive className="mr-2 h-4 w-4" /> Add Product
        </Button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard 
          icon={Package} 
          title="Total Products" 
          value={products.length} 
          desc="Active Listings"
          className="bg-blue-500/10 text-blue-600 border-blue-200/20"
        />
        <StatCard 
          icon={AlertTriangle} 
          title="Low Stock" 
          value={lowStock} 
          desc="Restock Needed"
          className="bg-orange-500/10 text-orange-600 border-orange-200/20"
        />
        <StatCard 
          icon={XCircle} 
          title="Out of Stock" 
          value={outStock} 
          desc="Unavailable"
          className="bg-red-500/10 text-red-600 border-red-200/20"
        />
      </div>

      {/* Filters */}
      <div className="flex gap-4 items-center bg-white/5 p-4 rounded-xl border border-white/10 backdrop-blur-md">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
          <Input 
            placeholder="Search products..." 
            className="pl-9 bg-black/10 border-white/10"
          />
        </div>
        <Button variant="outline" className="border-white/10 hover:bg-white/5">
            Filter
        </Button>
      </div>

      {/* Inventory Table (Shadcn) */}
      <div className="rounded-xl border border-white/10 overflow-hidden bg-black/20 backdrop-blur-xl">
        <Table>
          <TableHeader className="bg-white/5">
            <TableRow className="border-white/10 hover:bg-transparent">
              <TableHead className="w-[100px]">ID</TableHead>
              <TableHead>Product</TableHead>
              <TableHead>Category</TableHead>
              <TableHead>Stock</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Action</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {products.map((product) => (
              <TableRow key={product.id} className="border-white/5 hover:bg-white/5 transition-colors">
                <TableCell className="font-medium text-muted-foreground">#{product.id}</TableCell>
                <TableCell className="font-bold">{product.name}</TableCell>
                <TableCell>{product.category}</TableCell>
                <TableCell className="font-mono text-lg">
                    {product.stock} <span className="text-xs text-muted-foreground">{product.unit}</span>
                </TableCell>
                <TableCell>
                  {product.stock === 0 ? (
                    <Badge variant="destructive" className="bg-red-500/20 text-red-400 border-red-500/50 hover:bg-red-500/30">Out of Stock</Badge>
                  ) : product.stock <= 5 ? (
                    <Badge className="bg-orange-500/20 text-orange-400 border-orange-500/50 hover:bg-orange-500/30">Low Stock</Badge>
                  ) : (
                    <Badge className="bg-green-500/20 text-green-400 border-green-500/50 hover:bg-green-500/30">In Stock</Badge>
                  )}
                </TableCell>
                <TableCell className="text-right">
                    <Button variant="ghost" size="icon" className="hover:bg-white/10 rounded-full h-8 w-8">
                        <Edit2 className="h-4 w-4" />
                    </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  )
}

function StatCard({ icon: Icon, title, value, desc, className }: any) {
  return (
    <Card className={`border-0 shadow-lg backdrop-blur-md ${className}`}>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium uppercase tracking-wider opacity-70">
          {title}
        </CardTitle>
        <Icon className="h-4 w-4 opacity-70" />
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold">{value}</div>
        <p className="text-xs opacity-70 mt-1">
          {desc}
        </p>
      </CardContent>
    </Card>
  )
}
