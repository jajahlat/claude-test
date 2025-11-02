import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/audiobook.dart';
import '../providers/audio_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  final AudioBook audioBook;

  const AudioPlayerScreen({super.key, required this.audioBook});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    // If not already playing this audiobook, start it
    if (audioProvider.currentAudioBook?.id != widget.audioBook.id) {
      audioProvider.playAudioBook(widget.audioBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audioBook.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play_rounded),
            onPressed: _showChaptersList,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sleep_timer') {
                _showSleepTimer();
              } else if (value == 'share') {
                // Share audiobook
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sleep_timer',
                child: Row(
                  children: [
                    Icon(Icons.timer_rounded),
                    SizedBox(width: 8),
                    Text('Sleep Timer'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_rounded),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, _) {
          final currentChapter = audioProvider.currentChapter;
          final isPlaying = audioProvider.isPlaying;
          final currentPosition = audioProvider.currentPosition;
          final totalDuration = audioProvider.totalDuration;
          final playbackSpeed = audioProvider.playbackSpeed;

          return Column(
            children: [
              // Cover Image
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.audioBook.coverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.primary,
                          child: const Icon(
                            Icons.headphones_rounded,
                            size: 100,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Chapter Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      currentChapter?.title ?? widget.audioBook.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.audioBook.narrator,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Slider(
                      value: currentPosition.inSeconds.toDouble(),
                      max: totalDuration.inSeconds.toDouble(),
                      onChanged: (value) {
                        audioProvider.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(currentPosition)),
                        Text(_formatDuration(totalDuration)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous Chapter
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded),
                      iconSize: 48,
                      onPressed: audioProvider.playPreviousChapter,
                    ),

                    // Rewind 15s
                    IconButton(
                      icon: const Icon(Icons.replay_15_rounded),
                      iconSize: 36,
                      onPressed: () {
                        final newPosition =
                            currentPosition - const Duration(seconds: 15);
                        audioProvider.seek(newPosition);
                      },
                    ),

                    // Play/Pause
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        iconSize: 56,
                        color: Colors.white,
                        onPressed: () {
                          if (isPlaying) {
                            audioProvider.pause();
                          } else {
                            audioProvider.resume();
                          }
                        },
                      ),
                    ),

                    // Forward 15s
                    IconButton(
                      icon: const Icon(Icons.forward_15_rounded),
                      iconSize: 36,
                      onPressed: () {
                        final newPosition =
                            currentPosition + const Duration(seconds: 15);
                        audioProvider.seek(newPosition);
                      },
                    ),

                    // Next Chapter
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      iconSize: 48,
                      onPressed: audioProvider.playNextChapter,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Playback Speed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.speed_rounded),
                    const SizedBox(width: 8),
                    DropdownButton<double>(
                      value: playbackSpeed,
                      items: [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
                          .map((speed) => DropdownMenuItem(
                        value: speed,
                        child: Text('${speed}x'),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          audioProvider.setPlaybackSpeed(value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  void _showChaptersList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: widget.audioBook.chapters.length,
          itemBuilder: (context, index) {
            final chapter = widget.audioBook.chapters[index];
            final audioProvider =
                Provider.of<AudioProvider>(context, listen: false);
            final isCurrentChapter =
                audioProvider.currentChapter?.id == chapter.id;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isCurrentChapter
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                child: Text(
                  chapter.chapterNumber.toString(),
                  style: TextStyle(
                    color: isCurrentChapter ? Colors.white : Colors.black,
                  ),
                ),
              ),
              title: Text(chapter.title),
              subtitle: Text(_formatDuration(chapter.duration)),
              trailing: isCurrentChapter
                  ? const Icon(Icons.play_circle_filled_rounded)
                  : null,
              onTap: () {
                audioProvider.playAudioBook(
                  widget.audioBook,
                  chapterIndex: index,
                );
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showSleepTimer() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sleep Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('15 minutes'),
                onTap: () {
                  // Set timer for 15 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('30 minutes'),
                onTap: () {
                  // Set timer for 30 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('1 hour'),
                onTap: () {
                  // Set timer for 1 hour
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Custom'),
                onTap: () {
                  // Show custom timer picker
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
