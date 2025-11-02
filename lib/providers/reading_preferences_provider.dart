import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReaderTheme {
  light,
  sepia,
  dark,
  midnight,
}

enum ReaderFontFamily {
  lora,
  amiri,
  inter,
  system,
}

class ReadingPreferencesProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  ReaderTheme _readerTheme = ReaderTheme.light;
  ReaderFontFamily _fontFamily = ReaderFontFamily.lora;
  double _fontSize = 18.0;
  double _lineHeight = 1.6;
  double _marginWidth = 16.0;
  double _brightness = 1.0;

  ReadingPreferencesProvider(this._prefs) {
    _loadPreferences();
  }

  // Getters
  ReaderTheme get readerTheme => _readerTheme;
  ReaderFontFamily get fontFamily => _fontFamily;
  double get fontSize => _fontSize;
  double get lineHeight => _lineHeight;
  double get marginWidth => _marginWidth;
  double get brightness => _brightness;

  // Load preferences from storage
  Future<void> _loadPreferences() async {
    _readerTheme = ReaderTheme.values[_prefs.getInt('readerTheme') ?? 0];
    _fontFamily = ReaderFontFamily.values[_prefs.getInt('fontFamily') ?? 0];
    _fontSize = _prefs.getDouble('fontSize') ?? 18.0;
    _lineHeight = _prefs.getDouble('lineHeight') ?? 1.6;
    _marginWidth = _prefs.getDouble('marginWidth') ?? 16.0;
    _brightness = _prefs.getDouble('brightness') ?? 1.0;
    notifyListeners();
  }

  // Setters with persistence
  Future<void> setReaderTheme(ReaderTheme theme) async {
    _readerTheme = theme;
    await _prefs.setInt('readerTheme', theme.index);
    notifyListeners();
  }

  Future<void> setFontFamily(ReaderFontFamily family) async {
    _fontFamily = family;
    await _prefs.setInt('fontFamily', family.index);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(12.0, 32.0);
    await _prefs.setDouble('fontSize', _fontSize);
    notifyListeners();
  }

  Future<void> setLineHeight(double height) async {
    _lineHeight = height.clamp(1.0, 2.5);
    await _prefs.setDouble('lineHeight', _lineHeight);
    notifyListeners();
  }

  Future<void> setMarginWidth(double width) async {
    _marginWidth = width.clamp(8.0, 48.0);
    await _prefs.setDouble('marginWidth', _marginWidth);
    notifyListeners();
  }

  Future<void> setBrightness(double value) async {
    _brightness = value.clamp(0.0, 1.0);
    await _prefs.setDouble('brightness', _brightness);
    notifyListeners();
  }

  // Helper methods
  Color getBackgroundColor() {
    switch (_readerTheme) {
      case ReaderTheme.light:
        return Colors.white;
      case ReaderTheme.sepia:
        return const Color(0xFFF4ECD8);
      case ReaderTheme.dark:
        return const Color(0xFF1A1A1A);
      case ReaderTheme.midnight:
        return const Color(0xFF000000);
    }
  }

  Color getTextColor() {
    switch (_readerTheme) {
      case ReaderTheme.light:
        return const Color(0xFF222222);
      case ReaderTheme.sepia:
        return const Color(0xFF5F4B32);
      case ReaderTheme.dark:
        return const Color(0xFFE0E0E0);
      case ReaderTheme.midnight:
        return const Color(0xFFCCCCCC);
    }
  }

  String getFontFamilyName() {
    switch (_fontFamily) {
      case ReaderFontFamily.lora:
        return 'Lora';
      case ReaderFontFamily.amiri:
        return 'Amiri';
      case ReaderFontFamily.inter:
        return 'Inter';
      case ReaderFontFamily.system:
        return 'System';
    }
  }

  String getThemeName(ReaderTheme theme) {
    switch (theme) {
      case ReaderTheme.light:
        return 'Light';
      case ReaderTheme.sepia:
        return 'Sepia';
      case ReaderTheme.dark:
        return 'Dark';
      case ReaderTheme.midnight:
        return 'Midnight';
    }
  }

  IconData getThemeIcon(ReaderTheme theme) {
    switch (theme) {
      case ReaderTheme.light:
        return Icons.wb_sunny_rounded;
      case ReaderTheme.sepia:
        return Icons.auto_stories_rounded;
      case ReaderTheme.dark:
        return Icons.nightlight_round;
      case ReaderTheme.midnight:
        return Icons.dark_mode_rounded;
    }
  }
}
