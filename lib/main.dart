import 'package:flutter/material.dart';
import 'package:music_player/app.dart';
import 'package:music_player/injection/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await getIt.allReady();
  runApp(const MusicPlayerApp());
}
