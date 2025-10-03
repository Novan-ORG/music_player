import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/music_plyer/data/data.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  ///
  /// Core
  /// 
  getIt
    ..registerSingletonAsync(ObjectBox.create)
    //
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
    //
    ..registerLazySingleton(() => VolumeController.instance)

    ///
    /// MusicPlayer feature
    /// 
    // Usecases
    ..registerLazySingleton(() => GetLikedSongs(getIt()))
    ..registerLazySingleton(() => HasNextSong(getIt()))
    ..registerLazySingleton(() => HasPreviousSong(getIt()))
    ..registerLazySingleton(() => PauseSong(getIt()))
    ..registerLazySingleton(() => PlaySong(getIt()))
    ..registerLazySingleton(() => ResumeSong(getIt()))
    ..registerLazySingleton(() => SeekSong(getIt()))
    ..registerLazySingleton(() => SetLoopMode(getIt()))
    ..registerLazySingleton(() => SetShuffleEnabled(getIt()))
    ..registerLazySingleton(() => StopSong(getIt()))
    ..registerLazySingleton(() => ToggleSongLike(getIt()))
    ..registerLazySingleton(() => WatchPlayerIndex(getIt()))
    ..registerLazySingleton(() => WatchSongDuration(getIt()))
    ..registerLazySingleton(() => WatchSongPosition(getIt()))
    // Repositories
    ..registerLazySingleton(
      () => MusicPlayerRepoImpl(audioHandlerDatasource: getIt()),
    )
    // DataSources
    ..registerLazySingleton(
      () => AudioHandlerDatasourceImpl(
        audioHandler: getIt(),
        preferences: getIt(),
      ),
    );
}
