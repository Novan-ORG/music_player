import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/app.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:music_player/injection/service_locator.dart';

/// Application entry point.
///
/// Initializes the app with error handling, dependency injection,
/// environment configuration, and top-level error logging.
void main() {
  runZonedGuarded(
    () async {
      // Initialize Flutter binding and preserve splash screen
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Setup dependency injection
      setup();
      await getIt.allReady();

      // Load environment variables
      await dotenv.load();
      runApp(const MusicPlayerApp());
    },
    (Object error, StackTrace stack) {
      Logger.error('Uncaught error: $error', error, stack);
    },
  );
}
