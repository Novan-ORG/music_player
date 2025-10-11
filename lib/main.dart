import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/app.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      setup();
      await getIt.allReady();
      await dotenv.load();
      final sentryDSN = dotenv.get('SENTRY_DSN');

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      await SentryFlutter.init(
        (options) {
          options
            ..dsn = sentryDSN
            ..sendDefaultPii = true
            ..enableLogs = true
            ..tracesSampleRate = 1.0
            ..profilesSampleRate = 1.0;
          options.replay.sessionSampleRate = 0.1;
          options.replay.onErrorSampleRate = 1.0;
        },
        appRunner: () => runApp(SentryWidget(child: const MusicPlayerApp())),
      );
    },
    (Object error, StackTrace stack) {
      Sentry.captureException(error, stackTrace: stack);
    },
  );
}
