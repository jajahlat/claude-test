import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/audiobook.dart';
import '../models/audio_progress.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';

class AudioProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  final FirebaseService _firebase = FirebaseService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<AudioBook> _allAudioBooks = [];
  List<AudioProgress> _audioProgress = [];
  AudioBook? _currentAudioBook;
  AudioChapter? _currentChapter;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _playbackSpeed = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _error;

  List<AudioBook> get allAudioBooks => _allAudioBooks;
  List<AudioProgress> get audioProgress => _audioProgress;
  AudioBook? get currentAudioBook => _currentAudioBook;
  AudioChapter? get currentChapter => _currentChapter;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  double get playbackSpeed => _playbackSpeed;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  String? get error => _error;
  AudioPlayer get audioPlayer => _audioPlayer;

  AudioProvider() {
    _initializePlayer();
  }

  void _initializePlayer() {
    // Listen to player state
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Listen to position
    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();

      // Auto-save progress every 10 seconds
      if (position.inSeconds % 10 == 0 && _currentAudioBook != null) {
        _saveProgress();
      }
    });

    // Listen to duration
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        notifyListeners();
      }
    });
  }

  // Get currently listening audiobooks
  List<AudioBook> get currentlyListening {
    final inProgressIds = _audioProgress
        .where((p) => p.progressPercentage > 0 && p.progressPercentage < 100)
        .map((p) => p.audioBookId)
        .toList();
    return _allAudioBooks
        .where((audio) => inProgressIds.contains(audio.id))
        .toList();
  }

  // Load all audiobooks
  Future<void> loadAudioBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load from local database
      _allAudioBooks = await _db.getAllAudioBooks();

      // Sync with Firebase
      final firebaseAudioBooks = await _firebase.fetchAudioBooks();
      await _syncAudioBooks(firebaseAudioBooks);

      // Load progress
      _audioProgress = await _db.getAllAudioProgress();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _syncAudioBooks(List<AudioBook> firebaseAudioBooks) async {
    for (var audioBook in firebaseAudioBooks) {
      final existingAudioBook = _allAudioBooks.firstWhere(
        (a) => a.id == audioBook.id,
        orElse: () => audioBook,
      );

      if (existingAudioBook.id != audioBook.id) {
        await _db.insertAudioBook(audioBook);
        _allAudioBooks.add(audioBook);
      }
    }
  }

  // Play audiobook
  Future<void> playAudioBook(AudioBook audioBook,
      {int chapterIndex = 0}) async {
    try {
      _currentAudioBook = audioBook;
      _currentChapter = audioBook.chapters[chapterIndex];

      // Load progress if exists
      final progress = getAudioProgress(audioBook.id);
      if (progress != null && chapterIndex == progress.currentChapterIndex) {
        await _audioPlayer.setUrl(_currentChapter!.audioUrl);
        await _audioPlayer.seek(progress.currentPosition);
      } else {
        await _audioPlayer.setUrl(_currentChapter!.audioUrl);
      }

      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to play audio: $e';
      notifyListeners();
    }
  }

  // Pause
  Future<void> pause() async {
    await _audioPlayer.pause();
    await _saveProgress();
    notifyListeners();
  }

  // Resume
  Future<void> resume() async {
    await _audioPlayer.play();
    notifyListeners();
  }

  // Stop
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _saveProgress();
    _currentAudioBook = null;
    _currentChapter = null;
    notifyListeners();
  }

  // Seek
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  // Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _audioPlayer.setSpeed(speed);
    notifyListeners();
  }

  // Play next chapter
  Future<void> playNextChapter() async {
    if (_currentAudioBook == null || _currentChapter == null) return;

    final currentIndex = _currentAudioBook!.chapters.indexOf(_currentChapter!);
    if (currentIndex < _currentAudioBook!.chapters.length - 1) {
      await playAudioBook(_currentAudioBook!, chapterIndex: currentIndex + 1);
    }
  }

  // Play previous chapter
  Future<void> playPreviousChapter() async {
    if (_currentAudioBook == null || _currentChapter == null) return;

    final currentIndex = _currentAudioBook!.chapters.indexOf(_currentChapter!);
    if (currentIndex > 0) {
      await playAudioBook(_currentAudioBook!, chapterIndex: currentIndex - 1);
    }
  }

  // Save progress
  Future<void> _saveProgress() async {
    if (_currentAudioBook == null) return;

    final currentIndex =
        _currentChapter != null
            ? _currentAudioBook!.chapters.indexOf(_currentChapter!)
            : 0;

    final progressPercentage =
        _totalDuration.inSeconds > 0
            ? (_currentPosition.inSeconds / _totalDuration.inSeconds * 100)
            : 0.0;

    final progress = AudioProgress(
      id: _currentAudioBook!.id,
      audioBookId: _currentAudioBook!.id,
      currentChapterIndex: currentIndex,
      currentPosition: _currentPosition,
      totalDuration: _currentAudioBook!.totalDuration,
      progressPercentage: progressPercentage,
      lastListenedDate: DateTime.now(),
      playbackSpeed: _playbackSpeed,
    );

    await _db.insertOrUpdateAudioProgress(progress);

    final index = _audioProgress.indexWhere((p) => p.id == progress.id);
    if (index >= 0) {
      _audioProgress[index] = progress;
    } else {
      _audioProgress.add(progress);
    }
  }

  // Get audio progress
  AudioProgress? getAudioProgress(String audioBookId) {
    try {
      return _audioProgress.firstWhere((p) => p.audioBookId == audioBookId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
