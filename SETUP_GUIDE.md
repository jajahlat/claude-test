# 🔧 Faydabook Setup Guide

This guide will help you set up Faydabook from scratch.

## Prerequisites Checklist

- [ ] Flutter SDK 3.0+ installed
- [ ] Android Studio installed (for Android)
- [ ] Xcode installed (for iOS - macOS only)
- [ ] Firebase account created
- [ ] Git installed
- [ ] Code editor (VS Code recommended)

## Step-by-Step Setup

### 1. Install Flutter

#### macOS
```bash
# Using Homebrew
brew install --cask flutter

# Or download from flutter.dev
```

#### Windows
1. Download Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to C:\src\flutter
3. Add to PATH: C:\src\flutter\bin

#### Linux
```bash
sudo snap install flutter --classic
```

Verify installation:
```bash
flutter doctor
```

### 2. Clone the Repository

```bash
git clone https://github.com/yourusername/faydabook.git
cd faydabook
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Firebase Setup (Detailed)

#### A. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name: "Faydabook"
4. Disable Google Analytics (optional)
5. Click "Create project"

#### B. Enable Firebase Services

**Firestore Database:**
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Start in "Test mode" (we'll add security rules later)
4. Choose a location (closest to your users)
5. Click "Enable"

**Authentication:**
1. Go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password"

**Storage:**
1. Go to "Storage"
2. Click "Get started"
3. Start in "Test mode"
4. Click "Done"

#### C. Configure Android App

1. In Firebase Console, click "Add app" → Android icon
2. Android package name: `com.faydabook.app`
3. App nickname: Faydabook
4. Download `google-services.json`
5. Place file in: `android/app/google-services.json`

#### D. Configure iOS App

1. In Firebase Console, click "Add app" → iOS icon
2. iOS bundle ID: `com.faydabook.app`
3. App nickname: Faydabook
4. Download `GoogleService-Info.plist`
5. Place file in: `ios/Runner/GoogleService-Info.plist`

### 5. Setup Firestore Collections

Create these collections in Firestore:

#### books Collection
```
books/
  └── [auto-generated-id]/
      ├── id: string
      ├── title: string
      ├── author: string
      ├── description: string
      ├── coverImageUrl: string
      ├── fileUrl: string
      ├── type: string ("epub" or "pdf")
      ├── language: string ("ar", "en", "fr")
      ├── categories: array
      ├── publishedDate: timestamp
      ├── totalPages: number
      ├── audioBookId: string (optional)
      ├── isFavorite: boolean
      └── addedDate: timestamp
```

#### audiobooks Collection
```
audiobooks/
  └── [auto-generated-id]/
      ├── id: string
      ├── bookId: string
      ├── title: string
      ├── narrator: string
      ├── coverImageUrl: string
      ├── chapters: array
      ├── totalDuration: number
      ├── language: string
      └── addedDate: timestamp
```

#### daily_quotes Collection
```
daily_quotes/
  └── [auto-generated-id]/
      ├── text:
      │   ├── ar: string
      │   ├── en: string
      │   └── fr: string
      ├── source: string
      └── addedDate: timestamp
```

### 6. Add Sample Data

Use Firebase Console or admin panel to add:

**Sample Book:**
```json
{
  "id": "kashf_al_ilbas_001",
  "title": "Kashf al-Ilbas",
  "author": "Shaykh Ibrahim Niass",
  "description": "A profound commentary on the removal of confusion in the spiritual sciences.",
  "coverImageUrl": "https://example.com/cover.jpg",
  "fileUrl": "https://example.com/book.epub",
  "type": "epub",
  "language": "ar",
  "categories": ["Tafsir", "Teachings"],
  "publishedDate": "2024-01-01T00:00:00.000Z",
  "totalPages": 350,
  "isFavorite": false,
  "addedDate": "2024-01-01T00:00:00.000Z"
}
```

### 7. Run the App

#### On Android Emulator
```bash
# Start Android emulator
# Then run:
flutter run
```

#### On iOS Simulator
```bash
# Start iOS simulator
open -a Simulator

# Then run:
flutter run
```

#### On Physical Device
```bash
# Connect device via USB
# Enable Developer Mode and USB Debugging

# Check connected devices
flutter devices

# Run on specific device
flutter run -d [device-id]
```

### 8. Setup Admin Panel

#### A. Configure Firebase in Admin Panel

1. Edit `admin_panel/app.js`
2. Replace Firebase config with your project's config:

```javascript
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};
```

Find these values in Firebase Console → Project Settings

#### B. Deploy Admin Panel

**Option 1: Firebase Hosting**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
cd admin_panel
firebase init hosting

# Select your project
# Public directory: . (current directory)
# Single-page app: No

# Deploy
firebase deploy --only hosting
```

**Option 2: Local Testing**
```bash
cd admin_panel
python -m http.server 8000
# Visit http://localhost:8000
```

### 9. Configure Security Rules

#### Firestore Rules
Go to Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /books/{bookId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    match /audiobooks/{audiobookId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    match /daily_quotes/{quoteId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

#### Storage Rules
Go to Storage → Rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 10. Testing Checklist

Test these features:

- [ ] App launches successfully
- [ ] Books load from Firebase
- [ ] Can open and read EPUB books
- [ ] Can open and read PDF books
- [ ] Audiobooks play correctly
- [ ] Progress is saved
- [ ] Bookmarks work
- [ ] Search functionality works
- [ ] Theme switching works
- [ ] Admin panel loads
- [ ] Can upload books via admin panel

### 11. Common Issues & Solutions

#### Issue: Firebase not connecting
**Solution:**
- Check `google-services.json` is in `android/app/`
- Check `GoogleService-Info.plist` is in `ios/Runner/`
- Verify package names match Firebase config

#### Issue: Build errors
**Solution:**
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

#### Issue: EPUB not opening
**Solution:**
- Verify EPUB file is valid
- Check file URL is accessible
- Ensure internet permission is granted

#### Issue: Audio not playing
**Solution:**
- Check audio file format (MP3 recommended)
- Verify audio URL is accessible
- Check device volume

### 12. Optional: Add Custom Fonts

1. Download fonts:
   - Amiri: [Google Fonts](https://fonts.google.com/specimen/Amiri)
   - Lora: [Google Fonts](https://fonts.google.com/specimen/Lora)

2. Place in `assets/fonts/`

3. Update `pubspec.yaml`:
```yaml
fonts:
  - family: Amiri
    fonts:
      - asset: assets/fonts/Amiri-Regular.ttf
      - asset: assets/fonts/Amiri-Bold.ttf
        weight: 700
```

### 13. Environment Variables (Optional)

Create `.env` file for sensitive data:

```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
ADMIN_EMAIL=admin@faydabook.app
```

Add to `.gitignore`:
```
.env
```

## Next Steps

After setup:

1. Add sample books and audiobooks
2. Test all features thoroughly
3. Customize theme colors
4. Add app icon and splash screen
5. Prepare for deployment

## Support

If you encounter issues:
1. Check the main README.md
2. Search GitHub Issues
3. Contact support@faydabook.app

---

**Setup complete!** 🎉 You're ready to start using Faydabook.
