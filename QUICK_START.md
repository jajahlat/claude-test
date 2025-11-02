# 🚀 Faydabook - Quick Start Guide

Welcome to Faydabook! This guide will get you up and running in 10 minutes.

## What You Just Got

✅ **Complete Flutter Mobile App** (Android + iOS)
- Native EPUB/PDF reader
- Audiobook player
- Beautiful Sufi-inspired UI
- Firebase backend integration
- SQLite local storage

✅ **Web Admin Panel**
- Upload books and audiobooks
- Manage daily quotes
- Firebase integration

✅ **Comprehensive Documentation**
- README.md - Full project overview
- SETUP_GUIDE.md - Detailed setup instructions
- CONTRIBUTING.md - Contribution guidelines

## 5-Minute Quick Start

### 1. Prerequisites Check

Make sure you have:
```bash
flutter --version  # Should be 3.0+
git --version
```

### 2. Install Dependencies

```bash
cd faydabook
flutter pub get
```

### 3. Firebase Setup (Simplified)

**Get Firebase Config:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create project "Faydabook"
3. Add Android app → Download `google-services.json` → Place in `android/app/`
4. Add iOS app → Download `GoogleService-Info.plist` → Place in `ios/Runner/`
5. Enable Firestore, Storage, and Authentication

### 4. Run the App

```bash
# Android
flutter run

# iOS (macOS only)
flutter run -d ios
```

## Project Structure Overview

```
faydabook/
├── lib/
│   ├── main.dart              # App entry point
│   ├── config/                # Theme & configuration
│   ├── models/                # Data models (Book, User, etc.)
│   ├── providers/             # State management
│   ├── screens/               # All app screens
│   ├── services/              # Database & Firebase
│   └── widgets/               # Reusable components
├── admin_panel/               # Web admin interface
├── android/                   # Android config
├── ios/                       # iOS config
└── assets/                    # Images, fonts, etc.
```

## Key Features Implemented

### 📖 Ebook Reader
- File: `lib/screens/book_reader_screen.dart`
- Features: EPUB/PDF, bookmarks, highlights, progress tracking

### 🎧 Audio Player
- File: `lib/screens/audio_player_screen.dart`
- Features: Play/pause, speed control, chapter navigation

### 🏠 Home Screen
- File: `lib/screens/home_screen.dart`
- Shows: Continue reading, continue listening, recently added

### 📚 Library
- File: `lib/screens/library_screen.dart`
- Features: Filter by language, category, favorites

### 🎨 Theme
- File: `lib/config/app_theme.dart`
- Colors: Sufi-inspired green, gold, teal palette

## Next Steps

### 1. Customize Branding

**Change App Name:**
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

**Change Colors:**
```dart
// lib/config/app_theme.dart
static const Color primaryGreen = Color(0xFF2D5F3F);
static const Color primaryGold = Color(0xFFD4AF37);
```

### 2. Add Content

**Using Admin Panel:**
1. Configure Firebase in `admin_panel/app.js`
2. Deploy to Firebase Hosting or run locally
3. Upload books, audiobooks, and quotes

**Sample Book Data:**
```json
{
  "title": "Kashf al-Ilbas",
  "author": "Shaykh Ibrahim Niass",
  "language": "ar",
  "type": "epub",
  "categories": ["Tafsir", "Teachings"]
}
```

### 3. Test Features

- [ ] Open a book (EPUB/PDF)
- [ ] Play an audiobook
- [ ] Add bookmark
- [ ] Create highlight
- [ ] Toggle dark mode
- [ ] Check progress tracking

### 4. Deploy

**Android:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**iOS:**
```bash
flutter build ios --release
# Then use Xcode to archive
```

## Common Tasks

### Run on Specific Device
```bash
flutter devices                    # List devices
flutter run -d <device-id>        # Run on specific device
```

### Clean Build
```bash
flutter clean
flutter pub get
flutter run
```

### View Logs
```bash
flutter logs
```

### Hot Reload
Press `r` in terminal while app is running

## File Locations

**Add Books Manually:**
- `assets/books/` - Place EPUB/PDF files here
- Update in Firebase or SQLite

**Add Fonts:**
- `assets/fonts/` - Place TTF files here
- Update `pubspec.yaml`

**Add Images:**
- `assets/images/` - Place images here
- Use in code: `Image.asset('assets/images/logo.png')`

## Admin Panel Quick Access

```bash
cd admin_panel
python -m http.server 8000
# Open: http://localhost:8000
```

## Troubleshooting

**Can't build?**
```bash
flutter doctor
flutter clean
flutter pub get
```

**Firebase not connecting?**
- Check `google-services.json` and `GoogleService-Info.plist` are in correct locations
- Verify package names match Firebase config

**EPUB not opening?**
- Ensure file is valid EPUB format
- Check file URL is accessible

## What's Included

### Mobile App Features
✅ EPUB/PDF reader with customization
✅ Audiobook player with advanced controls
✅ Progress tracking and sync
✅ Bookmarks and highlights
✅ Dark/Light theme
✅ Multilingual support (AR, EN, FR)
✅ Search functionality
✅ Categories and filters
✅ User profiles
✅ Daily quotes

### Admin Panel Features
✅ Book management (upload, edit, delete)
✅ Audiobook management
✅ Daily quotes management
✅ Firebase integration
✅ Responsive design

### Documentation
✅ README.md - Complete overview
✅ SETUP_GUIDE.md - Detailed setup
✅ CONTRIBUTING.md - Contribution guide
✅ This QUICK_START.md

## Resources

- **Full Documentation**: See README.md
- **Detailed Setup**: See SETUP_GUIDE.md
- **Contributing**: See CONTRIBUTING.md
- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.google.com/docs

## Support

Need help?
- Check the documentation files
- Email: support@faydabook.app
- Create an issue on GitHub

## What's Next?

1. **Add Sample Content** - Upload some books to test
2. **Customize Theme** - Match your branding
3. **Test All Features** - Ensure everything works
4. **Deploy to Stores** - Publish on Google Play & App Store
5. **Gather Feedback** - From users
6. **Iterate** - Improve based on feedback

---

**You're all set!** 🎉

The complete Faydabook app is ready for development, testing, and deployment.

**JazakAllahu Khairan** (May Allah reward you with goodness) for spreading Islamic knowledge! 🌙

---

**Made with ❤️ for the Ummah**
