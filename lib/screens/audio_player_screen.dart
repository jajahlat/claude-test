import 'dart:ui';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.playlist_play_rounded, color: Colors.white),
            ),
            onPressed: _showChaptersList,
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.timer_rounded, color: Colors.white),
            ),
            onPressed: _showSleepTimer,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          Consumer<AudioProvider>(
            builder: (context, audioProvider, _) {
              final currentChapter = audioProvider.currentChapter;
              final isPlaying = audioProvider.isPlaying;
              final currentPosition = audioProvider.currentPosition;
              final totalDuration = audioProvider.totalDuration;
              final playbackSpeed = audioProvider.playbackSpeed;

              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Cover Image with Hero Animation
                    Expanded(
                      flex: 3,
                      child: Hero(
                        tag: 'audio_${widget.audioBook.id}',
                        child: Container(
                          margin: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              widget.audioBook.coverImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                        Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
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
                    ),

                    // Chapter Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            currentChapter?.title ?? widget.audioBook.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.audioBook.narrator,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white.withOpacity(0.3),
                              thumbColor: Colors.white,
                              overlayColor: Colors.white.withOpacity(0.2),
                            ),
                            child: Slider(
                              value: currentPosition.inSeconds.toDouble(),
                              max: totalDuration.inSeconds.toDouble(),
                              onChanged: (value) {
                                audioProvider.seek(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(currentPosition),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatDuration(totalDuration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Controls
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Previous Chapter
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded),
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: audioProvider.playPreviousChapter,
                          ),

                          // Rewind 15s
                          IconButton(
                            icon: const Icon(Icons.replay_15_rounded),
                            iconSize: 32,
                            color: Colors.white,
                            onPressed: () {
                              final newPosition =
                                  currentPosition - const Duration(seconds: 15);
                              audioProvider.seek(newPosition);
                            },
                          ),

                          // Play/Pause
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              iconSize: 48,
                              color: Theme.of(context).colorScheme.primary,
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
                            iconSize: 32,
                            color: Colors.white,
                            onPressed: () {
                              final newPosition =
                                  currentPosition + const Duration(seconds: 15);
                              audioProvider.seek(newPosition);
                            },
                          ),

                          // Next Chapter
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded),
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: audioProvider.playNextChapter,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Playback Speed
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.speed_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<double>(
                            value: playbackSpeed,
                            dropdownColor: Theme.of(context).colorScheme.surface,
                            underline: const SizedBox(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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
                ),
              );
            },
          ),
        ],
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
