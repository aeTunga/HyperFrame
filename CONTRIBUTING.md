# Contributing to HyperFrame

Thank you for considering contributing to HyperFrame! This document provides guidelines and instructions for contributing to this project.

---

## 🎯 Project Vision

HyperFrame aims to provide Flutter developers with the fastest, most efficient mobile development environment possible by leveraging native desktop performance with device frame simulation.

**Core Principles:**
- **Performance First** - Every feature should maintain blazing-fast speed
- **Developer Experience** - Simple, intuitive, and delightful to use
- **Cross-Platform** - Work seamlessly across macOS, Windows, and Linux
- **Zero Overhead** - No performance impact on production builds

---

## 🚀 Getting Started

### Development Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/aeTunga/HyperFrame.git
   cd HyperFrame
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run -d macos
   ```

4. **Run tests**
   ```bash
   flutter test
   ```

### Development Requirements

- Flutter 3.10.3 or higher
- Dart 3.10.3 or higher
- macOS 10.14+ (for macOS development)
- Windows 10+ or Linux Ubuntu 20.04+ (for those platforms)

---

## 📝 How to Contribute

### Reporting Bugs

Before creating a bug report, please:

1. **Check existing issues** to avoid duplicates
2. **Use the latest version** of HyperFrame
3. **Verify the bug** is reproducible

**Bug Report Template:**

```markdown
**Description:**
A clear description of the bug

**Steps to Reproduce:**
1. Step one
2. Step two
3. Step three

**Expected Behavior:**
What you expected to happen

**Actual Behavior:**
What actually happened

**Environment:**
- HyperFrame version:
- Flutter version:
- OS: (macOS/Windows/Linux + version)
- Device being simulated:

**Screenshots/Logs:**
If applicable, add screenshots or error logs
```

### Suggesting Enhancements

Enhancement suggestions are welcome! Please:

1. **Check existing issues** for similar suggestions
2. **Provide clear use cases** for the enhancement
3. **Explain why** it would benefit HyperFrame users

**Enhancement Template:**

```markdown
**Feature Description:**
Clear description of the proposed feature

**Use Case:**
Why is this feature needed?

**Proposed Implementation:**
How would you implement this?

**Alternatives Considered:**
What other approaches did you consider?
```

### Pull Requests

#### Before Submitting a PR

1. **Create an issue** first to discuss the change
2. **Fork the repository** and create a feature branch
3. **Follow code style** guidelines (see below)
4. **Write tests** for new functionality
5. **Update documentation** as needed

#### PR Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, maintainable code
   - Follow Flutter best practices
   - Add comments for complex logic

3. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git commit -m "feat: add amazing feature"
   ```
   
   Use conventional commit messages:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation changes
   - `style:` - Code style changes
   - `refactor:` - Code refactoring
   - `test:` - Test additions/changes
   - `chore:` - Maintenance tasks

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Provide clear description of changes
   - Reference related issues
   - Add screenshots for UI changes

---

## 📐 Code Style Guidelines

### Dart Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

- Use 2 spaces for indentation
- Maximum line length: 80 characters (flexible for readability)
- Use trailing commas for better diffs
- Use `const` constructors where possible

### File Organization

```dart
// 1. Dart imports
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:provider/provider.dart';

// 4. Relative imports
import '../widgets/my_widget.dart';
```

### Widget Guidelines

- **StatelessWidget** for static UI
- **StatefulWidget** only when state is needed
- Extract complex widgets into separate files
- Use `const` constructors liberally

### Example:

```dart
/// Widget documentation
/// 
/// Describes what the widget does
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(title),
    );
  }
}
```

---

## 🧪 Testing Guidelines

### Test Requirements

- **Unit tests** for business logic
- **Widget tests** for UI components
- **Integration tests** for critical flows

### Writing Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperframe/widgets/my_widget.dart';

void main() {
  group('MyWidget', () {
    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyWidget(title: 'Test'),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

---

## 📚 Documentation Guidelines

### Code Documentation

- Add doc comments (`///`) for public APIs
- Include usage examples for complex features
- Explain **why**, not just **what**

### README Updates

When adding features:
- Update feature list
- Add usage examples
- Update screenshots if UI changes

---

## 🔍 Code Review Process

All PRs go through code review:

1. **Automated checks** must pass:
   - `flutter analyze` (no errors)
   - `flutter test` (all tests pass)
   - Code style compliance

2. **Manual review** checks:
   - Code quality and readability
   - Test coverage
   - Documentation completeness
   - Performance impact

3. **Approval required** from maintainers

---

## 🎨 Design Guidelines

### Material 3 Design

- Follow Material 3 design principles
- Use theme colors from `ColorScheme`
- Maintain consistency with existing UI

### Accessibility

- Support screen readers
- Ensure sufficient color contrast
- Add semantic labels

### Performance

- Avoid unnecessary rebuilds
- Use `const` constructors
- Profile performance for heavy operations

---

## 🌟 Recognition

Contributors will be:
- Listed in GitHub contributors
- Mentioned in release notes
- Added to CONTRIBUTORS.md (for significant contributions)

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## 💬 Questions?

- **General questions:** [GitHub Discussions](https://github.com/aeTunga/HyperFrame/discussions)
- **Bug reports:** [GitHub Issues](https://github.com/aeTunga/HyperFrame/issues)

---

## 🙏 Thank You!

Your contributions make HyperFrame better for everyone. Thank you for taking the time to contribute!

**Happy coding!** 🚀
