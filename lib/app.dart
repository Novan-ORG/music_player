import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:music_player/core/services/database/objectbox.dart';
import 'package:music_player/core/theme/app_themes.dart';
import 'package:music_player/features/home/presentation/view/home_page.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/play_list/presentation/bloc/play_list_bloc.dart';
import 'package:music_player/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:music_player/localization/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SongsBloc()..add(const LoadSongsEvent())),
        BlocProvider(
          create: (_) => MusicPlayerBloc(
            getIt.get<MAudioHandler>(),
            getIt.get<SharedPreferences>(),
          ),
        ),
        BlocProvider(create: (_) => PlayListBloc(getIt.get<ObjectBox>())),
        BlocProvider(
          create: (_) => SettingsBloc(
            getIt.get<SharedPreferences>(),
            getIt.get<MAudioHandler>(),
            PlatformDispatcher.instance.locale.languageCode,
          ),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Music Player',
            darkTheme: darkTheme,
            theme: lightTheme,
            themeMode: state.currentTheme,
            debugShowCheckedModeBanner: false,
            locale: state.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
