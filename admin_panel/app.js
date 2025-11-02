// Firebase configuration
// NOTE: Replace with your actual Firebase config
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};

// Initialize Firebase (uncomment when you have Firebase setup)
// import { initializeApp } from 'https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js';
// import { getFirestore, collection, addDoc, getDocs, deleteDoc, doc } from 'https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js';
// import { getStorage, ref, uploadBytes, getDownloadURL } from 'https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js';

// const app = initializeApp(firebaseConfig);
// const db = getFirestore(app);
// const storage = getStorage(app);

// Tab Management
function showTab(tabName) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });

    // Show selected tab
    document.getElementById(tabName + '-tab').classList.add('active');
    event.target.classList.add('active');
}

// Books Management
function showAddBookForm() {
    document.getElementById('add-book-form').style.display = 'block';
}

function hideAddBookForm() {
    document.getElementById('add-book-form').style.display = 'none';
    document.getElementById('bookForm').reset();
}

document.getElementById('bookForm')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const title = document.getElementById('book-title').value;
    const author = document.getElementById('book-author').value;
    const description = document.getElementById('book-description').value;
    const language = document.getElementById('book-language').value;
    const type = document.getElementById('book-type').value;
    const categories = document.getElementById('book-categories').value.split(',').map(c => c.trim());
    const totalPages = parseInt(document.getElementById('book-pages').value) || 0;

    const coverFile = document.getElementById('book-cover').files[0];
    const bookFile = document.getElementById('book-file').files[0];

    try {
        // Upload files to Firebase Storage
        // const coverUrl = await uploadFile(coverFile, 'covers');
        // const bookUrl = await uploadFile(bookFile, 'books');

        // For demo purposes, using placeholder URLs
        const coverUrl = 'https://via.placeholder.com/300x400';
        const bookUrl = 'https://example.com/book.epub';

        const bookData = {
            title,
            author,
            description,
            language,
            type,
            categories,
            totalPages,
            coverImageUrl: coverUrl,
            fileUrl: bookUrl,
            publishedDate: new Date().toISOString(),
            addedDate: new Date().toISOString(),
            isFavorite: false
        };

        // Add to Firestore
        // await addDoc(collection(db, 'books'), bookData);

        console.log('Book added:', bookData);
        alert('Book added successfully!');
        hideAddBookForm();
        loadBooks();
    } catch (error) {
        console.error('Error adding book:', error);
        alert('Error adding book: ' + error.message);
    }
});

// Audiobooks Management
function showAddAudiobookForm() {
    document.getElementById('add-audiobook-form').style.display = 'block';
}

function hideAddAudiobookForm() {
    document.getElementById('add-audiobook-form').style.display = 'none';
    document.getElementById('audiobookForm').reset();
}

function addChapter() {
    const container = document.getElementById('chapters-container');
    const chapterItem = document.createElement('div');
    chapterItem.className = 'chapter-item';
    chapterItem.innerHTML = `
        <input type="text" placeholder="Chapter Title" class="chapter-title" required>
        <input type="file" accept="audio/*" class="chapter-file" required>
        <button type="button" onclick="removeChapter(this)">Remove</button>
    `;
    container.appendChild(chapterItem);
}

function removeChapter(btn) {
    btn.parentElement.remove();
}

document.getElementById('audiobookForm')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const title = document.getElementById('audiobook-title').value;
    const narrator = document.getElementById('audiobook-narrator').value;
    const bookId = document.getElementById('audiobook-book-id').value;
    const language = document.getElementById('audiobook-language').value;
    const coverFile = document.getElementById('audiobook-cover').files[0];

    // Get all chapters
    const chapterItems = document.querySelectorAll('.chapter-item');
    const chapters = [];

    for (let i = 0; i < chapterItems.length; i++) {
        const chapterTitle = chapterItems[i].querySelector('.chapter-title').value;
        const chapterFile = chapterItems[i].querySelector('.chapter-file').files[0];

        // Upload audio file
        // const audioUrl = await uploadFile(chapterFile, 'audio');

        chapters.push({
            id: 'chapter_' + (i + 1),
            title: chapterTitle,
            audioUrl: 'https://example.com/audio.mp3',
            duration: 3600, // Placeholder
            chapterNumber: i + 1
        });
    }

    try {
        // Upload cover
        // const coverUrl = await uploadFile(coverFile, 'covers');

        const audiobookData = {
            title,
            narrator,
            bookId: bookId || '',
            language,
            coverImageUrl: 'https://via.placeholder.com/300x300',
            chapters,
            totalDuration: chapters.reduce((sum, ch) => sum + ch.duration, 0),
            addedDate: new Date().toISOString()
        };

        // Add to Firestore
        // await addDoc(collection(db, 'audiobooks'), audiobookData);

        console.log('Audiobook added:', audiobookData);
        alert('Audiobook added successfully!');
        hideAddAudiobookForm();
        loadAudiobooks();
    } catch (error) {
        console.error('Error adding audiobook:', error);
        alert('Error adding audiobook: ' + error.message);
    }
});

// Daily Quotes Management
function showAddQuoteForm() {
    document.getElementById('add-quote-form').style.display = 'block';
}

function hideAddQuoteForm() {
    document.getElementById('add-quote-form').style.display = 'none';
    document.getElementById('quoteForm').reset();
}

document.getElementById('quoteForm')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const quoteData = {
        text: {
            ar: document.getElementById('quote-text-ar').value,
            en: document.getElementById('quote-text-en').value || '',
            fr: document.getElementById('quote-text-fr').value || ''
        },
        source: document.getElementById('quote-source').value || '',
        addedDate: new Date().toISOString()
    };

    try {
        // Add to Firestore
        // await addDoc(collection(db, 'daily_quotes'), quoteData);

        console.log('Quote added:', quoteData);
        alert('Quote added successfully!');
        hideAddQuoteForm();
        loadQuotes();
    } catch (error) {
        console.error('Error adding quote:', error);
        alert('Error adding quote: ' + error.message);
    }
});

// File Upload Helper
async function uploadFile(file, folder) {
    // Implement Firebase Storage upload
    // const storageRef = ref(storage, `${folder}/${Date.now()}_${file.name}`);
    // const snapshot = await uploadBytes(storageRef, file);
    // const url = await getDownloadURL(snapshot.ref);
    // return url;

    // Placeholder
    return 'https://example.com/file.jpg';
}

// Load Data
async function loadBooks() {
    // Load books from Firestore
    // const querySnapshot = await getDocs(collection(db, 'books'));
    // Update table

    // Placeholder
    console.log('Loading books...');
}

async function loadAudiobooks() {
    console.log('Loading audiobooks...');
}

async function loadQuotes() {
    console.log('Loading quotes...');
}

// Initialize
window.addEventListener('DOMContentLoaded', () => {
    loadBooks();
    loadAudiobooks();
    loadQuotes();
});

// Make functions available globally
window.showTab = showTab;
window.showAddBookForm = showAddBookForm;
window.hideAddBookForm = hideAddBookForm;
window.showAddAudiobookForm = showAddAudiobookForm;
window.hideAddAudiobookForm = hideAddAudiobookForm;
window.showAddQuoteForm = showAddQuoteForm;
window.hideAddQuoteForm = hideAddQuoteForm;
window.addChapter = addChapter;
window.removeChapter = removeChapter;
