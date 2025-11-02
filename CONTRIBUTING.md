# Contributing to Faydabook

First off, thank you for considering contributing to Faydabook! It's people like you that make Faydabook such a great tool for spreading Islamic knowledge.

## Code of Conduct

This project and everyone participating in it is governed by Islamic principles of respect, kindness, and mutual support. By participating, you are expected to uphold these values.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

**Bug Report Template:**
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Device Info:**
 - Device: [e.g. iPhone 12, Samsung Galaxy S21]
 - OS: [e.g. iOS 15.0, Android 12]
 - App Version: [e.g. 1.0.0]

**Additional context**
Any other information about the problem.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

**Enhancement Template:**
```markdown
**Is your feature request related to a problem?**
A clear description of what the problem is.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Other solutions or features you've considered.

**Additional context**
Any other context or screenshots.
```

### Content Contributions

We welcome contributions of Islamic content:

#### Adding Books
- Books must be works by or about Shaykh Ibrahim Niass
- Must have proper copyright permissions
- Include accurate metadata (title, author, description)
- EPUB/PDF files should be properly formatted

#### Adding Audiobooks
- Must be properly licensed
- Audio quality: minimum 128kbps MP3
- Include accurate chapter divisions
- Provide narrator information

#### Adding Translations
- Translations should be accurate and reviewed
- Maintain the spiritual essence of the original
- Include translator credentials

### Code Contributions

#### Pull Request Process

1. **Fork the Repository**
```bash
git clone https://github.com/yourusername/faydabook.git
cd faydabook
```

2. **Create a Branch**
```bash
git checkout -b feature/AmazingFeature
```

Branch naming convention:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Adding tests

3. **Make Your Changes**
- Follow the code style guide (see below)
- Write meaningful commit messages
- Add tests if applicable
- Update documentation

4. **Test Your Changes**
```bash
flutter test
flutter analyze
```

5. **Commit Your Changes**
```bash
git add .
git commit -m "feat: add amazing feature"
```

Commit message format:
```
<type>: <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

6. **Push to Your Fork**
```bash
git push origin feature/AmazingFeature
```

7. **Open a Pull Request**
- Fill in the PR template
- Link related issues
- Add screenshots for UI changes
- Request review from maintainers

### Code Style Guide

#### Dart/Flutter

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// Good
class BookProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  Future<void> loadBooks() async {
    try {
      _allBooks = await _db.getAllBooks();
      notifyListeners();
    } catch (e) {
      print('Error loading books: $e');
    }
  }
}

// Bad
class bookProvider extends ChangeNotifier{
  var db=DatabaseService.instance;

  loadBooks()async{
    try{
      _allBooks=await db.getAllBooks();
      notifyListeners();
    }catch(e){
      print('Error loading books: $e');
    }
  }
}
```

**Key Points:**
- Use `lowerCamelCase` for variables and functions
- Use `UpperCamelCase` for classes
- Use `const` constructors where possible
- Prefer `final` over `var`
- Add comments for complex logic
- Keep functions small and focused

#### File Organization

```dart
// 1. Imports (grouped)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../services/database_service.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Properties
  final String title;

  // 4. Constructor
  const MyWidget({super.key, required this.title});

  // 5. Lifecycle methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // 6. Private helper methods
  void _helperMethod() {}
}
```

#### Widget Guidelines

- Extract reusable widgets into separate files
- Use const constructors for performance
- Prefer composition over inheritance
- Keep widget tree shallow

```dart
// Good
class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildCover(),
          _buildTitle(),
          _buildAuthor(),
        ],
      ),
    );
  }

  Widget _buildCover() => Image.network(book.coverImageUrl);
  Widget _buildTitle() => Text(book.title);
  Widget _buildAuthor() => Text(book.author);
}
```

### Testing Guidelines

Write tests for:
- Models and data classes
- Services and business logic
- Complex widgets
- State management

```dart
// Example test
void main() {
  group('Book Model', () {
    test('should create book from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Book',
        'author': 'Test Author',
        // ... other fields
      };

      final book = Book.fromJson(json);

      expect(book.id, '1');
      expect(book.title, 'Test Book');
    });
  });
}
```

### Documentation

- Add inline comments for complex logic
- Update README.md for major changes
- Document public APIs
- Add examples where helpful

```dart
/// Loads all books from local database and syncs with Firebase.
///
/// This method first loads books from SQLite, then fetches updates
/// from Firebase and merges them. Progress is tracked and errors
/// are handled gracefully.
///
/// Returns a list of [Book] objects or throws an exception.
Future<List<Book>> loadBooks() async {
  // Implementation
}
```

## Community

### Getting Help

- **Issues**: For bugs and feature requests
- **Discussions**: For questions and ideas
- **Email**: support@faydabook.app

### Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Special mentions in the app (with permission)

## Islamic Guidelines

When contributing content:

1. **Authenticity**: Verify sources
2. **Accuracy**: Ensure correct translations
3. **Respect**: Maintain the spiritual dignity of the content
4. **Attribution**: Give proper credit
5. **Permission**: Ensure proper licenses

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Don't hesitate to ask! Create an issue or email support@faydabook.app

---

**JazakAllahu Khairan** (May Allah reward you with goodness) for your contribution! 🌙
