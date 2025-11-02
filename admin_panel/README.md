# Faydabook Admin Panel

Web-based administration interface for managing Faydabook content.

## Features

- 📚 **Book Management** - Upload and manage EPUB/PDF books
- 🎧 **Audiobook Management** - Upload audio chapters and metadata
- 💭 **Daily Quotes** - Manage inspirational quotes from Shaykh Ibrahim Niass
- 🔥 **Firebase Integration** - Direct connection to Firestore and Storage

## Quick Start

### 1. Configure Firebase

Edit `app.js` and update the Firebase configuration:

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

Get these values from Firebase Console → Project Settings → General

### 2. Deploy Options

#### Option A: Firebase Hosting (Recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize hosting
firebase init hosting

# Deploy
firebase deploy --only hosting
```

#### Option B: Local Development

```bash
# Using Python
python -m http.server 8000

# Using Node.js
npx http-server

# Using PHP
php -S localhost:8000
```

Then visit `http://localhost:8000`

#### Option C: Other Hosting

Upload files to any static hosting:
- Netlify
- Vercel
- GitHub Pages
- AWS S3
- Google Cloud Storage

## Usage Guide

### Adding a Book

1. Click the "Books" tab
2. Click "+ Add New Book"
3. Fill in the form:
   - **Title**: Book title
   - **Author**: Usually "Shaykh Ibrahim Niass"
   - **Description**: Brief description
   - **Language**: Arabic, English, or French
   - **Type**: EPUB or PDF
   - **Categories**: Comma-separated (e.g., "Tafsir, Poetry")
   - **Cover Image**: Upload JPG/PNG
   - **Book File**: Upload EPUB/PDF
   - **Total Pages**: Number of pages (optional)
4. Click "Save Book"

### Adding an Audiobook

1. Click the "Audiobooks" tab
2. Click "+ Add New Audiobook"
3. Fill in the form:
   - **Title**: Audiobook title
   - **Narrator**: Name of narrator
   - **Related Book ID**: Link to ebook (optional)
   - **Language**: Audio language
   - **Cover Image**: Upload JPG/PNG
4. Add chapters:
   - Click "+ Add Chapter"
   - Enter chapter title
   - Upload MP3 file
   - Repeat for all chapters
5. Click "Save Audiobook"

### Adding a Daily Quote

1. Click the "Daily Quotes" tab
2. Click "+ Add New Quote"
3. Fill in the form:
   - **Quote Text (Arabic)**: Original quote
   - **Quote Text (English)**: English translation (optional)
   - **Quote Text (French)**: French translation (optional)
   - **Source/Reference**: Book or lecture reference
4. Click "Save Quote"

## File Size Recommendations

- **Cover Images**: Max 2MB, 800x1200px recommended
- **EPUB Files**: Max 50MB
- **PDF Files**: Max 100MB
- **Audio Files**: Max 100MB per chapter, MP3 format

## Security Notes

### Firebase Rules

Ensure your Firestore rules protect against unauthorized writes:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /books/{bookId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

### Admin Authentication

For production, add authentication:

1. Enable Firebase Authentication
2. Create admin users
3. Add login screen to admin panel
4. Restrict access to authenticated admins only

## Troubleshooting

### Files not uploading
- Check file size limits
- Verify Firebase Storage rules
- Check browser console for errors

### Changes not appearing in app
- Ensure Firestore rules allow reads
- Check Firebase Console for data
- Verify file URLs are publicly accessible

### Firebase connection errors
- Verify config values are correct
- Check Firebase project is active
- Ensure billing is enabled (for Storage)

## Advanced Features

### Bulk Upload

For bulk uploading books, use Firebase Admin SDK:

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'your-bucket.appspot.com'
});

// Upload script here
```

### Custom Fields

To add custom fields, update:
1. `index.html` - Add form fields
2. `app.js` - Update data object
3. Mobile app models - Add fields to Book/Audiobook classes

## Support

For help with the admin panel:
- Check main README.md
- Contact: support@faydabook.app
- GitHub Issues

---

Made with ❤️ for spreading Islamic knowledge
