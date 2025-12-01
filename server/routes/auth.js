const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Login
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Fetch user from database
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('username', username)
      .eq('is_active', true)
      .single();

    if (error || !user) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { user_id: user.user_id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    // Log activity
    await supabase.from('activity_logs').insert({
      user_id: user.user_id,
      action: 'login',
      details: { username }
    });

    res.json({
      success: true,
      token,
      user: {
        user_id: user.user_id,
        username: user.username,
        full_name: user.full_name,
        role: user.role,
        email: user.email
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});

// Create default admin user (for initial setup)
router.post('/setup', async (req, res) => {
  try {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    
    const { data, error } = await supabase
      .from('users')
      .insert({
        username: 'admin',
        password_hash: hashedPassword,
        role: 'admin',
        full_name: 'System Administrator',
        email: 'admin@pharmacy.com'
      })
      .select()
      .single();

    if (error) {
      return res.status(400).json({ success: false, message: 'Admin already exists or setup failed' });
    }

    res.json({ success: true, message: 'Admin user created successfully' });
  } catch (error) {
    console.error('Setup error:', error);
    res.status(500).json({ success: false, message: 'Setup failed' });
  }
});

module.exports = router;
