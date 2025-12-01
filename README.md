# 🏥 Pharmacy Management System

Complete Enterprise Pharmacy Software - Retail + Wholesale with GST Compliance

## 🚀 Features

### Core Modules
- ✅ Multi-tier Billing (Retail/Wholesale/Distributor)
- ✅ Inventory Management with Batch & Expiry tracking
- ✅ Multi-user System (Admin/Staff roles)
- ✅ GST Compliance (0%, 5%, 18%)
- ✅ AI Chatbot for customer support
- ✅ Offline billing capability
- ✅ Barcode scanner support
- ✅ Thermal printer integration

### Customer Management
- Customer classification (Retail/Wholesale/Distributor)
- Credit limit management
- Payment terms (Cash/Credit)
- GSTIN validation for B2B
- Customer purchase history

### Reports & Analytics
**Sales Reports:**
- Datewise sales
- Sales/Stock (Companywise)
- Invoice tracking
- Analysis (Sales)

**Financial Reports:**
- Account Receivables (Overall/Salesmanwise/Deliverymanwise)
- Account Payables
- Bank Statements
- Invoice Cuts (Cn/Dn)

**Advanced Analytics:**
- Party Analysis
- Product Analysis
- Salesman Analysis
- Deliveryman Analysis
- Doctor Analysis
- Patient Analysis
- City Analysis
- Area Analysis
- Toppers Analysis

**Other Reports:**
- Physical Verifications
- Scheme/Discount Reports
- Misc Reports
- TB Reports
- Administrative/Analytical Reports

### Inventory Features
- MRP tracking
- Batch number management
- Expiry date monitoring
- Product images
- Stock verification
- Low stock alerts
- Stock allocation (Retail/Wholesale)

### Discount & Schemes
- Bulk discount rules
- Scheme management
- MOQ (Minimum Order Quantity)
- Promotional offers

## 🛠️ Tech Stack

**Frontend:** React + Next.js
**Backend:** Node.js + Express
**Database:** Supabase (PostgreSQL)
**Authentication:** Supabase Auth
**Deployment:** Vercel (Frontend) + Railway/Render (Backend)
**AI:** OpenRouter/Gemini for chatbot

## 📦 Installation

```bash
# Clone repository
git clone https://github.com/vivekbhikadia/pharmacy-management-system.git
cd pharmacy-management-system

# Install dependencies
npm install

# Setup environment variables
cp .env.example .env.local

# Run development server
npm run dev
```

## 🔐 User Roles

### Admin Access
- Full system control
- Inventory management
- Pricing control
- User management
- Financial reports
- GST settings
- System configuration

### Staff Access
- Billing (Retail + Wholesale)
- Customer registration
- Stock inquiry (view only)
- Order processing
- Daily sales report (own sales)

## 📊 Database Schema

See `database/schema.sql` for complete database structure.

## 🚀 Deployment

### Frontend (Vercel)
```bash
vercel deploy
```

### Backend (Railway)
```bash
railway up
```

## 📝 License

MIT License

## 👨‍💻 Developer

Built with ❤️ by Vivek Bhikadia

## 🤝 Contributing

Contributions welcome! Please read CONTRIBUTING.md first.

## 📞 Support

For support, email vivekbhikadia@gmail.com
