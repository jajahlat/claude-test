import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/book.dart';
import '../models/audiobook.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch all books from Firestore
  Future<List<Book>> fetchBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Book.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  // Fetch all audiobooks from Firestore
  Future<List<AudioBook>> fetchAudioBooks() async {
    try {
      final snapshot = await _firestore.collection('audiobooks').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return AudioBook.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching audiobooks: $e');
      return [];
    }
  }

  // Upload book to Firebase (for admin)
  Future<String?> uploadBookFile(String filePath, String fileName) async {
    try {
      final ref = _storage.ref().child('books/$fileName');
      final uploadTask = await ref.putFile(
        await _getFileFromPath(filePath),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading book file: $e');
      return null;
    }
  }

  // Upload audio file to Firebase (for admin)
  Future<String?> uploadAudioFile(String filePath, String fileName) async {
    try {
      final ref = _storage.ref().child('audio/$fileName');
      final uploadTask = await ref.putFile(
        await _getFileFromPath(filePath),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading audio file: $e');
      return null;
    }
  }

  // Upload cover image to Firebase (for admin)
  Future<String?> uploadCoverImage(String filePath, String fileName) async {
    try {
      final ref = _storage.ref().child('covers/$fileName');
      final uploadTask = await ref.putFile(
        await _getFileFromPath(filePath),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading cover image: $e');
      return null;
    }
  }

  // Add book to Firestore (for admin)
  Future<bool> addBook(Book book) async {
    try {
      await _firestore.collection('books').doc(book.id).set(book.toJson());
      return true;
    } catch (e) {
      print('Error adding book: $e');
      return false;
    }
  }

  // Add audiobook to Firestore (for admin)
  Future<bool> addAudioBook(AudioBook audioBook) async {
    try {
      await _firestore
          .collection('audiobooks')
          .doc(audioBook.id)
          .set(audioBook.toJson());
      return true;
    } catch (e) {
      print('Error adding audiobook: $e');
      return false;
    }
  }

  // Update book in Firestore (for admin)
  Future<bool> updateBook(Book book) async {
    try {
      await _firestore
          .collection('books')
          .doc(book.id)
          .update(book.toJson());
      return true;
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }

  // Delete book from Firestore (for admin)
  Future<bool> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
      return true;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }

  // Fetch daily quote
  Future<Map<String, dynamic>?> fetchDailyQuote() async {
    try {
      final snapshot = await _firestore.collection('daily_quotes').get();
      if (snapshot.docs.isNotEmpty) {
        // Get a random quote or today's quote
        final today = DateTime.now();
        final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
        final index = dayOfYear % snapshot.docs.length;
        return snapshot.docs[index].data();
      }
      return null;
    } catch (e) {
      print('Error fetching daily quote: $e');
      return null;
    }
  }

  // Helper to get file from path (placeholder)
  Future<dynamic> _getFileFromPath(String filePath) async {
    // This would use file_picker or similar to get actual file
    // For now, this is a placeholder
    throw UnimplementedError('File picking not implemented');
  }
}
