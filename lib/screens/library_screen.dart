import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/section_header.dart';
import 'book_reader_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLanguage = 'all';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Books'),
            Tab(text: 'Favorites'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllBooksTab(),
          _buildFavoritesTab(),
          _buildCategoriesTab(),
        ],
      ),
    );
  }

  Widget _buildAllBooksTab() {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, _) {
        if (bookProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookProvider.allBooks.isEmpty) {
          return _buildEmptyState('No books available');
        }

        return Column(
          children: [
            // Filters
            _buildFilters(),

            // Books Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _getFilteredBooks(bookProvider.allBooks).length,
                itemBuilder: (context, index) {
                  final book =
                      _getFilteredBooks(bookProvider.allBooks)[index];
                  final progress = bookProvider.getReadingProgress(book.id);
                  return BookCard(
                    book: book,
                    progress: progress?.progressPercentage,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookReaderScreen(book: book),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, _) {
        if (bookProvider.favoriteBooks.isEmpty) {
          return _buildEmptyState('No favorite books yet');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: bookProvider.favoriteBooks.length,
          itemBuilder: (context, index) {
            final book = bookProvider.favoriteBooks[index];
            final progress = bookProvider.getReadingProgress(book.id);
            return BookCard(
              book: book,
              progress: progress?.progressPercentage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookReaderScreen(book: book),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    final categories = ['Tafsir', 'Poetry', 'Teachings', 'Letters'];

    return Consumer<BookProvider>(
      builder: (context, bookProvider, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final books = bookProvider.getBooksByCategory(category);

            if (books.isEmpty) return const SizedBox.shrink();

            return Column(
              children: [
                SectionHeader(
                  title: category,
                  onSeeAll: () {},
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
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
                                builder: (_) => BookReaderScreen(book: book),
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
        );
      },
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Language Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fr', child: Text('French')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 12),

          // Category Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'Tafsir', child: Text('Tafsir')),
                DropdownMenuItem(value: 'Poetry', child: Text('Poetry')),
                DropdownMenuItem(
                    value: 'Teachings', child: Text('Teachings')),
                DropdownMenuItem(value: 'Letters', child: Text('Letters')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getFilteredBooks(List<dynamic> books) {
    var filtered = books;

    if (_selectedLanguage != 'all') {
      filtered =
          filtered.where((b) => b.language == _selectedLanguage).toList();
    }

    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((b) => b.categories.contains(_selectedCategory))
          .toList();
    }

    return filtered;
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
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
