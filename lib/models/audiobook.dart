class AudioBook {
  final String id;
  final String bookId; // Reference to Book
  final String title;
  final String narrator;
  final String coverImageUrl;
  final List<AudioChapter> chapters;
  final Duration totalDuration;
  final String language;
  final DateTime? addedDate;

  AudioBook({
    required this.id,
    required this.bookId,
    required this.title,
    required this.narrator,
    required this.coverImageUrl,
    required this.chapters,
    required this.totalDuration,
    required this.language,
    this.addedDate,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return AudioBook(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      narrator: json['narrator'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      chapters: (json['chapters'] as List)
          .map((chapter) => AudioChapter.fromJson(chapter))
          .toList(),
      totalDuration: Duration(seconds: json['totalDuration'] as int),
      language: json['language'] as String,
      addedDate: json['addedDate'] != null
          ? DateTime.parse(json['addedDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'narrator': narrator,
      'coverImageUrl': coverImageUrl,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      'totalDuration': totalDuration.inSeconds,
      'language': language,
      'addedDate': addedDate?.toIso8601String(),
    };
  }
}

class AudioChapter {
  final String id;
  final String title;
  final String audioUrl;
  final Duration duration;
  final int chapterNumber;

  AudioChapter({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.duration,
    required this.chapterNumber,
  });

  factory AudioChapter.fromJson(Map<String, dynamic> json) {
    return AudioChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      audioUrl: json['audioUrl'] as String,
      duration: Duration(seconds: json['duration'] as int),
      chapterNumber: json['chapterNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'audioUrl': audioUrl,
      'duration': duration.inSeconds,
      'chapterNumber': chapterNumber,
    };
  }
}
