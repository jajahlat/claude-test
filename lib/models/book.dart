class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final String fileUrl; // EPUB or PDF file URL
  final BookType type; // epub or pdf
  final String language; // ar, en, fr
  final List<String> categories; // Tafsir, Poetry, Teachings, Letters
  final DateTime publishedDate;
  final int totalPages;
  final String? audioBookId; // Link to audiobook if available
  final bool isFavorite;
  final DateTime? addedDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    required this.fileUrl,
    required this.type,
    required this.language,
    required this.categories,
    required this.publishedDate,
    this.totalPages = 0,
    this.audioBookId,
    this.isFavorite = false,
    this.addedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      fileUrl: json['fileUrl'] as String,
      type: BookType.values.firstWhere(
        (e) => e.toString() == 'BookType.${json['type']}',
        orElse: () => BookType.epub,
      ),
      language: json['language'] as String,
      categories: List<String>.from(json['categories'] as List),
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      totalPages: json['totalPages'] as int? ?? 0,
      audioBookId: json['audioBookId'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      addedDate: json['addedDate'] != null
          ? DateTime.parse(json['addedDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'fileUrl': fileUrl,
      'type': type.toString().split('.').last,
      'language': language,
      'categories': categories,
      'publishedDate': publishedDate.toIso8601String(),
      'totalPages': totalPages,
      'audioBookId': audioBookId,
      'isFavorite': isFavorite,
      'addedDate': addedDate?.toIso8601String(),
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
    String? fileUrl,
    BookType? type,
    String? language,
    List<String>? categories,
    DateTime? publishedDate,
    int? totalPages,
    String? audioBookId,
    bool? isFavorite,
    DateTime? addedDate,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      type: type ?? this.type,
      language: language ?? this.language,
      categories: categories ?? this.categories,
      publishedDate: publishedDate ?? this.publishedDate,
      totalPages: totalPages ?? this.totalPages,
      audioBookId: audioBookId ?? this.audioBookId,
      isFavorite: isFavorite ?? this.isFavorite,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}

enum BookType {
  epub,
  pdf,
}
