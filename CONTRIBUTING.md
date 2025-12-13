# Contributing to Music Player 🎵

Thank you for your interest in contributing to Music Player! We welcome contributions from the community and are grateful for your support.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Architecture](#project-architecture)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in your interactions.

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or discriminatory comments
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.32.8 or higher
- **Dart SDK**: Version 3.8.1 or higher
- **Git**: For version control
- **Android Studio** or **Xcode**: For mobile development
- **VS Code** or **Android Studio**: Recommended IDEs

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/music_player.git
   cd music_player
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/TalebRafiepour/music_player.git
   ```

## Development Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Set Up Environment Variables

Create a `.env` file in the root directory:

```bash
SENTRY_DSN=your_sentry_dsn_here
```

> **Note**: For development, you can use a test Sentry DSN or leave it empty.

### 3. Verify Installation

Run the following commands to ensure everything is set up correctly:

```bash
# Check Flutter installation
flutter doctor

# Run code analysis
flutter analyze

# Run tests
flutter test
```

### 4. Run the Application

```bash
flutter run
```

## Project Architecture

This project follows **Clean Architecture** principles with **BLoC** pattern for state management.

### Layer Structure

```
lib/
├── core/           # Shared functionality across features
├── features/       # Feature modules (each with data, domain, presentation)
├── injection/      # Dependency injection setup
├── localization/   # i18n files
└── navigation/     # Routing configuration
```

### Feature Structure

Each feature follows this structure:

```
feature_name/
├── data/
│   ├── datasources/    # Data sources (local, remote)
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/
    ├── bloc/           # BLoC state management
    ├── pages/          # UI pages
    └── widgets/        # UI components
```

### Key Principles

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Rule**: Dependencies point inward (presentation → domain ← data)
3. **Testability**: Each layer can be tested independently
4. **Reusability**: Shared code lives in `core/`

## How to Contribute

### Finding Issues

- Check the [Issues](https://github.com/TalebRafiepour/music_player/issues) page
- Look for issues labeled `good first issue` or `help wanted`
- Comment on an issue to let others know you're working on it

### Types of Contributions

- 🐛 **Bug Fixes**: Fix reported bugs
- ✨ **New Features**: Implement new functionality
- 📝 **Documentation**: Improve or add documentation
- 🎨 **UI/UX**: Enhance user interface and experience
- ♿ **Accessibility**: Improve app accessibility
- 🌐 **Localization**: Add or improve translations
- ⚡ **Performance**: Optimize app performance
- ✅ **Tests**: Add or improve test coverage

### Creating a Branch

Always create a new branch for your work:

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create a new branch
git checkout -b <type>/<short-description>
```

**Branch naming convention:**

- `feature/add-equalizer` - New features
- `fix/player-crash-on-pause` - Bug fixes
- `docs/update-readme` - Documentation updates
- `refactor/improve-audio-service` - Code refactoring
- `test/add-playlist-tests` - Test additions
- `chore/update-dependencies` - Maintenance tasks

## Coding Standards

### Dart Style Guide

We follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide.

### Linting

This project uses `very_good_analysis` for code quality. Run analysis before committing:

```bash
flutter analyze
```

**Fix auto-fixable issues:**

```bash
dart fix --apply
```

### Code Formatting

Format your code before committing:

```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/path/to/file.dart
```

### Best Practices

#### 1. **Use Meaningful Names**

```dart
// ❌ Bad
var d = Duration(seconds: 30);
void proc() { }

// ✅ Good
var playbackDuration = Duration(seconds: 30);
void processAudioFile() { }
```

#### 2. **Keep Functions Small**

- Each function should do one thing
- Aim for functions under 20 lines
- Extract complex logic into separate functions

#### 3. **Use Constants**

```dart
// ❌ Bad
if (status == 'playing') { }

// ✅ Good
class AudioStatus {
  static const playing = 'playing';
}
if (status == AudioStatus.playing) { }
```

#### 4. **Handle Errors Properly**

```dart
// ✅ Good
try {
  await audioPlayer.play();
} on AudioException catch (e) {
  logger.error('Failed to play audio', error: e);
  emit(AudioErrorState(e.message));
} catch (e) {
  logger.error('Unexpected error', error: e);
  emit(AudioErrorState('An unexpected error occurred'));
}
```

#### 5. **Use Dependency Injection**

```dart
// ✅ Good - Use GetIt for dependency injection
final audioService = getIt<AudioService>();
```

#### 6. **Write Self-Documenting Code**

```dart
// ❌ Bad - Unclear intent
if (songs.length > 0 && currentIndex < songs.length - 1) { }

// ✅ Good - Clear intent
final hasSongs = songs.isNotEmpty;
final hasNextSong = currentIndex < songs.length - 1;
if (hasSongs && hasNextSong) { }
```

### Widget Guidelines

#### 1. **Extract Widgets**

If a widget tree is getting complex, extract it into a separate widget:

```dart
// ✅ Good
class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PreviousButton(),
        _PlayPauseButton(),
        _NextButton(),
      ],
    );
  }
}
```

#### 2. **Use Const Constructors**

```dart
// ✅ Good
const SizedBox(height: 16)
const Padding(padding: EdgeInsets.all(8))
```

#### 3. **Avoid Deep Nesting**

- Extract nested widgets into separate methods or classes
- Use builder methods for complex widgets

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

Must be one of the following:

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, missing semicolons, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvements
- **test**: Adding or correcting tests
- **chore**: Changes to build process or auxiliary tools
- **ci**: Changes to CI configuration files and scripts
- **build**: Changes that affect the build system or dependencies
- **revert**: Reverts a previous commit

### Scope (Optional)

The scope should specify the place of the commit change:

- `player` - Music player feature
- `playlist` - Playlist management
- `search` - Search functionality
- `favorites` - Favorites feature
- `settings` - Settings feature
- `ui` - User interface
- `audio` - Audio service
- `l10n` - Localization
- `deps` - Dependencies

### Subject

- Use imperative, present tense: "add" not "added" nor "adds"
- Don't capitalize the first letter
- No period (.) at the end
- Maximum 72 characters

### Body (Optional)

- Explain **what** and **why**, not **how**
- Wrap at 72 characters
- Separate from subject with a blank line

### Footer (Optional)

- Reference issues: `Closes #123`, `Fixes #456`
- Breaking changes: `BREAKING CHANGE: description`

### Examples

#### Simple Commit

```
feat(player): add shuffle mode functionality
```

#### Commit with Body

```
fix(playlist): prevent duplicate songs in playlist

When adding songs to a playlist, the app was not checking
for duplicates, resulting in the same song appearing multiple
times. Added validation to check if song already exists before
adding.

Fixes #234
```

#### Breaking Change

```
refactor(audio)!: change audio service API

BREAKING CHANGE: AudioService.play() now requires a Song object
instead of a song ID. Update all calls to pass the full Song entity.

Migration:
- Before: audioService.play(songId)
- After: audioService.play(song)
```

#### Multiple Changes

```
feat(search): add voice search support

- Integrate speech_to_text package
- Add microphone permission handling
- Implement voice search UI
- Add voice search button to search bar

Closes #189
```

### Commit Message Tips

1. **Keep commits atomic**: One logical change per commit
2. **Commit often**: Small, frequent commits are better than large ones
3. **Write clear messages**: Future you (and others) will thank you
4. **Reference issues**: Link commits to relevant issues

## Pull Request Process

### Before Submitting

1. **Sync with upstream**:
   ```bash
   git checkout main
   git pull upstream main
   git checkout your-branch
   git rebase main
   ```

2. **Run all checks**:
   ```bash
   # Format code
   dart format .
   
   # Analyze code
   flutter analyze
   
   # Run tests
   flutter test
   ```

3. **Update documentation** if needed

4. **Test on device/emulator** to ensure changes work as expected

### Creating a Pull Request

1. **Push your branch**:
   ```bash
   git push origin your-branch
   ```

2. **Open a Pull Request** on GitHub

3. **Fill out the PR template** with:
   - Clear description of changes
   - Related issue numbers
   - Screenshots/videos for UI changes
   - Testing steps
   - Checklist completion

### PR Title Format

Follow the same format as commit messages:

```
feat(player): add equalizer functionality
fix(playlist): resolve crash when deleting playlist
docs: update contribution guidelines
```

### PR Description Template

```markdown
## Description
Brief description of what this PR does.

## Related Issue
Closes #123

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- Change 3

## Screenshots/Videos
(If applicable, add screenshots or videos demonstrating the changes)

## Testing
- [ ] Tested on Android
- [ ] Tested on iOS
- [ ] Added/updated unit tests
- [ ] Added/updated widget tests
- [ ] All tests passing

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

### Review Process

1. **Automated Checks**: CI will run automatically
   - Code analysis
   - Tests
   - Build verification

2. **Code Review**: Maintainers will review your code
   - Be responsive to feedback
   - Make requested changes
   - Push updates to the same branch

3. **Approval**: Once approved, a maintainer will merge your PR

### After Your PR is Merged

1. **Delete your branch**:
   ```bash
   git branch -d your-branch
   git push origin --delete your-branch
   ```

2. **Update your local repository**:
   ```bash
   git checkout main
   git pull upstream main
   ```

## Testing Guidelines

### Test Structure

```dart
void main() {
  group('AudioPlayer', () {
    late AudioPlayer audioPlayer;
    
    setUp(() {
      audioPlayer = AudioPlayer();
    });
    
    tearDown(() {
      audioPlayer.dispose();
    });
    
    test('should play audio when play is called', () async {
      // Arrange
      final song = Song(id: '1', title: 'Test Song');
      
      // Act
      await audioPlayer.play(song);
      
      // Assert
      expect(audioPlayer.isPlaying, true);
    });
  });
}
```

### Types of Tests

#### 1. **Unit Tests**

Test individual functions and classes:

```dart
test('should calculate total duration correctly', () {
  final songs = [
    Song(duration: Duration(minutes: 3)),
    Song(duration: Duration(minutes: 4)),
  ];
  
  final total = calculateTotalDuration(songs);
  
  expect(total, Duration(minutes: 7));
});
```

#### 2. **Widget Tests**

Test UI components:

```dart
testWidgets('should display song title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SongTile(song: testSong),
    ),
  );
  
  expect(find.text('Test Song'), findsOneWidget);
});
```

#### 3. **BLoC Tests**

Test state management:

```dart
blocTest<PlayerBloc, PlayerState>(
  'emits [PlayerLoading, PlayerPlaying] when PlaySong is added',
  build: () => PlayerBloc(audioService: mockAudioService),
  act: (bloc) => bloc.add(PlaySong(testSong)),
  expect: () => [
    PlayerLoading(),
    PlayerPlaying(testSong),
  ],
);
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/player/player_bloc_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage

- Aim for **80%+ code coverage**
- All new features should include tests
- Bug fixes should include regression tests

## Documentation

### Code Documentation

#### 1. **Public APIs**

While we disable `public_member_api_docs` lint, documenting complex public APIs is still encouraged:

```dart
/// Plays the specified [song] and updates the player state.
///
/// Throws [AudioException] if the audio file cannot be loaded.
/// Returns `true` if playback started successfully.
Future<bool> playSong(Song song) async {
  // Implementation
}
```

#### 2. **Complex Logic**

Add comments for complex algorithms:

```dart
// Calculate the optimal buffer size based on available memory
// and expected audio quality. Uses exponential backoff for
// low-memory devices.
final bufferSize = _calculateBufferSize(audioQuality);
```

#### 3. **TODOs**

Use TODO comments for future improvements:

```dart
// TODO(username): Add support for gapless playback
// TODO: Optimize memory usage for large playlists
```

### README Updates

If your changes affect:
- Installation steps
- Configuration
- Features
- Architecture

Please update the README.md accordingly.

### Localization

When adding new user-facing strings:

1. **Add to ARB files**:
   - `lib/localization/app_en.arb` (English)
   - `lib/localization/app_fa.arb` (Persian)

2. **Use in code**:
   ```dart
   Text(AppLocalizations.of(context)!.playButton)
   ```

3. **Follow ARB format**:
   ```json
   {
     "playButton": "Play",
     "@playButton": {
       "description": "Label for the play button"
     }
   }
   ```

## Community

### Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Pull Requests**: For code review and contributions

### Communication Guidelines

- Be respectful and professional
- Provide context and details
- Search before asking (your question may already be answered)
- Follow up on your issues and PRs

### Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes (for significant contributions)
- README acknowledgments (for major features)

## Additional Resources

### Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

### Tools

- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
- [Very Good CLI](https://pub.dev/packages/very_good_cli)
- [Mason](https://pub.dev/packages/mason_cli) - Template generation

---

## Thank You! 🙏

Your contributions make this project better for everyone. We appreciate your time and effort!

If you have any questions, feel free to open an issue or reach out to the maintainers.

Happy coding! 🎵✨
