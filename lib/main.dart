import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/app.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:music_player/injection/service_locator.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      setup();
      await getIt.allReady();
      runApp(const MusicPlayerApp());
    },
    (Object error, StackTrace stack) {
      Logger.error('Uncaught error: $error', error, stack);
    },
  );
}
