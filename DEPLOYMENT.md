# 🚀 Deployment Guide

## Prerequisites
- Supabase account
- Vercel account (for frontend)
- Railway/Render account (for backend)

## Step 1: Database Setup (Supabase)

1. Create a new Supabase project
2. Run the SQL schema from `database/schema.sql`
3. Copy your Supabase URL and keys

## Step 2: Environment Variables

Create `.env.local` file with:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
JWT_SECRET=your_random_secret_key
NEXT_PUBLIC_API_URL=your_backend_url
```

## Step 3: Deploy Backend (Railway)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Deploy
railway up
```

Set environment variables in Railway dashboard:
- `NEXT_PUBLIC_SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `JWT_SECRET`
- `PORT=3001`

## Step 4: Deploy Frontend (Vercel)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel

# Set environment variables in Vercel dashboard
```

## Step 5: Initial Setup

1. Visit your deployed backend URL: `https://your-backend.railway.app/api/auth/setup`
2. This creates the default admin user
3. Login with: `admin / admin123`
4. Change password immediately

## Step 6: Configure Features

### Barcode Scanner
- Connect USB barcode scanner
- Configure in Settings > Hardware

### Thermal Printer
- Set printer IP in environment variables
- Test print from Settings > Printers

### AI Chatbot
- Add OpenRouter or Gemini API key
- Configure in Settings > AI

## Production Checklist

- [ ] Change default admin password
- [ ] Set up SSL certificates
- [ ] Configure backup schedule
- [ ] Set up monitoring
- [ ] Test all features
- [ ] Train staff users
- [ ] Import existing inventory
- [ ] Configure GST settings

## Support

For issues, contact: vivekbhikadia@gmail.com
