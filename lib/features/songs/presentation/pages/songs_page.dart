import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/play_list/presentation/pages/playlists_page.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/constants/songs_page_constants.dart';
import 'package:music_player/features/songs/presentation/helpers/app_bar_builder.dart';
import 'package:music_player/features/songs/presentation/helpers/songs_state_manager.dart';
import 'package:music_player/features/songs/presentation/helpers/songs_ui_builder.dart';
import 'package:music_player/features/songs/presentation/mixins/playlist_management_mixin.dart';
import 'package:music_player/features/songs/presentation/mixins/song_actions_mixin.dart';
import 'package:music_player/features/songs/presentation/mixins/song_deletion_mixin.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
    this.playlist,
    this.isFavorites = false,
  });

  final PlaylistModel? playlist;
  final bool isFavorites;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin {
  // Getters for BLoCs
  SongsBloc get _songsBloc => context.read<SongsBloc>();
  MusicPlayerBloc get _musicPlayerBloc => context.read<MusicPlayerBloc>();

  // State management
  late final PlaylistSongsManager _playlistManager;

  @override
  void initState() {
    super.initState();
    _playlistManager = PlaylistSongsManager(widget.playlist?.songs.toSet());
  }

  // Event handlers for playlist management
  Future<void> _handleAddSongsToPlaylist() async {
    if (widget.playlist == null) return;

    final selectedSongIds = await addSongsToPlaylist(
      widget.playlist!,
      _playlistManager.songIds,
    );

    if (selectedSongIds != null && selectedSongIds.isNotEmpty) {
      _playlistManager.addSongs(selectedSongIds);
    }
  }

  void _handleRemoveSongFromPlaylist(Song song) {
    if (widget.playlist == null) return;

    removeSongFromPlaylist(song, widget.playlist!.id, widget.playlist!.name);
    _playlistManager.removeSong(song.id);
  }

  void _handleRemoveSelectedFromPlaylist(List<Song> selectedSongs) {
    if (widget.playlist == null) return;

    final songIds = selectedSongs.map((song) => song.id).toSet();
    removeSongsFromPlaylist(
      songIds,
      widget.playlist!.id,
      widget.playlist!.name,
    );
    _playlistManager.removeSongs(songIds);
    _songsBloc.add(const ClearSelectionEvent());
  }

  // Event handlers for song actions
  Future<void> _handleSongTap(int songIndex, List<Song> songs) async {
    _musicPlayerBloc.add(PlayMusicEvent(songIndex, songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: _musicPlayerBloc,
          child: const MusicPlayerPage(),
        ),
      ),
    );
  }

  void _handleSongLongPress(Song song) {
    if (!_songsBloc.state.isSelectionMode) {
      _songsBloc
        ..add(const ToggleSelectionModeEvent())
        ..add(SelectSongEvent(song.id));
    }
  }

  // Selection handlers
  void _handleSongSelection(Song song, bool? selected) {
    if (selected ?? false) {
      _songsBloc.add(SelectSongEvent(song.id));
    } else {
      _songsBloc.add(DeselectSongEvent(song.id));
    }
  }

  void _handleShareSelectedSongs(List<Song> songs) {
    shareSongs(
      songs,
      onSuccess: () {
        _songsBloc.add(const ClearSelectionEvent());
      },
    );
  }

  // Utility methods
  List<Song> _getFilteredSongs(SongsState state, Set<int> likedSongIds) {
    return SongFilterManager.filterSongs(
      allSongs: state.allSongs,
      likedSongIds: likedSongIds,
      playlistSongIds: _playlistManager.songIds,
      isFavorites: widget.isFavorites,
    );
  }

  List<Song> _getSelectedSongs(SongsState state) {
    return SongFilterManager.getSelectedSongs(
      allSongs: state.allSongs,
      selectedIds: state.selectedSongIds,
    );
  }

  // UI Builders
  PreferredSizeWidget _buildAppBar(SongsState state, Set<int> likedSongIds) {
    if (state.isSelectionMode) {
      final filteredSongs = _getFilteredSongs(state, likedSongIds);
      final selectedSongs = _getSelectedSongs(state);

      return AppBarBuilder.buildSelectionAppBar(
        context: context,
        songsState: state,
        filteredSongs: filteredSongs,
        playlist: widget.playlist,
        onAddToPlaylist: () => _handleAddToPlaylistSelection(selectedSongs),
        onRemoveFromPlaylist: () =>
            _handleRemoveSelectedFromPlaylist(selectedSongs),
        onDelete: () => showDeleteSongsDialog(selectedSongs, _songsBloc),
        onShare: () => _handleShareSelectedSongs(selectedSongs),
        onSelectAll: () => _songsBloc.add(SelectAllSongsEvent(filteredSongs)),
        onDeselectAll: () => _songsBloc.add(const SelectAllSongsEvent([])),
        onClearSelection: () => _songsBloc.add(const ClearSelectionEvent()),
      );
    }

    return AppBarBuilder.buildMainAppBar(
      context: context,
      playlist: widget.playlist,
      isFavorites: widget.isFavorites,
    );
  }

  Future<void> _handleAddToPlaylistSelection(List<Song> selectedSongs) async {
    await PlaylistsPage.showSheet(
      context: context,
      songIds: selectedSongs.map((song) => song.id).toSet(),
    );
    _songsBloc.add(const ClearSelectionEvent());
  }

  Widget _buildSongsList(
    List<Song> songs,
    Set<int> likedSongIds,
    SongsState songsState,
  ) {
    final showAddButton = widget.playlist != null && !widget.isFavorites;

    return SongsUIBuilder.buildSongsList(
      context: context,
      songs: songs,
      likedSongIds: likedSongIds,
      songsState: songsState,
      showAddButton: showAddButton,
      onAddPressed: _handleAddSongsToPlaylist,
      itemBuilder:
          ({
            required context,
            required songIndex,
            required song,
            required isSelected,
          }) {
            return SongItem(
              song: song,
              currentPlaylist: widget.playlist,
              isLiked: likedSongIds.contains(song.id),
              isSelected: isSelected,
              isSelectionMode: songsState.isSelectionMode,
              onSetAsRingtonePressed: () => setAsRingtone(song.uri),
              onDeletePressed: () => showDeleteSongDialog(song, _songsBloc),
              onToggleLike: () =>
                  _musicPlayerBloc.add(ToggleLikeMusicEvent(song.id)),
              onAddToPlaylistPressed: () async {
                await PlaylistsPage.showSheet(
                  context: context,
                  songIds: {song.id},
                );
              },
              onSharePressed: () => shareSong(song),
              onRemoveFromPlaylistPressed: () =>
                  _handleRemoveSongFromPlaylist(song),
              onSelectionChanged: (selected) =>
                  _handleSongSelection(song, selected),
              onLongPress: () => _handleSongLongPress(song),
              onTap: () async {
                if (songsState.isSelectionMode) return;
                await _handleSongTap(songIndex, songs);
              },
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongsBloc, SongsState>(
      bloc: _songsBloc,
      builder: (context, songsState) {
        return BlocSelector<MusicPlayerBloc, MusicPlayerState, Set<int>>(
          bloc: _musicPlayerBloc,
          selector: (state) => state.likedSongIds,
          builder: (context, likedSongIds) {
            return Scaffold(
              appBar: _buildAppBar(songsState, likedSongIds),
              floatingActionButton: _buildFloatingActionButton(songsState),
              body: BackgroundGradient(
                child: _buildSongsContent(songsState, likedSongIds),
              ),
            );
          },
        );
      },
    );
  }

  Widget? _buildFloatingActionButton(SongsState songsState) {
    if (songsState.isSelectionMode) return null;

    return FloatingActionButton(
      onPressed: _navigateToSearch,
      tooltip: context.localization.searchSongs,
      child: const Icon(
        Icons.search,
        size: SongsPageConstants.fabIconSize,
        color: Colors.white,
      ),
    );
  }

  Future<void> _navigateToSearch() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }

  Widget _buildSongsContent(SongsState songsState, Set<int> likedSongIds) {
    // Handle loading state
    if (songsState.status == SongsStatus.loading) {
      return SongsUIBuilder.buildLoadingState();
    }

    // Handle error state
    if (songsState.status == SongsStatus.error) {
      return SongsUIBuilder.buildErrorState(
        context: context,
        onRetry: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    // Handle empty songs
    if (songsState.allSongs.isEmpty) {
      return SongsUIBuilder.buildEmptyState(
        context: context,
        message: context.localization.noSongTryAgain,
        onRefresh: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    final filteredSongs = _getFilteredSongs(songsState, likedSongIds);

    // Handle empty filtered songs
    if (filteredSongs.isEmpty) {
      final message = SongsUIBuilder.getEmptyMessage(
        context: context,
        isFavorites: widget.isFavorites,
        isPlaylist: widget.playlist != null,
      );

      return SongsUIBuilder.buildEmptyState(
        context: context,
        message: message,
        onRefresh: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    return _buildMainContent(songsState, filteredSongs, likedSongIds);
  }

  Widget _buildMainContent(
    SongsState songsState,
    List<Song> filteredSongs,
    Set<int> likedSongIds,
  ) {
    return Column(
      children: [
        // Top actions (shuffle, sort) - only show when not in selection mode
        if (!songsState.isSelectionMode)
          TopHeadActions(
            songCount: filteredSongs.length,
            onShuffleAll: () => _handleShuffleAll(filteredSongs),
            onSortSongs: (sortType) => _songsBloc.add(SortSongsEvent(sortType)),
            sortType: songsState.sortType,
          ),
        const SizedBox(height: SongsPageConstants.headerSpacing),

        // Songs list with pull-to-refresh
        Expanded(
          child: SongsUIBuilder.buildRefreshWrapper(
            onRefresh: () async => _songsBloc.add(const LoadSongsEvent()),
            child: _buildSongsList(filteredSongs, likedSongIds, songsState),
          ),
        ),

        // Bottom spacing for mini player
        if (_musicPlayerBloc.state.playList.isNotEmpty)
          const SizedBox(height: SongsPageConstants.minPlayerHeight),
      ],
    );
  }

  Future<void> _handleShuffleAll(List<Song> songs) async {
    _musicPlayerBloc.add(ShuffleMusicEvent(songs: songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
      ),
    );
  }
}
