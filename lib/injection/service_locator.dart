import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/music_plyer/data/data.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';
import 'package:music_player/features/play_list/domain/usecases/usecases.dart';
import 'package:music_player/features/songs/data/data.dart';
import 'package:music_player/features/songs/domain/domain.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  ///
  /// Core
  ///
  getIt
    ..registerSingletonAsync(ObjectBox.create)
    ..registerLazySingleton(OnAudioQuery.new)
    ..registerLazySingleton<AudioPlayer>(AudioPlayer.new)
    ..registerSingletonAsync<MAudioHandler>(
      () => AudioService.init(
        builder: () => MAudioHandler(getIt.get<AudioPlayer>()),
        config: const AudioServiceConfig(
          androidNotificationChannelId:
              'com.example.music_palyer.channel.audio',
          androidNotificationChannelName: 'Music Player',
          androidNotificationOngoing: true,
        ),
      ),
    )
    //
    ..registerSingletonAsync<SharedPreferences>(
      SharedPreferences.getInstance,
    )
    ..registerLazySingleton(() => VolumeController.instance)
    ///
    /// MusicPlayer feature
    ///
    // Usecases
    ..registerLazySingleton(() => GetLikedSongs(getIt.get()))
    ..registerLazySingleton(() => HasNextSong(getIt.get()))
    ..registerLazySingleton(() => HasPreviousSong(getIt.get()))
    ..registerLazySingleton(() => PauseSong(getIt.get()))
    ..registerLazySingleton(() => PlaySong(getIt.get()))
    ..registerLazySingleton(() => ResumeSong(getIt.get()))
    ..registerLazySingleton(() => SeekSong(getIt.get()))
    ..registerLazySingleton(() => SetLoopMode(getIt.get()))
    ..registerLazySingleton(() => SetShuffleEnabled(getIt.get()))
    ..registerLazySingleton(() => StopSong(getIt.get()))
    ..registerLazySingleton(() => ToggleSongLike(getIt.get()))
    ..registerLazySingleton(() => WatchPlayerIndex(getIt.get()))
    ..registerLazySingleton(() => WatchSongDuration(getIt.get()))
    ..registerLazySingleton(() => WatchSongPosition(getIt.get()))
    // Repositories
    ..registerLazySingleton<MusicPlayerRepository>(
      () => MusicPlayerRepoImpl(audioHandlerDatasource: getIt.get()),
    )
    // DataSources
    ..registerLazySingleton<AudioHandlerDatasource>(
      () => AudioHandlerDatasourceImpl(
        audioHandler: getIt.get(),
        preferences: getIt.get(),
      ),
    )
    ///
    /// Songs page feature
    ///
    // Usecases
    ..registerLazySingleton(CommandManager.new)
    ..registerLazySingleton(() => QuerySongs(getIt.get()))
    ..registerLazySingleton(() => DeleteSongWithUndo(getIt.get(), getIt.get()))
    // Repositories
    ..registerLazySingleton<SongsRepository>(
      () => SongsRepoImpl(songsDatasource: getIt.get()),
    )
    // Datasources
    ..registerLazySingleton<SongsDatasource>(
      () => SongsDatasourceImpl(onAudioQuery: getIt.get()),
    )
    ///
    /// Playlist feature
    ///
    // Usecases
    ..registerLazySingleton(
      () => DeletePlaylistWithUndo(getIt.get(), getIt.get()),
    );

  ///
  ///
  ///
}
