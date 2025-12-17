import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/app.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Application entry point.
///
/// Initializes the app with error handling, dependency injection,
/// environment configuration, and crash reporting via Sentry.
///
/// All uncaught errors are logged and reported to Sentry for monitoring.
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
      final sentryDSN = dotenv.get('SENTRY_DSN');

      // Initialize Sentry for crash reporting
      await SentryFlutter.init(
        (options) {
          options
            ..dsn = sentryDSN
            ..tracesSampleRate = 1.0
            ..sendDefaultPii = true
            ..debug = true
            ..profilesSampleRate = 1.0;
        },
        appRunner: () => runApp(SentryWidget(child: const MusicPlayerApp())),
      );
    },
    (Object error, StackTrace stack) {
      // Catch and report all uncaught errors
      Sentry.captureException(
        error,
        stackTrace: stack,
      );
      Logger.error('Uncaught error: $error', error, stack);
    },
  );
}
