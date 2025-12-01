const express = require('express');
const router = express.Router();
const { createClient } = require('@supabase/supabase-js');
const { authenticateToken } = require('../middleware/auth');

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Get dashboard statistics
router.get('/stats', authenticateToken, async (req, res) => {
  try {
    const today = new Date().toISOString().split('T')[0];

    // Today's sales
    const { data: todaySales } = await supabase
      .from('sales_orders')
      .select('total_amount')
      .gte('order_date', today);

    const todaySalesTotal = todaySales?.reduce((sum, order) => sum + parseFloat(order.total_amount), 0) || 0;

    // Total orders today
    const { count: totalOrders } = await supabase
      .from('sales_orders')
      .select('*', { count: 'exact', head: true })
      .gte('order_date', today);

    // Low stock items
    const { data: lowStock } = await supabase
      .rpc('get_low_stock_count');

    // Expiring soon (next 90 days)
    const { count: expiringSoon } = await supabase
      .from('inventory')
      .select('*', { count: 'exact', head: true })
      .lte('expiry_date', new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString())
      .gt('quantity', 0);

    // Outstanding amount
    const { data: customers } = await supabase
      .from('customers')
      .select('outstanding_amount');

    const outstanding = customers?.reduce((sum, c) => sum + parseFloat(c.outstanding_amount), 0) || 0;

    res.json({
      success: true,
      stats: {
        todaySales: todaySalesTotal,
        totalOrders: totalOrders || 0,
        lowStock: lowStock || 0,
        expiringSoon: expiringSoon || 0,
        outstanding: outstanding
      }
    });
  } catch (error) {
    console.error('Dashboard stats error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch stats' });
  }
});

module.exports = router;
