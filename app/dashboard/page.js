'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import axios from 'axios';

export default function Dashboard() {
  const router = useRouter();
  const [user, setUser] = useState(null);
  const [stats, setStats] = useState({
    todaySales: 0,
    totalOrders: 0,
    lowStock: 0,
    expiringSoon: 0,
    outstanding: 0
  });

  useEffect(() => {
    const userData = localStorage.getItem('user');
    if (!userData) {
      router.push('/login');
      return;
    }
    setUser(JSON.parse(userData));
    fetchDashboardStats();
  }, []);

  const fetchDashboardStats = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get(`${process.env.NEXT_PUBLIC_API_URL}/api/dashboard/stats`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setStats(response.data.stats);
    } catch (error) {
      console.error('Error fetching stats:', error);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    router.push('/login');
  };

  const menuItems = [
    { name: 'Billing', icon: '💳', path: '/billing', roles: ['admin', 'staff'] },
    { name: 'Inventory', icon: '📦', path: '/inventory', roles: ['admin', 'staff'] },
    { name: 'Customers', icon: '👥', path: '/customers', roles: ['admin', 'staff'] },
    { name: 'Reports', icon: '📊', path: '/reports', roles: ['admin'] },
    { name: 'Analytics', icon: '📈', path: '/analytics', roles: ['admin'] },
    { name: 'Users', icon: '👤', path: '/users', roles: ['admin'] },
    { name: 'Settings', icon: '⚙️', path: '/settings', roles: ['admin'] },
  ];

  if (!user) return null;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-800">🏥 Pharmacy System</h1>
            <p className="text-sm text-gray-600">Welcome, {user.full_name} ({user.role})</p>
          </div>
          <button
            onClick={handleLogout}
            className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
          >
            Logout
          </button>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-5 gap-6 mb-8">
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <p className="text-gray-600 text-sm">Today's Sales</p>
            <p className="text-2xl font-bold text-green-600">₹{stats.todaySales.toLocaleString()}</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <p className="text-gray-600 text-sm">Total Orders</p>
            <p className="text-2xl font-bold text-blue-600">{stats.totalOrders}</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <p className="text-gray-600 text-sm">Low Stock</p>
            <p className="text-2xl font-bold text-orange-600">{stats.lowStock}</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <p className="text-gray-600 text-sm">Expiring Soon</p>
            <p className="text-2xl font-bold text-red-600">{stats.expiringSoon}</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <p className="text-gray-600 text-sm">Outstanding</p>
            <p className="text-2xl font-bold text-purple-600">₹{stats.outstanding.toLocaleString()}</p>
          </div>
        </div>

        {/* Menu Grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          {menuItems
            .filter(item => item.roles.includes(user.role))
            .map((item) => (
              <button
                key={item.name}
                onClick={() => router.push(item.path)}
                className="bg-white p-8 rounded-xl shadow-sm hover:shadow-md transition text-center"
              >
                <div className="text-4xl mb-3">{item.icon}</div>
                <p className="font-semibold text-gray-800">{item.name}</p>
              </button>
            ))}
        </div>
      </div>
    </div>
  );
}
