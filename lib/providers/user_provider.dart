import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  final FirebaseService _firebase = FirebaseService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // Load or create default user
  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from database
      _currentUser = await _db.getUser();

      // If no user exists, create a default one
      if (_currentUser == null) {
        _currentUser = User(
          id: 'default_user',
          name: 'Guest User',
          email: 'guest@faydabook.app',
          createdDate: DateTime.now(),
          preferences: UserPreferences(
            readingPreferences: ReadingPreferences(),
          ),
        );
        await _db.insertUser(_currentUser!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateUser(User user) async {
    try {
      await _db.updateUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update user preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(preferences: preferences);
    await updateUser(updatedUser);
  }

  // Update reading preferences
  Future<void> updateReadingPreferences(
      ReadingPreferences readingPreferences) async {
    if (_currentUser == null) return;

    final updatedPreferences =
        _currentUser!.preferences.copyWith(readingPreferences: readingPreferences);
    await updatePreferences(updatedPreferences);
  }

  // Toggle daily quotes
  Future<void> toggleDailyQuotes(bool enabled) async {
    if (_currentUser == null) return;

    final updatedPreferences =
        _currentUser!.preferences.copyWith(dailyQuotesEnabled: enabled);
    await updatePreferences(updatedPreferences);
  }

  // Set daily quote time
  Future<void> setDailyQuoteTime(String time) async {
    if (_currentUser == null) return;

    final updatedPreferences =
        _currentUser!.preferences.copyWith(dailyQuoteTime: time);
    await updatePreferences(updatedPreferences);
  }

  // Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    if (_currentUser == null) return;

    final updatedPreferences =
        _currentUser!.preferences.copyWith(notificationsEnabled: enabled);
    await updatePreferences(updatedPreferences);
  }

  // Change language
  Future<void> changeLanguage(String language) async {
    if (_currentUser == null) return;

    final updatedPreferences =
        _currentUser!.preferences.copyWith(language: language);
    await updatePreferences(updatedPreferences);
  }
}
