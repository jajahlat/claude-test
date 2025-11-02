import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../models/audiobook.dart';
import '../models/reading_progress.dart';
import '../models/audio_progress.dart';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('faydabook.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> initDatabase() async {
    await database;
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    // Books table
    await db.execute('''
      CREATE TABLE books (
        id $idType,
        title $textType,
        author $textType,
        description $textType,
        coverImageUrl $textType,
        fileUrl $textType,
        type $textType,
        language $textType,
        categories $textType,
        publishedDate $textType,
        totalPages $intType,
        audioBookId TEXT,
        isFavorite $boolType,
        addedDate TEXT
      )
    ''');

    // AudioBooks table
    await db.execute('''
      CREATE TABLE audiobooks (
        id $idType,
        bookId $textType,
        title $textType,
        narrator $textType,
        coverImageUrl $textType,
        chapters $textType,
        totalDuration $intType,
        language $textType,
        addedDate TEXT
      )
    ''');

    // Reading Progress table
    await db.execute('''
      CREATE TABLE reading_progress (
        id $idType,
        bookId $textType,
        currentPage $intType,
        totalPages $intType,
        progressPercentage $realType,
        lastReadDate $textType,
        lastCfi TEXT,
        bookmarks $textType,
        highlights $textType
      )
    ''');

    // Audio Progress table
    await db.execute('''
      CREATE TABLE audio_progress (
        id $idType,
        audioBookId $textType,
        currentChapterIndex $intType,
        currentPosition $intType,
        totalDuration $intType,
        progressPercentage $realType,
        lastListenedDate $textType,
        playbackSpeed $realType
      )
    ''');

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType,
        profileImageUrl TEXT,
        createdDate $textType,
        preferences $textType
      )
    ''');
  }

  // Book operations
  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      'books',
      {
        ...book.toJson(),
        'categories': jsonEncode(book.categories),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final result = await db.query('books', orderBy: 'addedDate DESC');
    return result.map((json) {
      final bookJson = Map<String, dynamic>.from(json);
      bookJson['categories'] = jsonDecode(json['categories'] as String);
      return Book.fromJson(bookJson);
    }).toList();
  }

  Future<Book?> getBook(String id) async {
    final db = await database;
    final result = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      final bookJson = Map<String, dynamic>.from(result.first);
      bookJson['categories'] =
          jsonDecode(result.first['categories'] as String);
      return Book.fromJson(bookJson);
    }
    return null;
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      {
        ...book.toJson(),
        'categories': jsonEncode(book.categories),
      },
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // AudioBook operations
  Future<void> insertAudioBook(AudioBook audioBook) async {
    final db = await database;
    await db.insert(
      'audiobooks',
      {
        ...audioBook.toJson(),
        'chapters': jsonEncode(
            audioBook.chapters.map((c) => c.toJson()).toList()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AudioBook>> getAllAudioBooks() async {
    final db = await database;
    final result = await db.query('audiobooks', orderBy: 'addedDate DESC');
    return result.map((json) {
      final audioBookJson = Map<String, dynamic>.from(json);
      audioBookJson['chapters'] = jsonDecode(json['chapters'] as String);
      return AudioBook.fromJson(audioBookJson);
    }).toList();
  }

  Future<AudioBook?> getAudioBook(String id) async {
    final db = await database;
    final result = await db.query(
      'audiobooks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      final audioBookJson = Map<String, dynamic>.from(result.first);
      audioBookJson['chapters'] =
          jsonDecode(result.first['chapters'] as String);
      return AudioBook.fromJson(audioBookJson);
    }
    return null;
  }

  // Reading Progress operations
  Future<void> insertOrUpdateReadingProgress(ReadingProgress progress) async {
    final db = await database;
    await db.insert(
      'reading_progress',
      {
        ...progress.toJson(),
        'bookmarks': jsonEncode(
            progress.bookmarks.map((b) => b.toJson()).toList()),
        'highlights': jsonEncode(
            progress.highlights.map((h) => h.toJson()).toList()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ReadingProgress>> getAllReadingProgress() async {
    final db = await database;
    final result = await db.query('reading_progress');
    return result.map((json) {
      final progressJson = Map<String, dynamic>.from(json);
      progressJson['bookmarks'] = jsonDecode(json['bookmarks'] as String);
      progressJson['highlights'] = jsonDecode(json['highlights'] as String);
      return ReadingProgress.fromJson(progressJson);
    }).toList();
  }

  Future<ReadingProgress?> getReadingProgress(String bookId) async {
    final db = await database;
    final result = await db.query(
      'reading_progress',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    if (result.isNotEmpty) {
      final progressJson = Map<String, dynamic>.from(result.first);
      progressJson['bookmarks'] =
          jsonDecode(result.first['bookmarks'] as String);
      progressJson['highlights'] =
          jsonDecode(result.first['highlights'] as String);
      return ReadingProgress.fromJson(progressJson);
    }
    return null;
  }

  // Audio Progress operations
  Future<void> insertOrUpdateAudioProgress(AudioProgress progress) async {
    final db = await database;
    await db.insert(
      'audio_progress',
      progress.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AudioProgress>> getAllAudioProgress() async {
    final db = await database;
    final result = await db.query('audio_progress');
    return result.map((json) => AudioProgress.fromJson(json)).toList();
  }

  Future<AudioProgress?> getAudioProgress(String audioBookId) async {
    final db = await database;
    final result = await db.query(
      'audio_progress',
      where: 'audioBookId = ?',
      whereArgs: [audioBookId],
    );

    if (result.isNotEmpty) {
      return AudioProgress.fromJson(result.first);
    }
    return null;
  }

  // User operations
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      {
        ...user.toJson(),
        'preferences': jsonEncode(user.preferences.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser() async {
    final db = await database;
    final result = await db.query('users', limit: 1);

    if (result.isNotEmpty) {
      final userJson = Map<String, dynamic>.from(result.first);
      userJson['preferences'] =
          jsonDecode(result.first['preferences'] as String);
      return User.fromJson(userJson);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      {
        ...user.toJson(),
        'preferences': jsonEncode(user.preferences.toJson()),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
