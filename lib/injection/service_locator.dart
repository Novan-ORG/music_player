import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/domain/usecases/usecases.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:music_player/features/music_plyer/data/data.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';
import 'package:music_player/features/playlist/data/data.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/songs/data/data.dart';
import 'package:music_player/features/songs/domain/domain.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

/// Global service locator instance for dependency injection.
///
/// Uses GetIt for dependency injection throughout the application.
/// All dependencies are registered in the [setup] function.
final GetIt getIt = GetIt.instance;

/// Initializes all dependencies for the application.
///
/// This function registers all repositories, use cases, services, and
/// other dependencies with the service locator. It should be called
/// once at app startup before any dependencies are accessed.
///
/// Dependencies are organized by feature:
/// - Core services (audio, permissions, storage)
/// - Music player feature
/// - Songs feature
/// - Playlist feature
/// - Favorites feature
void setup() {
  // Core services and utilities
  _setupCore();

  // Feature-specific dependencies
  _setupMusicPlayerFeature();
  _setupSongsFeature();
  _setupPlaylistFeature();
  _setupFavoriteSongsFeature();
}

void _setupPlaylistFeature() {
  /// Repositories
  getIt
    ..registerLazySingleton<PlaylistDatasource>(
      () => PlaylistDatasourceImpl(getIt.get(), getIt.get()),
    )
    ..registerLazySingleton<PlaylistRepository>(
      () => PlaylistRepositoryImpl(getIt.get()),
    )
    ///
    // Usecases
    ..registerLazySingleton(() => RenamePlaylist(getIt.get()))
    ..registerLazySingleton(
      () => DeletePlaylistWithUndo(getIt.get(), getIt.get()),
    )
    ..registerLazySingleton(() => GetAllPlaylists(getIt.get()))
    ..registerLazySingleton(() => GetPlaylistById(getIt.get()))
    ..registerLazySingleton(() => CreatePlaylist(getIt.get()))
    ..registerLazySingleton(() => AddSongsToPlaylist(getIt.get()))
    ..registerLazySingleton(() => RemoveSongsFromPlaylist(getIt.get()))
    ..registerLazySingleton(() => GetPlaylistSongs(getIt.get()))
    ..registerLazySingleton(() => GetRecentlyPlayedSongs(getIt.get()))
    ..registerLazySingleton(() => GetPlaylistCoverSongId(getIt.get()))
    ..registerLazySingleton(() => InitializePlaylistCovers(getIt.get()))
    ..registerLazySingleton(() => PinPlaylistById(getIt.get()))
    ..registerLazySingleton(() => GetPinnedPlaylists(getIt.get()));
}

void _setupSongsFeature() {
  // Usecases
  getIt
    ..registerLazySingleton(CommandManager.new)
    ..registerLazySingleton(() => QuerySongs(getIt.get()))
    ..registerLazySingleton(() => QuerySongsFrom(getIt.get()))
    ..registerLazySingleton(() => QueryAlbums(getIt.get()))
    ..registerLazySingleton(() => QueryArtists(getIt.get()))
    ..registerLazySingleton(() => GetSongsSortConfig(getIt.get()))
    ..registerLazySingleton(() => SaveSongsSortConfig(getIt.get()))
    ..registerLazySingleton(() => DeleteSongWithUndo(getIt.get(), getIt.get()))
    // Repositories
    ..registerLazySingleton<SongsRepository>(
      () => SongsRepoImpl(songsDatasource: getIt.get()),
    )
    // Datasources
    ..registerLazySingleton<SongsDatasource>(
      () => SongsDatasourceImpl(
        onAudioQuery: getIt.get(),
        preferences: getIt.get(),
      ),
    );
}

void _setupCore() {
  getIt
    ..registerLazySingleton(
      () {
        return OnAudioQuery()..setLogConfig(
          LogConfig(logType: LogType.ERROR, showDetailedLog: true),
        );
      },
    )
    ..registerLazySingleton(() => EnsureMediaPermission(getIt.get()))
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
    ..registerLazySingleton(() => VolumeController.instance);
}

void _setupMusicPlayerFeature() {
  // Usecases
  getIt
    ..registerLazySingleton(() => HasNextSong(getIt.get()))
    ..registerLazySingleton(() => HasPreviousSong(getIt.get()))
    ..registerLazySingleton(() => PauseSong(getIt.get()))
    ..registerLazySingleton(() => PlaySong(getIt.get()))
    ..registerLazySingleton(() => ResumeSong(getIt.get()))
    ..registerLazySingleton(() => SeekSong(getIt.get()))
    ..registerLazySingleton(() => SkipToNext(getIt.get()))
    ..registerLazySingleton(() => SkipToPrevious(getIt.get()))
    ..registerLazySingleton(() => SetLoopMode(getIt.get()))
    ..registerLazySingleton(() => SetShuffleEnabled(getIt.get()))
    ..registerLazySingleton(() => StopSong(getIt.get()))
    ..registerLazySingleton(() => WatchPlayerIndex(getIt.get()))
    ..registerLazySingleton(() => WatchSongDuration(getIt.get()))
    ..registerLazySingleton(() => WatchSongPosition(getIt.get()))
    ..registerLazySingleton(() => AddToRecentlyPlayed(getIt.get()))
    // Repositories
    ..registerLazySingleton<MusicPlayerRepository>(
      () => MusicPlayerRepoImpl(audioHandlerDatasource: getIt.get()),
    )
    // Data Sources
    ..registerLazySingleton<AudioHandlerDatasource>(
      () => AudioHandlerDatasourceImpl(
        audioHandler: getIt.get(),
        preferences: getIt.get(),
      ),
    );
}

void _setupFavoriteSongsFeature() {
  getIt
    /// Use cases
    ..registerLazySingleton(() => GetFavoriteSongs(getIt.get()))
    ..registerLazySingleton(() => AddFavoriteSong(getIt.get()))
    ..registerLazySingleton(() => RemoveFavoriteSong(getIt.get()))
    ..registerLazySingleton(() => ToggleFavoriteSong(getIt.get()))
    ..registerLazySingleton(() => ClearAllFavorites(getIt.get()))
    /// Repository
    ..registerLazySingleton<FavoriteSongsRepository>(
      () => FavoriteSongsRepoImpl(datasource: getIt.get()),
    )
    /// Data source
    ..registerLazySingleton<FavoriteSongsDatasource>(
      () => FavoriteSongsDatasourceImpl(
        preferences: getIt.get(),
        audioQuery: getIt.get(),
      ),
    );
}
