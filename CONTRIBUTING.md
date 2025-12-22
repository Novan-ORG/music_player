# Contributing to Music Player 🎵

Thank you for contributing! We welcome community contributions and appreciate your support.

## Quick Links

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Requests](#pull-requests)
- [Testing](#testing)

## Code of Conduct

We're committed to a welcoming community. Please be respectful and constructive.

**Expected Behavior**: Use inclusive language, respect differing viewpoints, and show empathy.

**Unacceptable Behavior**: Harassment, discrimination, or sharing private information without consent.

## Getting Started

### Prerequisites

- Flutter SDK 3.32.8+
- Dart SDK 3.8.1+
- Git
- Android Studio, Xcode, or VS Code

### Setup

1. Fork and clone the repository:
  ```bash
  git clone https://github.com/YOUR_USERNAME/music_player.git
  cd music_player
  git remote add upstream https://github.com/TalebRafiepour/music_player.git
  ```

2. Install dependencies:
  ```bash
  flutter pub get
  ```

3. Create `.env` file:
  ```bash
  SENTRY_DSN=your_sentry_dsn_here
  ```

4. Verify setup:
  ```bash
  flutter doctor
  flutter analyze
  flutter test
  ```

## Project Architecture

**Clean Architecture + BLoC Pattern**

```
lib/
├── core/           # Shared functionality
├── features/       # Feature modules
├── injection/      # Dependency injection
├── localization/   # i18n files
└── navigation/     # Routing
```

Each feature: `data/` → `domain/` → `presentation/`

## How to Contribute

### Finding Work

- Check [Issues](https://github.com/TalebRafiepour/music_player/issues) for `good first issue` or `help wanted`
- Comment to claim an issue

### Types of Contributions

🐛 Bug fixes • ✨ Features • 📝 Documentation • 🎨 UI/UX • ♿ Accessibility • 🌐 Localization • ⚡ Performance • ✅ Tests

### Create a Branch

```bash
git checkout main && git pull upstream main
git checkout -b <type>/<description>
```

**Naming**: `feature/add-equalizer`, `fix/player-crash`, `docs/update-readme`, `refactor/...`, `test/...`

## Coding Standards

### Format & Analysis

```bash
dart format .
flutter analyze
dart fix --apply
```

We follow [Effective Dart](https://dart.dev/guides/language/effective-dart).

### Best Practices

- Use meaningful names
- Keep functions small (< 20 lines)
- Use constants instead of magic strings
- Handle errors properly
- Use dependency injection
- Write self-documenting code
- Extract complex widgets

## Commit Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`

**Scopes**: `player`, `playlist`, `search`, `settings`, `audio`, `ui`, `l10n`, `deps`

**Examples**:
- `feat(player): add shuffle mode`
- `fix(playlist): prevent duplicate songs`

## Pull Requests

### Before Submitting

```bash
git pull upstream main
git rebase main
dart format .
flutter analyze
flutter test
```

### PR Template

- Clear description of changes
- Related issue: `Closes #123`
- Screenshots for UI changes
- Testing verification
- Checklist: style guide compliance, self-review, tests passing

## Testing

```bash
flutter test                    # Run all tests
flutter test --coverage        # Check coverage (aim for 80%+)
```

**Test types**: Unit tests, Widget tests, BLoC tests

## Documentation

- Document complex public APIs
- Update README if changes affect installation, config, or features
- Add localization strings to ARB files

## License

This project is licensed under the [MIT License](LICENSE). Contributions must comply with this license.

## Need Help?

- **Issues**: For bugs and features
- **Discussions**: For questions
- **PRs**: For code review

Thank you for contributing! 🎵✨

