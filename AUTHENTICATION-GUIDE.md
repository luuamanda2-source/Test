# 🔐 Authentication & Security Guide

## Overview

Luong's Productivity Hub now includes **authentication and cloud sync** features powered by Supabase. This guide explains how to use these features and understand the security model.

## 🎯 Key Features

### 1. **Dual Mode Operation**
- **Cloud Mode**: Login with your account to sync tasks across devices
- **Local Mode**: Use without login, data stored in browser only

### 2. **Real-time Sync**
- Tasks automatically sync across all your devices
- Changes appear instantly on all logged-in devices
- No manual export/import needed

### 3. **Duplicate Detection**
- Warns you when adding similar tasks
- Checks for same title, deadline, and time
- Prevents accidental duplicates

## 🚀 Getting Started

### Step 1: Create an Account

1. Visit the homepage: `index.html`
2. Click **"🔐 Login / Sign Up"**
3. Click **"Sign Up"** on the login page
4. Fill in:
   - Display Name (your name)
   - Email address
   - Password (at least 6 characters)
   - Confirm password
5. Click **"✨ Create Account"**
6. Check your email for verification (optional, you can still use the app)

### Step 2: Sign In

1. Go to `login.html` or click login from homepage
2. Enter your email and password
3. Click **"🚀 Sign In"**
4. You'll be redirected to the homepage

### Step 3: Use the Apps

Once logged in, all your apps will automatically sync to the cloud:
- **Task Manager**: All tasks sync in real-time
- **Chinese Learning**: Vocabulary syncs across devices
- **Statistics**: Progress tracked in the cloud

## 📱 Using Multiple Devices

### First Device Setup
1. Create account and login
2. Add your tasks/vocabulary
3. Everything saves to cloud automatically

### Additional Devices
1. Open the app on new device
2. Login with same credentials
3. All your data appears automatically
4. Changes sync in real-time

## 🔒 Security Features

### Authentication Protection
- **Login Required for Cloud Sync**: Must be logged in to use cloud features
- **Local Mode Available**: Can still use apps without login (local storage only)
- **Session Management**: Stays logged in until you logout
- **Secure Passwords**: Minimum 6 characters required

### Data Privacy
- **User Isolation**: You can only see your own data
- **Row Level Security (RLS)**: Database enforces user permissions
- **Encrypted Connections**: All data transmitted over HTTPS
- **No Data Sharing**: Your data is private and not shared

## 🛠️ Database Setup (For Developers)

### Initial Setup

1. **Create Supabase Project**
   - Go to [supabase.com](https://supabase.com)
   - Create new project
   - Note your project URL and anon key

2. **Update Configuration**
   - Edit `supabase-config.js`
   - Replace `SUPABASE_URL` with your project URL
   - Replace `SUPABASE_ANON_KEY` with your anon key

3. **Run Database Migration**
   - Open Supabase SQL Editor
   - Run `supabase-migration-update-task-id.sql`
   - This creates all necessary tables and security policies

### Schema Overview

The database includes:
- **user_profiles**: User information
- **tasks**: Task management data
- **chinese_vocabulary**: Learning app data
- **learning_sessions**: Progress tracking
- **user_statistics**: Aggregated stats
- **app_settings**: User preferences

## 🔄 Migration from Local to Cloud

### Automatic Migration
When you first login, the app will:
1. Load your local tasks from browser storage
2. Upload them to Supabase cloud
3. Keep local backup for safety

### Manual Migration
Use the **"Migrate to Cloud"** tool:
1. Click "Migrate to Cloud" from homepage
2. Review your local tasks
3. Click "Upload to Supabase"
4. Confirm migration successful

## ⚠️ Important Notes

### Local Mode Limitations
- Data only in browser (can be lost if browser data cleared)
- No sync across devices
- No backup in cloud
- Must manually export/import

### Cloud Mode Benefits
- ✅ Automatic sync across devices
- ✅ Cloud backup
- ✅ Real-time updates
- ✅ Access from anywhere
- ✅ Never lose data

## 🆘 Troubleshooting

### "Not logged in" Warning
**Problem**: Yellow warning banner appears
**Solution**: Click "Login" link or continue in local mode

### Tasks Not Syncing
**Problem**: Changes don't appear on other devices
**Solution**: 
1. Check you're logged in (see auth status)
2. Refresh the page
3. Check internet connection
4. Logout and login again

### Duplicate Task Warning
**Problem**: Warning appears when adding task
**Solution**: 
- Review the existing task shown
- Click "Cancel" to not add duplicate
- Click "OK" to add anyway

### Can't Login
**Problem**: Login fails
**Solution**:
1. Check email and password are correct
2. Verify email if you just signed up
3. Try "Forgot Password" (if implemented)
4. Create new account if needed

### Lost Password
**Problem**: Forgot password
**Solution**: 
1. Use Supabase password reset (if configured)
2. Or create new account with different email
3. Contact admin for help

## 🎓 Best Practices

### Security
1. **Use Strong Password**: At least 8 characters with mix of letters/numbers
2. **Don't Share Credentials**: Keep your login private
3. **Logout on Shared Devices**: Always logout on public computers
4. **Regular Backups**: Still export tasks occasionally as backup

### Data Management
1. **Regular Cleanup**: Delete completed tasks periodically
2. **Check Duplicates**: Review duplicate warnings carefully
3. **Verify Sync**: Check tasks appear on all devices
4. **Export Backup**: Monthly export as safety backup

## 📊 Feature Comparison

| Feature | Local Mode | Cloud Mode |
|---------|-----------|------------|
| No Login Required | ✅ | ❌ |
| Works Offline | ✅ | ⚠️ (cached) |
| Sync Across Devices | ❌ | ✅ |
| Cloud Backup | ❌ | ✅ |
| Real-time Updates | ❌ | ✅ |
| Data Persistence | ⚠️ Browser only | ✅ Permanent |
| Duplicate Detection | ✅ | ✅ |
| Export/Import | ✅ Manual | ✅ Automatic |

## 🔮 Future Enhancements

Planned features:
- [ ] Password reset functionality
- [ ] Email verification requirement
- [ ] Two-factor authentication
- [ ] Shared task lists
- [ ] Team collaboration
- [ ] Advanced permissions
- [ ] Activity logs
- [ ] Data export automation

## 📞 Support

If you encounter issues:
1. Check this guide first
2. Review console logs (F12 in browser)
3. Check Supabase dashboard for errors
4. Create GitHub issue with details
5. Contact: [Your contact info]

## 🎉 Conclusion

You now have a secure, cloud-synced productivity hub! Enjoy seamless access to your tasks and learning progress from any device.

**Happy Productivity! 🚀**

