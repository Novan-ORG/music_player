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
import 'package:music_player/features/playlist/domain/usecases/get_pinned_playlist.dart';
import 'package:music_player/features/playlist/domain/usecases/pin_playlist_by_id.dart';
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
  _setupCore();

  ///
  /// MusicPlayer feature
  ///
  _setupMusicPlayerFeature();

  ///
  /// Songs page feature
  ///
  _setupSongsFeature();

  ///
  /// Playlist feature
  ///
  _setupPlaylistFeature();

  ///
  ///
  /// Favorites feature
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
    ..registerLazySingleton(() => GetSongsSortType(getIt.get()))
    ..registerLazySingleton(() => SaveSongsSortType(getIt.get()))
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
    ..registerLazySingleton(() => SetLoopMode(getIt.get()))
    ..registerLazySingleton(() => SetShuffleEnabled(getIt.get()))
    ..registerLazySingleton(() => StopSong(getIt.get()))
    ..registerLazySingleton(() => WatchPlayerIndex(getIt.get()))
    ..registerLazySingleton(() => WatchSongDuration(getIt.get()))
    ..registerLazySingleton(() => WatchSongPosition(getIt.get()))
    // Repositories
    ..registerLazySingleton<MusicPlayerRepository>(
      () => MusicPlayerRepoImpl(audioHandlerDatasource: getIt.get()),
    )
    // Data Sources
    ..registerLazySingleton<AudioHandlerDatasource>(
      () => AudioHandlerDatasourceImpl(
        audioHandler: getIt.get(),
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
