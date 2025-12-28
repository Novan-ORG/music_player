/// SharedPreferences keys for all persistent local storage in the app.
///
/// Stores preferences for:
/// - Favorite songs IDs
/// - Theme mode (light/dark)
/// - Sleep timer duration
/// - Current language code
/// - Pinned playlists
/// - Song sort preferences
/// - Recently played songs
sealed class PreferencesKeys {
  static const String favoriteSongs = 'favorited_songs';
  static const String themeMode = 'theme_mode';
  static const String sleepTimer = 'sleep_timer';
  static const String currentLangCode = 'current_language_code';
  static const String pinnedPlaylists = 'pinned_playlists';
  static const String playlistCoverSongsId = 'playlist_cover_songs_id';
  static const String songSortType = 'song_sort_type';
  static const String songOrderType = 'song_sort_order_type';
  static const String recentlyPlayedSongIds = 'recently_played_song_ids';
}
