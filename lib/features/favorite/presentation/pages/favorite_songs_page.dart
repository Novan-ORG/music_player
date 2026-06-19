import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/favorite/presentation/widgets/widgets.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

/// Page displaying all favorite songs.
///
/// Features:
/// - Favorite songs list
/// - Play song functionality
/// - Remove from favorites
/// - Empty state handling
class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({super.key});

  @override
  State<FavoriteSongsPage> createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {
  static const double _headerCollapseDistance = 160;
  late final FavoriteSongsBloc favSongsBloc = context.read<FavoriteSongsBloc>();
  double _headerCollapseProgress = 0;

  @override
  void initState() {
    super.initState();
    favSongsBloc.add(const LoadFavoriteSongsEvent());
  }

  Future<void> onRefresh() async {
    favSongsBloc.add(const LoadFavoriteSongsEvent());
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
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
      body: BlocListener<SongsBloc, SongsState>(
        listenWhen: (previous, current) =>
            previous.allSongs != current.allSongs &&
            current.status == SongsStatus.loaded,
        listener: (_, state) =>
            favSongsBloc.add(const LoadFavoriteSongsEvent()),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.16),
                const Color(0xFFE85D75).withValues(alpha: 0.06),
                theme.scaffoldBackgroundColor,
                theme.scaffoldBackgroundColor,
              ],
              stops: const [0, 0.2, 0.44, 1],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: BlocBuilder<FavoriteSongsBloc, FavoriteSongsState>(
              builder: (context, favoriteState) {
                final favoriteCount = favoriteState.favoriteSongs.length;
                final hasMiniPlayer = context.select<MusicPlayerBloc, bool>(
                  (bloc) => bloc.state.playList.isNotEmpty,
                );
                final bodyBottomPadding = hasMiniPlayer ? 148.0 : 18.0;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth >= 980
                        ? 920.0
                        : constraints.maxWidth;

                    return Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          children: [
                            FavoritePageHeader(
                              favoriteCount: favoriteCount,
                              collapseProgress: _headerCollapseProgress,
                              onClearAllPressed: favoriteCount == 0
                                  ? null
                                  : _showClearAllDialog,
                            ),
                            Expanded(
                              child: _buildContent(
                                favoriteState,
                                bottomPadding: bodyBottomPadding,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    FavoriteSongsState favoriteState, {
    required double bottomPadding,
  }) {
    if (favoriteState.status == FavoriteSongsStatus.loading) {
      return const Loading();
    }

    if (favoriteState.status == FavoriteSongsStatus.error) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
        child: FavoriteErrorWidget(
          message: context.localization.libraryLoadErrorMessage,
          onRetry: () => favSongsBloc.add(
            const LoadFavoriteSongsEvent(),
          ),
        ),
      );
    }

    if (favoriteState.favoriteSongs.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
        child: FavoriteEmptyWidget(
          onRefresh: () {
            favSongsBloc.add(const LoadFavoriteSongsEvent());
          },
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Text(
                  context.localization.songs,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                SongsCount(songCount: favoriteState.favoriteSongs.length),
              ],
            ),
          ),
          Expanded(
            child: SongsView(
              songs: favoriteState.favoriteSongs,
              onRefresh: onRefresh,
              bottomPadding: bottomPadding,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        icon: Icons.heart_broken_outlined,
        title: dialogContext.localization.clearAll,
        message:
            dialogContext.localization.areYouSureYouWantToClearAllFavorites,
        confirmLabel: dialogContext.localization.clearAll,
        isDestructive: true,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          favSongsBloc.add(
            const ClearAllFavoritesEvent(),
          );
        },
      ),
    );
  }
}
