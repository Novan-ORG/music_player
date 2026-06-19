# Music Player

An offline Flutter music player focused on fast local playback, polished UI, and a smooth day-to-day listening flow. The app supports playlists, favorites, search, sleep timer, restored playback sessions, and now folder-based browsing for songs stored on the device.

![PR Checks](https://github.com/Novan-ORG/music_player/actions/workflows/pr-checks.yml/badge.svg)
![Build Artifacts](https://github.com/Novan-ORG/music_player/actions/workflows/publish-new-version.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## Version

Current app version: `1.0.0+13`

## Highlights In 1.0.0

- Browse your library by `Songs`, `Albums`, `Artists`, and `Folders`
- Open any folder and see every song inside it
- Enjoy a refreshed home, library, search, playlist, settings, and player experience
- Resume your last playback session when you reopen the app
- Use multi-select song actions, better snackbars, and cleaner bottom sheets
- Switch between English and Persian with localized app copy

## Features

- Local offline playback from device storage
- Library browsing by songs, albums, artists, and folders
- Folder view with song counts per folder
- Full search flow with quick insights and cleaner empty/error states
- Favorites management
- Playlist creation, rename, pinning, and song management
- Recently played support
- Restored playback session after reopening the app
- Mini player, full player, queue, shuffle, repeat, and volume controls
- Sleep timer
- Voice search
- Share songs and manage song actions from contextual menus
- Multi-language support for English and Persian
- Modern responsive UI across compact and larger layouts

## Screenshots

| | | |
|---|---|---|
| ![All Songs](screenshots/AllSongs.jpg) | ![Language](screenshots/Language.jpg) | ![Mini Player](screenshots/MiniPlayer.jpg) |
| ![Music Player](screenshots/MusicPlayer.jpg) | ![Playlist](screenshots/PlayList.jpg) | ![Queue](screenshots/Queue.jpg) |
| ![Sleep Timer](screenshots/SleepTimer.jpg) | ![Themes](screenshots/Themes.jpg) | |

## Tech Stack

### Core

- Flutter `3.32.8` via `fvm`
- Dart `3.8.1`
- `flutter_bloc` for state management
- `get_it` for dependency injection
- `equatable` for value equality

### Audio And Device Access

- `just_audio`
- `audio_service`
- `audio_session`
- `on_audio_query_pluse`
- `permission_handler`
- `volume_controller`

### UI And Utilities

- `shared_preferences`
- `speech_to_text`
- `share_plus`
- `package_info_plus`
- `scrollable_positioned_list`
- `duration_picker`

## Project Structure

```text
lib/
├── core/
│   ├── commands/
│   ├── constants/
│   ├── data/
│   ├── domain/
│   ├── mixins/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   ├── views/
│   └── widgets/
├── features/
│   ├── favorite/
│   ├── home/
│   ├── music_plyer/
│   ├── playlist/
│   ├── search/
│   ├── settings/
│   └── songs/
├── injection/
├── localization/
└── main.dart
```

## Architecture

The app follows a clean feature-first structure with:

- Presentation layer for pages, widgets, and BLoCs
- Domain layer for entities, repositories, and use cases
- Data layer for datasource and repository implementations

Patterns used across the project:

- BLoC
- Repository
- Dependency Injection
- Command pattern for undoable actions

## Getting Started

### Requirements

- `fvm`
- Flutter `3.32.8`
- Dart `3.8.1`
- Android Studio or VS Code
- Android device or emulator

### Setup

1. Clone the repository

```bash
git clone https://github.com/Novan-ORG/music_player.git
cd music_player
```

2. Install the pinned Flutter SDK

```bash
fvm install
```

3. Get packages

```bash
fvm flutter pub get
```

4. Create the environment file

```bash
touch .env
```

5. Run the app

```bash
fvm flutter run
```

## Localization

The app currently supports:

- English
- Persian

When adding new strings:

```bash
fvm flutter gen-l10n
```

## Quality Checks

Run the main checks with `fvm`:

```bash
fvm flutter analyze
fvm flutter test
```

## Build

```bash
fvm flutter build apk --release
fvm flutter build appbundle --release
```

The project is primarily optimized for Android.

## Permissions

- Storage and media access for reading device audio files
- Microphone for optional voice search
- Extra storage management permission when deleting songs from device storage

## Downloads

| Platform | Download |
|---|---|
| GitHub Releases | [Latest release](https://github.com/Novan-ORG/music_player/releases/latest) |
| CafeBazar | [com.taleb.music_player](https://cafebazaar.ir/app/com.taleb.music_player) |
| Myket | [com.taleb.music_player](https://myket.ir/app/com.taleb.music_player) |

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a branch
3. Make your changes
4. Run `fvm flutter analyze` and `fvm flutter test`
5. Open a pull request

More details are available in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

## Author And Contributors

Author:

- [Taleb Rafiepour](https://github.com/TalebRafiepour)

Contributors:

- [@elhamebrahimpour](https://github.com/elhamebrahimpour)
- [@carozamani](https://github.com/carozamani)

## Support

- Report issues: [GitHub Issues](https://github.com/Novan-ORG/music_player/issues)
- Follow releases: [GitHub Releases](https://github.com/Novan-ORG/music_player/releases)

Made by the NOVAN team with Flutter.
