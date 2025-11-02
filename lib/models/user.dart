class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdDate;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdDate,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdDate: DateTime.parse(json['createdDate'] as String),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdDate': createdDate.toIso8601String(),
      'preferences': preferences.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? createdDate,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdDate: createdDate ?? this.createdDate,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserPreferences {
  final String language; // ar, en, fr
  final bool dailyQuotesEnabled;
  final String dailyQuoteTime; // HH:mm format
  final bool notificationsEnabled;
  final ReadingPreferences readingPreferences;

  UserPreferences({
    this.language = 'en',
    this.dailyQuotesEnabled = true,
    this.dailyQuoteTime = '08:00',
    this.notificationsEnabled = true,
    required this.readingPreferences,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] as String? ?? 'en',
      dailyQuotesEnabled: json['dailyQuotesEnabled'] as bool? ?? true,
      dailyQuoteTime: json['dailyQuoteTime'] as String? ?? '08:00',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      readingPreferences: ReadingPreferences.fromJson(
          json['readingPreferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'dailyQuotesEnabled': dailyQuotesEnabled,
      'dailyQuoteTime': dailyQuoteTime,
      'notificationsEnabled': notificationsEnabled,
      'readingPreferences': readingPreferences.toJson(),
    };
  }

  UserPreferences copyWith({
    String? language,
    bool? dailyQuotesEnabled,
    String? dailyQuoteTime,
    bool? notificationsEnabled,
    ReadingPreferences? readingPreferences,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      dailyQuotesEnabled: dailyQuotesEnabled ?? this.dailyQuotesEnabled,
      dailyQuoteTime: dailyQuoteTime ?? this.dailyQuoteTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      readingPreferences: readingPreferences ?? this.readingPreferences,
    );
  }
}

class ReadingPreferences {
  final double fontSize;
  final String fontFamily;
  final String backgroundColor;
  final String textColor;
  final double lineHeight;
  final String textAlign; // left, right, center, justify

  ReadingPreferences({
    this.fontSize = 16.0,
    this.fontFamily = 'Lora',
    this.backgroundColor = '#FFFFFF',
    this.textColor = '#1A1A1A',
    this.lineHeight = 1.5,
    this.textAlign = 'justify',
  });

  factory ReadingPreferences.fromJson(Map<String, dynamic> json) {
    return ReadingPreferences(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      fontFamily: json['fontFamily'] as String? ?? 'Lora',
      backgroundColor: json['backgroundColor'] as String? ?? '#FFFFFF',
      textColor: json['textColor'] as String? ?? '#1A1A1A',
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.5,
      textAlign: json['textAlign'] as String? ?? 'justify',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'lineHeight': lineHeight,
      'textAlign': textAlign,
    };
  }

  ReadingPreferences copyWith({
    double? fontSize,
    String? fontFamily,
    String? backgroundColor,
    String? textColor,
    double? lineHeight,
    String? textAlign,
  }) {
    return ReadingPreferences(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      lineHeight: lineHeight ?? this.lineHeight,
      textAlign: textAlign ?? this.textAlign,
    );
  }
}
