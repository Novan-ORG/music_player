import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:luciq_flutter/luciq_flutter.dart';
import 'package:music_player/app.dart';
import 'package:music_player/injection/service_locator.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      setup();
      await getIt.allReady();
      await dotenv.load();
      final luciqToken = dotenv.get('LUCIQ_TOKEN');
      await Luciq.init(
        token: luciqToken,
        invocationEvents: [],
        debugLogsLevel: LogLevel.none,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      runApp(const MusicPlayerApp());
    },
    CrashReporting.reportCrash,
  );
}
