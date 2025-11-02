# 📚 Faydabook - Islamic Ebook & Audiobook App

![Faydabook](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)

**Faydabook** is a mobile application dedicated to the works and teachings of **Shaykh Ibrahim Niass (radiyallahu anhu)** — a renowned 20th-century Sufi master. The app provides an elegant platform for reading and listening to Islamic spiritual literature with native EPUB/PDF reader and advanced audiobook features.

## ✨ Features

### 📖 Ebook Reader
- **Native EPUB & PDF Support** - Read books directly in the app without external viewers
- **Arabic & English Text** - Full right-to-left (RTL) layout compatibility
- **Customizable Reading Experience**
  - Adjustable font size, style, and background color
  - Light/Dark/Night reading modes
  - Line height and text alignment options
- **Reading Tools**
  - Bookmarks with notes
  - Text highlighting with color options
  - In-book search functionality
  - Table of contents navigation
  - Reading progress tracking

### 🎧 Audiobook Player
- **High-Quality Audio Playback** - Built on JustAudio engine
- **Advanced Controls**
  - Play/Pause, skip forward/backward 15 seconds
  - Chapter navigation
  - Playback speed control (0.5x - 2x)
  - Sleep timer
  - Background playback
- **Progress Sync** - Sync reading position between ebook and audiobook

### 📚 Library System
- **Pre-loaded Collection** - Curated works by Shaykh Ibrahim Niass
  - Kashf al-Ilbas
  - Ruh al-Adab
  - Tariq al-Jannah
  - And more...
- **Smart Categorization**
  - By Language (Arabic, French, English)
  - By Theme (Tafsir, Poetry, Teachings, Letters)
- **Search & Filter** - Easily find books by title, author, or category

### 🎨 Sufi-Inspired Design
- **Minimalist Calligraphic Branding** - Elegant and spiritual aesthetic
- **Custom Typography**
  - Arabic: Amiri font family
  - English: Lora font family
- **Calm Color Palette**
  - Deep green (#2D5F3F)
  - Islamic gold (#D4AF37)
  - Calm teal (#4A7C7E)
  - Warm cream (#F5F1E8)

### 👤 User Features
- **Continue Reading/Listening** - Pick up where you left off
- **Favorites** - Save your preferred books
- **Reading History** - Track your spiritual journey
- **Share Excerpts** - Share wisdom with proper citations
- **Daily Quotes** - Optional notifications with teachings from Shaykh Ibrahim Niass

### 🌙 Additional Features
- **Tasbeeh Counter** - Digital dhikr counter
- **Zikr Reminders** - Inspired by Fayda Tijaniyya practices
- **Text-to-Speech** - For books without recorded audio
- **Multilingual UI** - Arabic, English, French

## 🛠️ Tech Stack

### Mobile App
- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Database**: SQLite (local) + Firebase Firestore (cloud)
- **Storage**: Firebase Storage
- **Ebook Engine**: vocsy_epub_viewer, flutter_pdfview
- **Audio Engine**: just_audio, audio_session
- **Authentication**: Firebase Auth

### Backend
- **Firebase Firestore** - Real-time database
- **Firebase Storage** - File storage (books, audio, covers)
- **Firebase Cloud Functions** - Serverless functions (optional)

### Admin Panel
- **Framework**: Vanilla JavaScript, HTML5, CSS3
- **Deployment**: Can be hosted on any static hosting (Firebase Hosting, Netlify, Vercel)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0 or higher): [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Firebase Account**: [Create Firebase Project](https://console.firebase.google.com/)
- **Git**: [Install Git](https://git-scm.com/downloads)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/faydabook.git
cd faydabook
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "Faydabook"
3. Enable the following services:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
   - Cloud Functions (optional)

#### Android Configuration
1. In Firebase Console, add an Android app
2. Download `google-services.json`
3. Place it in `android/app/`
4. Package name: `com.faydabook.app`

#### iOS Configuration
1. In Firebase Console, add an iOS app
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/`
4. Bundle ID: `com.faydabook.app`

### 4. Configure Firestore Rules

Go to Firestore Database → Rules and set:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Books - Read for all, write for admin only
    match /books/{bookId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    // Audiobooks - Read for all, write for admin only
    match /audiobooks/{audiobookId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    // Daily Quotes - Read for all
    match /daily_quotes/{quoteId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

### 5. Configure Storage Rules

Go to Storage → Rules and set:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Books and covers - Read for all
    match /books/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    match /audio/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    match /covers/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

### 6. Run the App

#### Android
```bash
flutter run -d android
```

#### iOS
```bash
flutter run -d ios
```

## 📱 Building for Production

### Android APK/AAB

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

The output will be in:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### iOS IPA

```bash
flutter build ios --release
```

Then use Xcode to archive and distribute.

## 🎛️ Admin Panel Setup

The admin panel is a web interface for managing books, audiobooks, and daily quotes.

### 1. Navigate to Admin Panel

```bash
cd admin_panel
```

### 2. Configure Firebase

Edit `app.js` and replace the Firebase configuration:

```javascript
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};
```

### 3. Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase Hosting
firebase init hosting

# Deploy
firebase deploy --only hosting
```

### 4. Access Admin Panel

Visit: `https://your-project-id.web.app`

## 📖 Adding Books & Audiobooks

### Using Admin Panel

1. Open the admin panel in your browser
2. Navigate to the "Books" or "Audiobooks" tab
3. Click "+ Add New Book/Audiobook"
4. Fill in the required information:
   - Title, Author, Description
   - Language, Type/Category
   - Upload cover image
   - Upload book file (EPUB/PDF) or audio files
5. Click "Save"

### Manual Firebase Upload

You can also manually add books to Firestore:

```javascript
// Add to Firestore 'books' collection
{
  "id": "unique_id",
  "title": "Kashf al-Ilbas",
  "author": "Shaykh Ibrahim Niass",
  "description": "A profound commentary on the spiritual sciences...",
  "coverImageUrl": "https://storage.googleapis.com/...",
  "fileUrl": "https://storage.googleapis.com/...",
  "type": "epub",
  "language": "ar",
  "categories": ["Tafsir", "Teachings"],
  "publishedDate": "2024-01-01T00:00:00.000Z",
  "totalPages": 350,
  "audioBookId": "optional_audiobook_id",
  "isFavorite": false,
  "addedDate": "2024-01-01T00:00:00.000Z"
}
```

## 📁 Project Structure

```
faydabook/
├── lib/
│   ├── config/
│   │   └── app_theme.dart          # App theme and colors
│   ├── models/
│   │   ├── book.dart               # Book data model
│   │   ├── audiobook.dart          # Audiobook data model
│   │   ├── user.dart               # User data model
│   │   ├── reading_progress.dart   # Reading progress model
│   │   └── audio_progress.dart     # Audio progress model
│   ├── providers/
│   │   ├── book_provider.dart      # Book state management
│   │   ├── audio_provider.dart     # Audio state management
│   │   ├── user_provider.dart      # User state management
│   │   └── theme_provider.dart     # Theme state management
│   ├── screens/
│   │   ├── splash_screen.dart      # Splash screen
│   │   ├── main_screen.dart        # Main navigation
│   │   ├── home_screen.dart        # Home screen
│   │   ├── library_screen.dart     # Books library
│   │   ├── audio_library_screen.dart # Audiobooks library
│   │   ├── profile_screen.dart     # User profile
│   │   ├── book_reader_screen.dart # Ebook reader
│   │   ├── audio_player_screen.dart # Audio player
│   │   └── settings_screen.dart    # Settings
│   ├── services/
│   │   ├── database_service.dart   # SQLite database
│   │   └── firebase_service.dart   # Firebase integration
│   ├── widgets/
│   │   ├── book_card.dart          # Book card widget
│   │   ├── audiobook_card.dart     # Audiobook card widget
│   │   └── section_header.dart     # Section header widget
│   └── main.dart                   # App entry point
├── android/                        # Android configuration
├── ios/                            # iOS configuration
├── assets/                         # Static assets
│   ├── images/
│   ├── books/
│   ├── audio/
│   └── fonts/
├── admin_panel/                    # Web admin interface
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── pubspec.yaml                    # Flutter dependencies
└── README.md                       # This file
```

## 🎨 Customization

### Changing Theme Colors

Edit `lib/config/app_theme.dart`:

```dart
static const Color primaryGreen = Color(0xFF2D5F3F);
static const Color primaryGold = Color(0xFFD4AF37);
static const Color accentTeal = Color(0xFF4A7C7E);
```

### Adding Custom Fonts

1. Place font files in `assets/fonts/`
2. Update `pubspec.yaml`:

```yaml
fonts:
  - family: YourFont
    fonts:
      - asset: assets/fonts/YourFont-Regular.ttf
```

3. Use in theme:

```dart
GoogleFonts.yourFont(fontSize: 16)
```

## 🐛 Troubleshooting

### Firebase not connecting
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in the correct locations
- Check that package/bundle IDs match Firebase configuration

### EPUB files not opening
- Verify the EPUB file is valid and not corrupted
- Check file permissions in Firebase Storage rules

### Audio not playing in background
- Ensure background modes are enabled in iOS Info.plist
- Check audio session permissions

### Build errors
```bash
# Clean build
flutter clean
flutter pub get
flutter pub upgrade

# For iOS
cd ios && pod install && cd ..
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Shaykh Ibrahim Niass (radiyallahu anhu)** - For his profound spiritual teachings
- **Fayda Tijaniyya Community** - For preserving and sharing his works
- **Flutter Team** - For the amazing framework
- **Firebase Team** - For the robust backend infrastructure

## 📞 Support

For support, please contact:
- **Email**: support@faydabook.app
- **Website**: [www.faydabooks.diatech.consulting](https://www.faydabooks.diatech.consulting/)
- **Issues**: [GitHub Issues](https://github.com/yourusername/faydabook/issues)

## 🌟 Donate

If you find this app beneficial, please consider supporting the development:
- **Sadaqah**: Help spread Islamic knowledge
- **Contribute**: Add more books and translations
- **Share**: Tell others about Faydabook

---

**Made with ❤️ for the Ummah**

*"Whoever treads a path in search of knowledge, Allah will make easy for him a path to Paradise."* - Prophet Muhammad ﷺ
