import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/audiobook_card.dart';
import '../widgets/section_header.dart';
import 'book_reader_screen.dart';
import 'audio_player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faydabook'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              // Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<BookProvider>(context, listen: false).loadBooks();
          await Provider.of<AudioProvider>(context, listen: false)
              .loadAudioBooks();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              _buildWelcomeSection(context),
              const SizedBox(height: 24),

              // Continue Reading Section
              Consumer<BookProvider>(
                builder: (context, bookProvider, _) {
                  if (bookProvider.currentlyReading.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      SectionHeader(
                        title: 'Continue Reading',
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bookProvider.currentlyReading.length,
                          itemBuilder: (context, index) {
                            final book = bookProvider.currentlyReading[index];
                            final progress =
                                bookProvider.getReadingProgress(book.id);
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: BookCard(
                                book: book,
                                progress: progress?.progressPercentage,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookReaderScreen(book: book),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

              // Continue Listening Section
              Consumer<AudioProvider>(
                builder: (context, audioProvider, _) {
                  if (audioProvider.currentlyListening.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      SectionHeader(
                        title: 'Continue Listening',
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: audioProvider.currentlyListening.length,
                          itemBuilder: (context, index) {
                            final audioBook =
                                audioProvider.currentlyListening[index];
                            final progress =
                                audioProvider.getAudioProgress(audioBook.id);
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: AudioBookCard(
                                audioBook: audioBook,
                                progress: progress?.progressPercentage,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AudioPlayerScreen(
                                              audioBook: audioBook),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

              // Recently Added Section
              Consumer<BookProvider>(
                builder: (context, bookProvider, _) {
                  if (bookProvider.recentlyAdded.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      SectionHeader(
                        title: 'Recently Added',
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bookProvider.recentlyAdded.length,
                          itemBuilder: (context, index) {
                            final book = bookProvider.recentlyAdded[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: BookCard(
                                book: book,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookReaderScreen(book: book),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'As-salamu alaykum',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover the spiritual wisdom of Shaykh Ibrahim Niass',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
