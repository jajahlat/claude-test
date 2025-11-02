class AudioProgress {
  final String id;
  final String audioBookId;
  final int currentChapterIndex;
  final Duration currentPosition;
  final Duration totalDuration;
  final double progressPercentage;
  final DateTime lastListenedDate;
  final double playbackSpeed;

  AudioProgress({
    required this.id,
    required this.audioBookId,
    required this.currentChapterIndex,
    required this.currentPosition,
    required this.totalDuration,
    required this.progressPercentage,
    required this.lastListenedDate,
    this.playbackSpeed = 1.0,
  });

  factory AudioProgress.fromJson(Map<String, dynamic> json) {
    return AudioProgress(
      id: json['id'] as String,
      audioBookId: json['audioBookId'] as String,
      currentChapterIndex: json['currentChapterIndex'] as int,
      currentPosition: Duration(seconds: json['currentPosition'] as int),
      totalDuration: Duration(seconds: json['totalDuration'] as int),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      lastListenedDate: DateTime.parse(json['lastListenedDate'] as String),
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audioBookId': audioBookId,
      'currentChapterIndex': currentChapterIndex,
      'currentPosition': currentPosition.inSeconds,
      'totalDuration': totalDuration.inSeconds,
      'progressPercentage': progressPercentage,
      'lastListenedDate': lastListenedDate.toIso8601String(),
      'playbackSpeed': playbackSpeed,
    };
  }

  AudioProgress copyWith({
    String? id,
    String? audioBookId,
    int? currentChapterIndex,
    Duration? currentPosition,
    Duration? totalDuration,
    double? progressPercentage,
    DateTime? lastListenedDate,
    double? playbackSpeed,
  }) {
    return AudioProgress(
      id: id ?? this.id,
      audioBookId: audioBookId ?? this.audioBookId,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      lastListenedDate: lastListenedDate ?? this.lastListenedDate,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }
}
