# Screenshots Directory

This directory should contain screenshots of the Music Player application.

## Required Screenshots

Please add the following screenshots to this directory:

1. **home_screen.png** - The main home screen showing the music library
2. **music_player.png** - The music player interface with controls
3. **playlists.png** - The playlists management screen
4. **search.png** - The search functionality with results
5. **settings.png** - The settings screen

## Screenshot Guidelines

- Use a consistent device/emulator for all screenshots
- Recommended resolution: 1080x2400 or similar mobile aspect ratio
- Ensure the app has sample data loaded for better presentation
- Capture screenshots in both light and dark mode if applicable
- Use PNG format for best quality

## How to Take Screenshots

### On Android Emulator/Device:
```bash
# Run the app
flutter run

# Take screenshot using adb
adb exec-out screencap -p > screenshots/home_screen.png
```

### On iOS Simulator:
```bash
# Run the app
flutter run

# Take screenshot (Cmd+S in simulator)
# Or use command line:
xcrun simctl io booted screenshot screenshots/home_screen.png
```

### Using Flutter DevTools:
1. Run the app with `flutter run`
2. Open Flutter DevTools
3. Use the screenshot feature in DevTools
