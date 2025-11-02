import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/audiobook_card.dart';
import 'audio_player_screen.dart';

class AudioLibraryScreen extends StatelessWidget {
  const AudioLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Library'),
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, _) {
          if (audioProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (audioProvider.allAudioBooks.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: audioProvider.allAudioBooks.length,
            itemBuilder: (context, index) {
              final audioBook = audioProvider.allAudioBooks[index];
              final progress = audioProvider.getAudioProgress(audioBook.id);
              return AudioBookCard(
                audioBook: audioBook,
                progress: progress?.progressPercentage,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AudioPlayerScreen(audioBook: audioBook),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.headphones_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No audiobooks available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
