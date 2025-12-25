'use client'

import { useState } from 'react'
import { Filter, Eye, Clock, Truck, CheckCircle2 } from 'lucide-react'
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"

const INITIAL_ORDERS = [
  { id: '#ORD-7721', customer: 'Rahul Sharma', items: 3, total: '₹450', status: 'New', time: '10:30 AM' },
  { id: '#ORD-7720', customer: 'Priya Singh', items: 12, total: '₹1,240', status: 'Preparing', time: '09:45 AM' },
  { id: '#ORD-7719', customer: 'Amit Kumar', items: 5, total: '₹890', status: 'Ready', time: '09:15 AM' },
  { id: '#ORD-7718', customer: 'Sneha Gupta', items: 2, total: '₹120', status: 'Delivered', time: 'Yesterday' },
]

export default function OrdersPage() {
  const [filter, setFilter] = useState('All')
  const [orders] = useState(INITIAL_ORDERS)

  return (
    <div className="max-w-6xl mx-auto space-y-8 animate-in slide-in-from-bottom-4 duration-500">
      
       {/* Header */}
       <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Orders</h1>
          <p className="text-muted-foreground mt-1">Process and manage incoming requests.</p>
        </div>
        <Button variant="outline" className="gap-2">
            <Filter className="w-4 h-4" /> Filter
        </Button>
      </div>

       {/* Filter Tabs */}
       <div className="flex gap-2 mb-6 overflow-x-auto pb-2 noscroll">
         {['All', 'New', 'Preparing', 'Ready', 'Delivered'].map(status => (
            <Button
                key={status}
                onClick={() => setFilter(status)}
                variant={filter === status ? "default" : "secondary"}
                className={`rounded-full px-6 transition-all ${filter === status ? 'shadow-lg shadow-primary/20' : ''}`}
            >
                {status}
            </Button>
         ))}
       </div>

       {/* Orders List */}
       <div className="space-y-4">
        {orders.map((order) => (
            <Card key={order.id} className="p-6 flex flex-col md:flex-row items-start md:items-center justify-between gap-6 group hover:border-primary/50 transition-all cursor-pointer backdrop-blur-md bg-white/5 border-white/10">
                
                {/* ID & Time */}
                <div className="min-w-[140px]">
                    <div className="flex items-center gap-3 mb-1">
                        <span className="font-mono font-bold text-lg">{order.id}</span>
                    </div>
                    <div className="flex items-center gap-2 text-xs text-muted-foreground">
                        <Clock className="w-3 h-3" />
                        {order.time}
                    </div>
                </div>

                {/* Status */}
                <div className="min-w-[100px]">
                    <StatusBadge status={order.status} />
                </div>

                {/* Customer Info */}
                <div className="flex-1">
                    <p className="font-semibold text-lg">{order.customer}</p>
                    <p className="text-sm text-muted-foreground">{order.items} items • <span className="text-foreground font-bold">{order.total}</span></p>
                </div>

                {/* Actions */}
                <div className="flex items-center gap-3">
                    <Button variant="ghost" size="icon" className="rounded-full hover:bg-white/10">
                        <Eye className="w-5 h-5" />
                    </Button>
                    <Button className="shadow-lg shadow-primary/20 font-bold">
                        Accept Order
                    </Button>
                </div>

            </Card>
        ))}
       </div>

    </div>
  )
}

function StatusBadge({ status }: { status: string }) {
    if (status === 'New') return <Badge className="bg-blue-500/10 text-blue-400 border-blue-500/20 hover:bg-blue-500/20 animate-pulse">New Order</Badge>
    if (status === 'Preparing') return <Badge className="bg-orange-500/10 text-orange-400 border-orange-500/20 hover:bg-orange-500/20">Preparing</Badge>
    if (status === 'Ready') return <Badge className="bg-yellow-500/10 text-yellow-400 border-yellow-500/20 hover:bg-yellow-500/20">Ready</Badge>
    if (status === 'Delivered') return <Badge className="bg-green-500/10 text-green-400 border-green-500/20 hover:bg-green-500/20">Delivered</Badge>
    return <Badge variant="outline">{status}</Badge>
}
