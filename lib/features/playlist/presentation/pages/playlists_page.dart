import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/mixins/playlist_management_mixin.dart';
import 'package:music_player/core/widgets/app_modal_bottom_sheet.dart';
import 'package:music_player/core/widgets/app_route_bloc_scope.dart';
import 'package:music_player/core/widgets/app_snackbar.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
import 'package:music_player/core/widgets/loading.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/domain/entities/entities.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/injection/service_locator.dart';

/// Main playlists management page.
///
/// Features:
/// - List all playlists
/// - Create new playlist
/// - Delete/rename playlist
/// - Pin/unpin playlists
/// - Selection mode for adding songs
class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({
    super.key,
    this.isSelectionMode = false,
    this.songIds,
  });

  final bool isSelectionMode;
  final Set<int>? songIds;

  static Future<List<int>?> showSheet({
    required BuildContext context,
    Set<int>? songIds,
  }) async {
    final playlistBloc = context.read<PlayListBloc>();

    final selectedPlaylistIds = await showAppModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: playlistBloc,
          child: _PlaylistSelectionSheet(songIds: songIds),
        );
      },
    );

    if (selectedPlaylistIds == null ||
        selectedPlaylistIds.isEmpty ||
        songIds == null ||
        songIds.isEmpty) {
      return selectedPlaylistIds;
    }

    final completion = playlistBloc.stream.firstWhere(
      (state) =>
          state.status == PlayListStatus.loaded ||
          state.status == PlayListStatus.error,
    );

    playlistBloc.add(
      AddSongsToPlaylistsEvent(songIds, selectedPlaylistIds),
    );

    final result = await completion;
    if (!context.mounted) {
      return selectedPlaylistIds;
    }

    if (result.status == PlayListStatus.loaded) {
      final selectedNames = result.playLists
          .where((playlist) => selectedPlaylistIds.contains(playlist.id))
          .map((playlist) => playlist.name)
          .toList();

      AppSnackBar.showSuccess(
        context,
        title: context.localization.addToPlaylist,
        message: _buildSelectionMessage(
          context,
          songCount: songIds.length,
          names: selectedNames,
        ),
        icon: Icons.playlist_add_check_circle_rounded,
      );
    } else {
      AppSnackBar.showError(
        context,
        title: context.localization.error,
        message: result.errorMessage ?? context.localization.playlistPage,
      );
    }

    return selectedPlaylistIds;
  }

  static String _buildSelectionMessage(
    BuildContext context, {
    required int songCount,
    required List<String> names,
  }) {
    final songLabel = songCount == 1
        ? context.localization.song
        : context.localization.songs;
    final playlistLabel = names.isEmpty
        ? context.localization.playlist
        : names.join(', ');

    return '$songCount $songLabel • $playlistLabel';
  }

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistSelectionSheet extends StatelessWidget {
  const _PlaylistSelectionSheet({this.songIds});

  final Set<int>? songIds;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.size.width > mediaQuery.size.height;
    final maxWidth = mediaQuery.size.width >= 900
        ? 760.0
        : mediaQuery.size.width;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: isLandscape ? 0.94 : 0.86,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: _SelectionSheetSurface(
              child: PlaylistContentView(
                isSelectionMode: true,
                songIds: songIds,
                onCloseBottomSheet: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionSheetSurface extends StatelessWidget {
  const _SelectionSheetSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.34 : 0.15),
            blurRadius: 28,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: child,
      ),
    );
  }
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  static const double _headerCollapseDistance = 180;

  double _headerCollapseProgress = 0;

  Future<void> _showCreatePlaylistSheet() => CreatePlaylistSheet.show(context);

  bool _handlePlaylistScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    final nextProgress = (notification.metrics.pixels / _headerCollapseDistance)
        .clamp(0.0, 1.0);
    if ((nextProgress - _headerCollapseProgress).abs() < 0.01 || !mounted) {
      return false;
    }

    setState(() {
      _headerCollapseProgress = nextProgress;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.2),
              const Color(0xFF00BFA6).withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0, 0.2, 0.48, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              PlaylistHomeHeader(
                collapseProgress: _headerCollapseProgress,
                onCreatePressed: _showCreatePlaylistSheet,
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: _handlePlaylistScroll,
                  child: PlaylistContentView(
                    isSelectionMode: false,
                    onCreatePressed: _showCreatePlaylistSheet,
                    collapseProgress: _headerCollapseProgress,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistContentView extends StatefulWidget {
  const PlaylistContentView({
    required this.isSelectionMode,
    super.key,
    this.songIds,
    this.onCloseBottomSheet,
    this.onCreatePressed,
    this.collapseProgress = 0,
    this.padding = const EdgeInsets.all(16),
  });

  final bool isSelectionMode;
  final Set<int>? songIds;
  final VoidCallback? onCloseBottomSheet;
  final VoidCallback? onCreatePressed;
  final double collapseProgress;
  final EdgeInsets padding;

  @override
  State<PlaylistContentView> createState() => _PlaylistContentViewState();
}

class _PlaylistContentViewState extends State<PlaylistContentView>
    with PlaylistManagementMixin {
  @override
  void initState() {
    super.initState();
    context.read<PlayListBloc>().add(LoadPlayListsEvent());
  }

  List<Playlist> _extractPinnedPlaylists(
    List<Playlist> allPlaylists,
    List<PinPlaylist> pinnedMeta,
  ) {
    final playlistById = <int, Playlist>{
      for (final p in allPlaylists) p.id: p,
    };

    final result = <Playlist>[];

    for (final meta in pinnedMeta) {
      final playlist = playlistById[meta.playlistId];
      if (playlist != null && playlist.id != 0) {
        result.add(playlist);
      }
    }

    return result;
  }

  Future<void> _refreshPlaylists() async {
    final bloc = context.read<PlayListBloc>();
    final completed = bloc.stream.firstWhere(
      (state) => state.status != PlayListStatus.loading,
    );

    bloc.add(LoadPlayListsEvent());
    await completed;
  }

  void _handlePinPlaylist(Playlist playlist) {
    context.read<PlayListBloc>().add(
      PinnedPlaylistEvent(playlist.id),
    );
  }

  Future<void> _handleAddMusicToPlaylist(Playlist playlist) async {
    final detailsBloc = PlaylistDetailsBloc(
      playlist: playlist,
      getPlaylistSongs: getIt.get(),
      getRecentlyPlayedSongs: getIt.get(),
    )..add(const GetPlaylistSongsEvent());

    try {
      await detailsBloc.stream.firstWhere(
        (state) => state.status != PlaylistDetailsStatus.loading,
      );

      Set<int>? currentSongIds;
      final state = detailsBloc.state;
      if (state.status == PlaylistDetailsStatus.success) {
        currentSongIds = state.songs.map((song) => song.id).toSet();
      }

      await addSongsToPlaylist(playlist, currentSongIds);
    } finally {
      await detailsBloc.close();
    }
  }

  void _navigateToPlaylistDetails(Playlist playlist) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppRouteBlocScope.fromContext(
          context: context,
          child: PlaylistDetailsPage(
            playlistModel: playlist,
          ),
        ),
      ),
    );
  }

  Widget _buildSheetHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                      const Color(0xFF00BFA6).withValues(alpha: 0.14),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.playlist_add_check_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.addSongsToPlaylist,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.localization.selectPlaylist,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed:
                    widget.onCloseBottomSheet ??
                    () => Navigator.of(context).pop(),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PlayListState state, ThemeData theme) {
    if (state.status == PlayListStatus.loading) {
      return const Loading();
    } else if (state.status == PlayListStatus.error) {
      return AppStateView(
        eyebrow: context.localization.playlists,
        title: context.localization.error,
        message: state.errorMessage ?? context.localization.playlistPage,
        actionLabel: context.localization.refresh,
        onAction: _refreshPlaylists,
        accentColor: theme.colorScheme.primary,
      );
    } else if (state.status == PlayListStatus.initial) {
      return const Loading();
    } else {
      final pinnedMeta = state.pinnedPlaylists;
      final allPlaylists = state.playLists;
      final pinnedPlaylists = _extractPinnedPlaylists(
        allPlaylists,
        pinnedMeta,
      );

      if (widget.isSelectionMode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSheetHeader(theme),
            Expanded(
              child: AllPlaylistView(
                playlists: allPlaylists,
                pinnedMeta: pinnedMeta,
                isSelectionMode: widget.isSelectionMode,
                songIds: widget.songIds,
                onCreatePressed: widget.onCreatePressed,
              ),
            ),
          ],
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final isWide = constraints.maxWidth >= 760;
          final isExtraWide = constraints.maxWidth >= 1120;
          final compactSections =
              widget.collapseProgress > 0.3 ||
              isLandscape ||
              constraints.maxHeight < 760;
          final pinnedCardWidth = isExtraWide
              ? 176.0
              : isWide
              ? 164.0
              : constraints.maxWidth < 380
              ? 138.0
              : 150.0;
          final pinnedCardHeight = compactSections ? 160.0 : 182.0;
          final crossAxisCount = isExtraWide
              ? 3
              : isWide
              ? 2
              : 1;
          final hasMiniPlayer = context.select<MusicPlayerBloc, bool>(
            (bloc) => bloc.state.playList.isNotEmpty,
          );
          final bottomPadding = hasMiniPlayer
              ? (isLandscape ? 112.0 : 148.0)
              : 28.0;

          return RefreshIndicator(
            onRefresh: _refreshPlaylists,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: PinnedPlaylistsView(
                    pinnedPlaylists: pinnedPlaylists,
                    compact: compactSections,
                    cardWidth: pinnedCardWidth,
                    cardHeight: pinnedCardHeight,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _PlaylistListSectionHeader(
                    playlistCount: allPlaylists.length,
                    compact: compactSections,
                  ),
                ),
                if (allPlaylists.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyPlaylist(
                      onAddPressed: widget.onCreatePressed,
                    ),
                  )
                else if (crossAxisCount == 1)
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final itemIndex = index ~/ 2;
                          if (index.isOdd) {
                            return const SizedBox(height: 2);
                          }
                          return PlaylistItem(
                            playlist: allPlaylists[itemIndex],
                            compact: compactSections,
                            isPinned: pinnedMeta.any(
                              (p) => p.playlistId == allPlaylists[itemIndex].id,
                            ),
                            onAddMusicToPlaylist: () =>
                                _handleAddMusicToPlaylist(
                                  allPlaylists[itemIndex],
                                ),
                            onTap: () => _navigateToPlaylistDetails(
                              allPlaylists[itemIndex],
                            ),
                            onPinned: () =>
                                _handlePinPlaylist(allPlaylists[itemIndex]),
                          );
                        },
                        childCount: (allPlaylists.length * 2) - 1,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final playlist = allPlaylists[index];
                          return PlaylistItem(
                            playlist: playlist,
                            compact: compactSections,
                            isPinned: pinnedMeta.any(
                              (p) => p.playlistId == playlist.id,
                            ),
                            onAddMusicToPlaylist: () =>
                                _handleAddMusicToPlaylist(playlist),
                            onTap: () => _navigateToPlaylistDetails(playlist),
                            onPinned: () => _handlePinPlaylist(playlist),
                            margin: const EdgeInsets.all(4),
                          );
                        },
                        childCount: allPlaylists.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        mainAxisExtent: compactSections ? 112 : 122,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: widget.padding,
      child: BlocBuilder<PlayListBloc, PlayListState>(
        builder: (context, state) => _buildBody(state, theme),
      ),
    );
  }
}

class _PlaylistListSectionHeader extends StatelessWidget {
  const _PlaylistListSectionHeader({
    required this.playlistCount,
    required this.compact,
  });

  final int playlistCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, compact ? 8 : 14, 0, compact ? 10 : 14),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        spacing: 12,
        children: [
          Text(
            context.localization.allPlaylists,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$playlistCount ${context.localization.playlists}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
