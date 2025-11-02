import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../models/reading_progress.dart';
import '../providers/book_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class BookReaderScreen extends StatefulWidget {
  final Book book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  bool _isLoading = true;
  String? _localFilePath;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    try {
      // Download book if not already downloaded
      final dir = await getApplicationDocumentsDirectory();
      final fileName = widget.book.fileUrl.split('/').last;
      final filePath = '${dir.path}/$fileName';

      final file = File(filePath);
      if (!file.existsSync()) {
        // Download the file
        final response = await http.get(Uri.parse(widget.book.fileUrl));
        await file.writeAsBytes(response.bodyBytes);
      }

      setState(() {
        _localFilePath = filePath;
        _isLoading = false;
      });

      // Load progress
      final bookProvider =
          Provider.of<BookProvider>(context, listen: false);
      final progress = bookProvider.getReadingProgress(widget.book.id);
      if (progress != null) {
        _currentPage = progress.currentPage;
      }

      // Open the book
      if (widget.book.type == BookType.epub) {
        await _openEpub();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading book: $e')),
        );
      }
    }
  }

  Future<void> _openEpub() async {
    if (_localFilePath == null) return;

    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final progress = bookProvider.getReadingProgress(widget.book.id);

    VocsyEpub.setConfig(
      themeColor: Theme.of(context).colorScheme.primary,
      identifier: widget.book.id,
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: Theme.of(context).brightness == Brightness.dark,
    );

    // Get locator from progress
    final locator = progress?.lastCfi != null
        ? EpubLocator.fromJson({
      'bookId': widget.book.id,
      'href': '',
      'created': DateTime.now().millisecondsSinceEpoch,
      'locations': {
        'cfi': progress!.lastCfi,
      },
    })
        : null;

    VocsyEpub.open(
      _localFilePath!,
      lastLocation: locator,
    );

    // Listen for location changes
    VocsyEpub.locatorStream.listen((locator) {
      _saveProgress(locator);
    });
  }

  Future<void> _saveProgress(dynamic locator) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    final progress = ReadingProgress(
      id: widget.book.id,
      bookId: widget.book.id,
      currentPage: _currentPage,
      totalPages: widget.book.totalPages,
      progressPercentage:
      widget.book.totalPages > 0
          ? (_currentPage / widget.book.totalPages * 100)
          : 0,
      lastReadDate: DateTime.now(),
      lastCfi: locator?.locations?.cfi,
    );

    await bookProvider.updateReadingProgress(progress);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.book.title),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: _showBookmarks,
          ),
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: _showReadingSettings,
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareBook,
          ),
          Consumer<BookProvider>(
            builder: (context, bookProvider, _) {
              final isFavorite =
                  bookProvider.allBooks
                      .firstWhere((b) => b.id == widget.book.id)
                      .isFavorite;
              return IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  bookProvider.toggleFavorite(widget.book.id);
                },
              );
            },
          ),
        ],
      ),
      body: widget.book.type == BookType.epub
          ? _buildEpubReader()
          : _buildPdfReader(),
    );
  }

  Widget _buildEpubReader() {
    // EPUB reading is handled by the native plugin
    return const Center(
      child: Text('EPUB reader is open in native viewer'),
    );
  }

  Widget _buildPdfReader() {
    if (_localFilePath == null) {
      return const Center(child: Text('Unable to load PDF'));
    }

    return PDFView(
      filePath: _localFilePath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      defaultPage: _currentPage,
      fitPolicy: FitPolicy.WIDTH,
      preventLinkNavigation: false,
      onRender: (pages) {
        setState(() {
          // Update total pages if needed
        });
      },
      onError: (error) {
        print('PDF Error: $error');
      },
      onPageError: (page, error) {
        print('Page $page Error: $error');
      },
      onViewCreated: (PDFViewController pdfViewController) {
        // Can control PDF from here
      },
      onPageChanged: (int? page, int? total) {
        if (page != null) {
          setState(() {
            _currentPage = page;
          });
          _saveProgress(null);
        }
      },
    );
  }

  void _showBookmarks() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<BookProvider>(
          builder: (context, bookProvider, _) {
            final progress = bookProvider.getReadingProgress(widget.book.id);
            final bookmarks = progress?.bookmarks ?? [];

            if (bookmarks.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No bookmarks yet'),
                ),
              );
            }

            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return ListTile(
                  leading: const Icon(Icons.bookmark_rounded),
                  title: Text('Page ${bookmark.pageNumber}'),
                  subtitle: bookmark.note != null
                      ? Text(bookmark.note!)
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () {
                      bookProvider.removeBookmark(
                          widget.book.id, bookmark.id);
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    // Jump to bookmark
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showReadingSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.format_size_rounded),
                title: const Text('Font Size'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Show font size selector
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens_rounded),
                title: const Text('Theme'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Show theme selector
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6_rounded),
                title: const Text('Brightness'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Show brightness slider
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareBook() {
    Share.share(
      'Check out "${widget.book.title}" by ${widget.book.author} on Faydabook!',
      subject: widget.book.title,
    );
  }
}
