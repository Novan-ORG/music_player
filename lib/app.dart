import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/domain/usecases/usecases.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/core/theme/app_themes.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:music_player/features/home/presentation/pages/pages.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/playlist.dart';
import 'package:music_player/features/settings/presentation/presentation.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:music_player/localization/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPlayerApp extends StatefulWidget {
  const MusicPlayerApp({super.key});

  @override
  State<MusicPlayerApp> createState() => _MusicPlayerAppState();
}

class _MusicPlayerAppState extends State<MusicPlayerApp> {
  bool hasAudioPermission = false;
  bool isLoading = false;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  Future<void> requestPermission() async {
    setState(() {
      isLoading = true;
    });
    final result = await getIt<EnsureMediaPermission>().call();
    setState(() {
      isLoading = false;
      if (result.isSuccess) {
        hasAudioPermission = true;
      } else {
        hasAudioPermission = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SongsBloc(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          )..add(const LoadSongsEvent()),
        ),
        BlocProvider(
          create: (_) => MusicPlayerBloc(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          ),
        ),
        BlocProvider(
          create: (_) => PlayListBloc(
            getIt.get<RenamePlaylist>(),
            getIt.get<GetAllPlaylists>(),
            getIt.get<CreatePlaylist>(),
            getIt.get<DeletePlaylistWithUndo>(),
            getIt.get<AddSongsToPlaylist>(),
            getIt.get<RemoveSongsFromPlaylist>(),
            getIt.get<GetPlaylistById>(),
            getIt.get<GetPlaylistSongs>(),
            getIt.get<CommandManager>(),
          ),
        ),
        BlocProvider(
          create: (_) => FavoriteSongsBloc(
            getFavoriteSongs: getIt(),
            addFavoriteSong: getIt(),
            removeFavoriteSong: getIt(),
            toggleFavoriteSong: getIt(),
            clearAllFavorites: getIt(),
          )..add(const LoadFavoriteSongsEvent()),
        ),
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
            navigatorObservers: [
              SentryNavigatorObserver(),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: isLoading
                ? const BackgroundGradient(child: Loading())
                : hasAudioPermission
                ? const HomePage()
                : GrantAudioPermission(
                    onGrantPermission: requestPermission,
                  ),
          );
        },
      ),
    );
  }
}
