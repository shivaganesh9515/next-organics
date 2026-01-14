'use client'

import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'

interface ProductData {
  name: string
  revenue: number
}

interface TopProductsChartProps {
  data: ProductData[]
}

export function TopProductsChart({ data }: TopProductsChartProps) {
  return (
    <div className="h-[300px] w-full">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data} layout="vertical">
          <CartesianGrid strokeDasharray="3 3" stroke="#333" />
          <XAxis 
            type="number"
            stroke="#888"
            fontSize={12}
            tickFormatter={(value) => `₹${value}`}
          />
          <YAxis 
            type="category"
            dataKey="name" 
            stroke="#888"
            fontSize={12}
            width={120}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: '#1a1a1a',
              border: '1px solid #333',
              borderRadius: '8px',
              color: '#fff'
            }}
            formatter={(value: number) => [`₹${value.toFixed(2)}`, 'Revenue']}
          />
          <Bar dataKey="revenue" fill="#3b82f6" radius={[0, 4, 4, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
