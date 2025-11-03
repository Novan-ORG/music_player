// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:music_player/core/domain/entities/song.dart';
// import 'package:music_player/core/mixins/playlist_management_mixin.dart';
// import 'package:music_player/core/mixins/song_actions_mixin.dart';
// import 'package:music_player/core/mixins/song_deletion_mixin.dart';
// import 'package:music_player/core/widgets/widgets.dart';
// import 'package:music_player/extensions/extensions.dart';
// import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
// import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
// import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
// import 'package:music_player/features/playlist/presentation/pages/playlists_page.dart';
// import 'package:music_player/features/search/presentation/pages/pages.dart';
// import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
// import 'package:music_player/features/songs/presentation/constants/songs_page_constants.dart';
// import 'package:music_player/features/songs/presentation/helpers/app_bar_builder.dart';
// import 'package:music_player/features/songs/presentation/helpers/songs_state_manager.dart';
// import 'package:music_player/features/songs/presentation/helpers/songs_ui_builder.dart';
// import 'package:music_player/features/songs/presentation/widgets/songs_appbar.dart';
// import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

// class SongsPage extends StatefulWidget {
//   const SongsPage({
//     super.key,
//   });

//   @override
//   State<SongsPage> createState() => _SongsPageState();
// }

// class _SongsPageState extends State<SongsPage>
//     with
//         SongSharingMixin,
//         RingtoneMixin,
//         PlaylistManagementMixin,
//         SongDeletionMixin {
//   // Getters for BLoCs
//   SongsBloc get _songsBloc => context.read<SongsBloc>();
//   MusicPlayerBloc get _musicPlayerBloc => context.read<MusicPlayerBloc>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _handleAddSongsToFavorites() => addSongsToFavorite(
//     _musicPlayerBloc.state.likedSongIds,
//   );

//   // Event handlers for playlist management
//   Future<void> _handleAddSongsToPlaylist() async {
//     if (widget.playlist == null) return;

//     final selectedSongIds = await addSongsToPlaylist(
//       widget.playlist!,
//       _playlistManager.songIds,
//     );

//     if (selectedSongIds != null && selectedSongIds.isNotEmpty) {
//       _playlistManager.addSongs(selectedSongIds);
//     }
//   }

//   void _handleRemoveSongFromPlaylist(Song song) {
//     if (widget.playlist == null) return;

//     removeSongFromPlaylist(song, widget.playlist!);
//     _playlistManager.removeSong(song.id);
//   }

//   void _handleRemoveSelectedFromPlaylist(List<Song> selectedSongs) {
//     if (widget.playlist == null) return;

//     final songIds = selectedSongs.map((song) => song.id).toSet();
//     removeSongsFromPlaylist(
//       songIds,
//       widget.playlist!,
//     );
//     _playlistManager.removeSongs(songIds);
//     _songsBloc.add(const ClearSelectionEvent());
//   }

//   // Event handlers for song actions
//   Future<void> _handleSongTap(int songIndex, List<Song> songs) async {
//     _musicPlayerBloc.add(PlayMusicEvent(songIndex, songs));
//     await Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (_) => const MusicPlayerPage(),
//       ),
//     );
//   }

//   void _handleSongLongPress(Song song) {
//     if (!_songsBloc.state.isSelectionMode) {
//       _songsBloc
//         ..add(const ToggleSelectionModeEvent())
//         ..add(SelectSongEvent(song.id));
//     }
//   }

//   // Selection handlers
//   void _handleSongSelection(Song song, bool? selected) {
//     if (selected ?? false) {
//       _songsBloc.add(SelectSongEvent(song.id));
//     } else {
//       _songsBloc.add(DeselectSongEvent(song.id));
//     }
//   }

//   void _handleShareSelectedSongs(List<Song> songs) {
//     shareSongs(
//       songs,
//       onSuccess: () {
//         _songsBloc.add(const ClearSelectionEvent());
//       },
//     );
//   }

//   // Utility methods
//   List<Song> _getFilteredSongs(SongsState state, Set<int> likedSongIds) {
//     return SongFilterManager.filterSongs(
//       allSongs: state.allSongs,
//       likedSongIds: likedSongIds,
//       playlistSongIds: _playlistManager.songIds,
//       isFavorites: widget.isFavorites,
//     );
//   }

//   List<Song> _getSelectedSongs(SongsState state) {
//     return SongFilterManager.getSelectedSongs(
//       allSongs: state.allSongs,
//       selectedIds: state.selectedSongIds,
//     );
//   }

//   // UI Builders
//   PreferredSizeWidget _buildAppBar(SongsState state, Set<int> likedSongIds) {
//     if (state.isSelectionMode) {
//       final filteredSongs = _getFilteredSongs(state, likedSongIds);
//       final selectedSongs = _getSelectedSongs(state);

//       return AppBarBuilder.buildSelectionAppBar(
//         context: context,
//         songsState: state,
//         filteredSongs: filteredSongs,
//         onAddToPlaylist: () => _handleAddToPlaylistSelection(selectedSongs),
//         onRemoveFromPlaylist: () =>
//             _handleRemoveSelectedFromPlaylist(selectedSongs),
//         onDelete: () => showDeleteSongsDialog(selectedSongs, _songsBloc),
//         onShare: () => _handleShareSelectedSongs(selectedSongs),
//         onSelectAll: () => _songsBloc.add(SelectAllSongsEvent(filteredSongs),
//         onDeselectAll: () => _songsBloc.add(const SelectAllSongsEvent([])),
//         onClearSelection: () => _songsBloc.add(const ClearSelectionEvent()),
//       );
//     }

//     return AppBarBuilder.buildMainAppBar(
//       context: context,
//       isFavorites: widget.isFavorites,
//       songCount: state.allSongs.length,
//       onShuffleAll: () => _onShufflePressed(state.allSongs),
//       onSortSongs: (SortType) {},
//       sortType: state.sortType,
//     );
//   }

//   Future<void> _handleAddToPlaylistSelection(List<Song> selectedSongs) async{
//     await PlaylistsPage.showSheet(
//       context: context,
//       songIds: selectedSongs.map((song) => song.id).toSet(),
//     );
//     _songsBloc.add(const ClearSelectionEvent());
//   }

//   Widget _buildSongsList(
//     List<Song> songs,
//     Set<int> likedSongIds,
//   ) {
//     return SongsUIBuilder.buildSongsList(
//       context: context,
//       songs: songs,
//       likedSongIds: likedSongIds,
//       itemBuilder:
//           ({
//             required context,
//             required songIndex,
//             required song,
//             required isSelected,
//           }) {
//             return SongItem(
//               song: song,
//               isLiked: likedSongIds.contains(song.id),
//               onSetAsRingtonePressed: () => setAsRingtone(song.uri),
//               onDeletePressed: () => showDeleteSongDialog(song),
//               onToggleLike: () =>
//                   _musicPlayerBloc.add(ToggleLikeMusicEvent(song.id)),
//               onAddToPlaylistPressed: () async {
//                 await PlaylistsPage.showSheet(
//                   context: context,
//                   songIds: {song.id},
//                 );
//               },
//               onSharePressed: () => shareSong(song),
//               onRemoveFromPlaylistPressed: () =>
//                   _handleRemoveSongFromPlaylist(song),
//               onLongPress: () => _handleSongLongPress(song),
//               onTap: () => _handleSongTap(songIndex, songs),
//             );
//           },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SongsBloc, SongsState>(
//       bloc: _songsBloc,
//       builder: (context, songsState) {
//         return BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
//           selector: (state) => state.favoriteSongIds,
//           builder: (context, likedSongIds) {
//             return Scaffold(
//               appBar: SongsAppbar(
//                 numOfSongs: songsState.allSongs.length,
//                 sortType: songsState.sortType,
//                 onSearchButtonPressed: _onSearchButtonPressed,
//                 onShuffleAll: () => _onShufflePressed(songsState.allSongs),
//                 onSortSongs: _onSortSongs,
//               ),
//               body: BackgroundGradient(
//                 child: _buildSongsContent(songsState, likedSongIds),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _onSearchButtonPressed() async {
//     await Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (_) => const SearchSongsPage(),
//       ),
//     );
//   }

//   Widget _buildSongsContent(SongsState songsState, Set<int> likedSongIds) {
//     // Handle loading state
//     if (songsState.status == SongsStatus.loading) {
//       return const Loading();
//     }

//     // Handle error state
//     if (songsState.status == SongsStatus.error) {
//       return SongsErrorLoading(
//         message: context.localization.errorLoadingSongs,
//         onRetry: () => _songsBloc.add(const LoadSongsEvent()),
//       );
//     }

//     // Handle empty songs
//     if (songsState.allSongs.isEmpty) {
//       return NoSongsWidget(
//         message: context.localization.noSongTryAgain,
//         onRefresh: () => _songsBloc.add(const LoadSongsEvent()),
//       );
//     }

//     return _buildMainContent(songsState, likedSongIds);
//   }

//   Widget _buildMainContent(
//     SongsState songsState,
//     Set<int> likedSongIds,
//   ) {
//     return Column(
//       children: [
//         Expanded(
//           child: SongsUIBuilder.buildRefreshWrapper(
//             onRefresh: () async => _songsBloc.add(const LoadSongsEvent()),
//             child: _buildSongsList(likedSongIds, songsState),
//           ),
//         ),

//         // Bottom spacing for mini player
//         if (_musicPlayerBloc.state.playList.isNotEmpty)
//           const SizedBox(height: SongsPageConstants.minPlayerHeight),
//       ],
//     );
//   }

//   void _onShufflePressed(List<Song> songs) {
//     _musicPlayerBloc.add(ShuffleMusicEvent(songs: songs));
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (_) => const MusicPlayerPage(),
//       ),
//     );
//   }

//   void _onSortSongs(SortType sortType) {
//     _songsBloc.add(SortSongsEvent(sortType));
//   }
// }
