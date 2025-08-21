// App router, theme, etc.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:music_player/features/home/presentation/pages/home_page.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SongsBloc()..add(const LoadSongsEvent())),
        BlocProvider(
          create: (_) => MusicPlayerBloc(
            getIt.get<MAudioHandler>(),
            getIt.get<SharedPreferences>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );
  }
}
