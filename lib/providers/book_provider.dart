import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/reading_progress.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';

class BookProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  final FirebaseService _firebase = FirebaseService();

  List<Book> _allBooks = [];
  List<Book> _favoriteBooks = [];
  List<ReadingProgress> _readingProgress = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get allBooks => _allBooks;
  List<Book> get favoriteBooks => _favoriteBooks;
  List<ReadingProgress> get readingProgress => _readingProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get currently reading books
  List<Book> get currentlyReading {
    final inProgressIds = _readingProgress
        .where((p) => p.progressPercentage > 0 && p.progressPercentage < 100)
        .map((p) => p.bookId)
        .toList();
    return _allBooks.where((book) => inProgressIds.contains(book.id)).toList();
  }

  // Get recently added books
  List<Book> get recentlyAdded {
    final books = List<Book>.from(_allBooks);
    books.sort((a, b) => (b.addedDate ?? DateTime.now())
        .compareTo(a.addedDate ?? DateTime.now()));
    return books.take(10).toList();
  }

  // Get books by category
  List<Book> getBooksByCategory(String category) {
    return _allBooks
        .where((book) => book.categories.contains(category))
        .toList();
  }

  // Get books by language
  List<Book> getBooksByLanguage(String language) {
    return _allBooks.where((book) => book.language == language).toList();
  }

  // Load all books from database and Firebase
  Future<void> loadBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load from local database first
      _allBooks = await _db.getAllBooks();

      // Sync with Firebase
      final firebaseBooks = await _firebase.fetchBooks();
      await _syncBooks(firebaseBooks);

      // Load favorites
      await _loadFavorites();

      // Load reading progress
      _readingProgress = await _db.getAllReadingProgress();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _syncBooks(List<Book> firebaseBooks) async {
    for (var book in firebaseBooks) {
      final existingBook = _allBooks.firstWhere(
        (b) => b.id == book.id,
        orElse: () => book,
      );

      if (existingBook.id != book.id) {
        // New book, add it
        await _db.insertBook(book);
        _allBooks.add(book);
      }
    }
  }

  Future<void> _loadFavorites() async {
    _favoriteBooks = _allBooks.where((book) => book.isFavorite).toList();
  }

  // Toggle favorite
  Future<void> toggleFavorite(String bookId) async {
    final bookIndex = _allBooks.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1) return;

    final book = _allBooks[bookIndex];
    final updatedBook = book.copyWith(isFavorite: !book.isFavorite);

    await _db.updateBook(updatedBook);
    _allBooks[bookIndex] = updatedBook;

    await _loadFavorites();
    notifyListeners();
  }

  // Update reading progress
  Future<void> updateReadingProgress(ReadingProgress progress) async {
    await _db.insertOrUpdateReadingProgress(progress);

    final index = _readingProgress.indexWhere((p) => p.id == progress.id);
    if (index >= 0) {
      _readingProgress[index] = progress;
    } else {
      _readingProgress.add(progress);
    }

    notifyListeners();
  }

  // Get reading progress for a book
  ReadingProgress? getReadingProgress(String bookId) {
    try {
      return _readingProgress.firstWhere((p) => p.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  // Add bookmark
  Future<void> addBookmark(String bookId, Bookmark bookmark) async {
    final progress = getReadingProgress(bookId);
    if (progress == null) return;

    final updatedBookmarks = List<Bookmark>.from(progress.bookmarks)
      ..add(bookmark);
    final updatedProgress = progress.copyWith(bookmarks: updatedBookmarks);

    await updateReadingProgress(updatedProgress);
  }

  // Remove bookmark
  Future<void> removeBookmark(String bookId, String bookmarkId) async {
    final progress = getReadingProgress(bookId);
    if (progress == null) return;

    final updatedBookmarks = progress.bookmarks
        .where((b) => b.id != bookmarkId)
        .toList();
    final updatedProgress = progress.copyWith(bookmarks: updatedBookmarks);

    await updateReadingProgress(updatedProgress);
  }

  // Add highlight
  Future<void> addHighlight(String bookId, Highlight highlight) async {
    final progress = getReadingProgress(bookId);
    if (progress == null) return;

    final updatedHighlights = List<Highlight>.from(progress.highlights)
      ..add(highlight);
    final updatedProgress = progress.copyWith(highlights: updatedHighlights);

    await updateReadingProgress(updatedProgress);
  }

  // Remove highlight
  Future<void> removeHighlight(String bookId, String highlightId) async {
    final progress = getReadingProgress(bookId);
    if (progress == null) return;

    final updatedHighlights = progress.highlights
        .where((h) => h.id != highlightId)
        .toList();
    final updatedProgress = progress.copyWith(highlights: updatedHighlights);

    await updateReadingProgress(updatedProgress);
  }

  // Search books
  List<Book> searchBooks(String query) {
    final lowerQuery = query.toLowerCase();
    return _allBooks.where((book) {
      return book.title.toLowerCase().contains(lowerQuery) ||
          book.author.toLowerCase().contains(lowerQuery) ||
          book.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
