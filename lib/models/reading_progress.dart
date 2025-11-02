class ReadingProgress {
  final String id;
  final String bookId;
  final int currentPage;
  final int totalPages;
  final double progressPercentage;
  final DateTime lastReadDate;
  final String? lastCfi; // For EPUB (CFI = Canonical Fragment Identifier)
  final List<Bookmark> bookmarks;
  final List<Highlight> highlights;

  ReadingProgress({
    required this.id,
    required this.bookId,
    required this.currentPage,
    required this.totalPages,
    required this.progressPercentage,
    required this.lastReadDate,
    this.lastCfi,
    this.bookmarks = const [],
    this.highlights = const [],
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      lastReadDate: DateTime.parse(json['lastReadDate'] as String),
      lastCfi: json['lastCfi'] as String?,
      bookmarks: (json['bookmarks'] as List?)
              ?.map((b) => Bookmark.fromJson(b))
              .toList() ??
          [],
      highlights: (json['highlights'] as List?)
              ?.map((h) => Highlight.fromJson(h))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'progressPercentage': progressPercentage,
      'lastReadDate': lastReadDate.toIso8601String(),
      'lastCfi': lastCfi,
      'bookmarks': bookmarks.map((b) => b.toJson()).toList(),
      'highlights': highlights.map((h) => h.toJson()).toList(),
    };
  }

  ReadingProgress copyWith({
    String? id,
    String? bookId,
    int? currentPage,
    int? totalPages,
    double? progressPercentage,
    DateTime? lastReadDate,
    String? lastCfi,
    List<Bookmark>? bookmarks,
    List<Highlight>? highlights,
  }) {
    return ReadingProgress(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      lastCfi: lastCfi ?? this.lastCfi,
      bookmarks: bookmarks ?? this.bookmarks,
      highlights: highlights ?? this.highlights,
    );
  }
}

class Bookmark {
  final String id;
  final String bookId;
  final int pageNumber;
  final String? cfi;
  final String? note;
  final DateTime createdDate;

  Bookmark({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    this.cfi,
    this.note,
    required this.createdDate,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      pageNumber: json['pageNumber'] as int,
      cfi: json['cfi'] as String?,
      note: json['note'] as String?,
      createdDate: DateTime.parse(json['createdDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'cfi': cfi,
      'note': note,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}

class Highlight {
  final String id;
  final String bookId;
  final int pageNumber;
  final String text;
  final String? cfi;
  final String color; // hex color
  final String? note;
  final DateTime createdDate;

  Highlight({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    required this.text,
    this.cfi,
    required this.color,
    this.note,
    required this.createdDate,
  });

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      pageNumber: json['pageNumber'] as int,
      text: json['text'] as String,
      cfi: json['cfi'] as String?,
      color: json['color'] as String,
      note: json['note'] as String?,
      createdDate: DateTime.parse(json['createdDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'text': text,
      'cfi': cfi,
      'color': color,
      'note': note,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}
