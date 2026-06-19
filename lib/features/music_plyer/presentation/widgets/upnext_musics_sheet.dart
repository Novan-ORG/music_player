import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';
import 'package:music_player/features/playlist/playlist.dart';

class UpnextMusicsSheet extends StatelessWidget {
  const UpnextMusicsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UpnextMusicsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    final screenSize = MediaQuery.sizeOf(context);
    final isLandscape = screenSize.width > screenSize.height;
    final maxWidth = isLandscape
        ? math.min<double>(screenSize.width - 24, 980)
        : screenSize.width;
    final minChildSize = isLandscape ? 0.54 : 0.30;
    final initialChildSize = isLandscape ? 0.72 : 0.44;
    final maxChildSize = isLandscape ? 0.96 : 0.94;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 28,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: DraggableScrollableSheet(
            minChildSize: minChildSize,
            initialChildSize: initialChildSize,
            maxChildSize: maxChildSize,
            snap: true,
            snapSizes: [initialChildSize, maxChildSize],
            expand: false,
            builder: (context, innerScrollController) {
              return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                bloc: musicPlayerBloc,
                buildWhen: (previous, next) =>
                    previous.currentSongIndex != next.currentSongIndex ||
                    previous.playList != next.playList ||
                    previous.status != next.status,
                builder: (context, state) {
                  return _UpNextMusicsView(
                    innerScrollController: innerScrollController,
                    currentSongIndex: state.currentSongIndex,
                    playerStatus: state.status,
                    playList: state.playList,
                    onTapSong: (index) =>
                        musicPlayerBloc.add(SeekMusicEvent(index: index)),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UpNextMusicsView extends StatefulWidget {
  const _UpNextMusicsView({
    required this.playList,
    required this.playerStatus,
    this.onTapSong,
    this.currentSongIndex,
    this.innerScrollController,
  });

  final void Function(int)? onTapSong;
  final int? currentSongIndex;
  final List<Song> playList;
  final MusicPlayerStatus playerStatus;
  final ScrollController? innerScrollController;

  @override
  State<_UpNextMusicsView> createState() => _UpNextMusicsViewState();
}

class _UpNextMusicsViewState extends State<_UpNextMusicsView>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin,
        ToggleLikeMixin {
  static const _tileExtent = 88.0;
  double _sheetExtent = 0.44;

  bool get _isExpanded => _sheetExtent >= 0.72;

  Song? get _currentSong {
    final currentIndex = widget.currentSongIndex ?? -1;
    if (currentIndex < 0 || currentIndex >= widget.playList.length) {
      return null;
    }
    return widget.playList[currentIndex];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  @override
  void didUpdateWidget(covariant _UpNextMusicsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSongIndex != widget.currentSongIndex) {
      _scrollToCurrent();
    }
  }

  void _scrollToCurrent() {
    final currentIndex = widget.currentSongIndex ?? -1;
    if (currentIndex <= 0) {
      return;
    }

    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;
    final headerOffset = isLandscape ? 164.0 : 214.0;

    widget.innerScrollController?.animateTo(
      headerOffset + (currentIndex * _tileExtent),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final currentSong = _currentSong;
    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final nextExtent = notification.extent;
        if ((nextExtent - _sheetExtent).abs() > 0.01) {
          setState(() => _sheetExtent = nextExtent);
        }
        return false;
      },
      child: BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
        selector: (state) => state.favoriteSongIds,
        builder: (context, favoriteSongIds) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.98),
                  colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: CustomScrollView(
                controller: widget.innerScrollController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 14),
                      child: Column(
                        children: [
                          _SheetHandle(isExpanded: _isExpanded),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              18,
                              isLandscape ? 6 : 10,
                              18,
                              0,
                            ),
                            child: _SheetHeader(
                              isExpanded: _isExpanded,
                              isLandscape: isLandscape,
                              currentSong: currentSong,
                              currentSongIndex: widget.currentSongIndex ?? 0,
                              totalSongs: widget.playList.length,
                              playerStatus: widget.playerStatus,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.playList.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyQueueView(
                        message: context.localization.noSongInQueue,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        0,
                        18,
                        isLandscape ? 18 : 24,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, itemIndex) {
                            if (itemIndex.isOdd) {
                              return const SizedBox(height: 10);
                            }

                            final index = itemIndex ~/ 2;
                            final song = widget.playList[index];
                            final isCurrent = widget.currentSongIndex == index;

                            return _QueueSongTile(
                              index: index,
                              song: song,
                              isCurrent: isCurrent,
                              isPlayingNow:
                                  widget.playerStatus ==
                                      MusicPlayerStatus.playing &&
                                  isCurrent,
                              isFavorite: favoriteSongIds.contains(song.id),
                              onTap: () => widget.onTapSong?.call(index),
                              onPlayPause: () {
                                context.read<MusicPlayerBloc>().add(
                                  const TogglePlayPauseEvent(),
                                );
                              },
                              onFavoriteToggle: () => onToggleLike(song.id),
                              onSetAsRingtone: () => setAsRingtone(song.data),
                              onDelete: () => showDeleteSongDialog(song),
                              onAddToPlaylist: () async {
                                await PlaylistsPage.showSheet(
                                  context: context,
                                  songIds: {song.id},
                                );
                              },
                              onShare: () => shareSong(song),
                            );
                          },
                          childCount: (widget.playList.length * 2) - 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: isExpanded ? 54 : 42,
          height: 5,
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.isExpanded,
    required this.isLandscape,
    required this.currentSong,
    required this.currentSongIndex,
    required this.totalSongs,
    required this.playerStatus,
  });

  final bool isExpanded;
  final bool isLandscape;
  final Song? currentSong;
  final int currentSongIndex;
  final int totalSongs;
  final MusicPlayerStatus playerStatus;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final titleStyle = context.theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: isLandscape ? 10 : 14,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
            Expanded(
              child: Center(
                child: Text(
                  context.localization.upNext,
                  style: titleStyle,
                ),
              ),
            ),
            _QueueCountBadge(totalSongs: totalSongs),
          ],
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 240),
          crossFadeState: (isExpanded && !isLandscape)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: _CompactQueuePreview(
            currentSong: currentSong,
            currentSongIndex: currentSongIndex,
            totalSongs: totalSongs,
            playerStatus: playerStatus,
            isLandscape: isLandscape,
          ),
          secondChild: _ExpandedQueuePreview(
            currentSong: currentSong,
            currentSongIndex: currentSongIndex,
            totalSongs: totalSongs,
            isLandscape: isLandscape,
          ),
        ),
      ],
    );
  }
}

class _QueueCountBadge extends StatelessWidget {
  const _QueueCountBadge({required this.totalSongs});

  final int totalSongs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        totalSongs.toString(),
        style: context.theme.textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CompactQueuePreview extends StatelessWidget {
  const _CompactQueuePreview({
    required this.currentSong,
    required this.currentSongIndex,
    required this.totalSongs,
    required this.playerStatus,
    required this.isLandscape,
  });

  final Song? currentSong;
  final int currentSongIndex;
  final int totalSongs;
  final MusicPlayerStatus playerStatus;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return GlassCard(
      borderRadius: BorderRadius.circular(28),
      padding: EdgeInsets.all(isLandscape ? 12 : 16),
      child: Row(
        children: [
          Hero(
            tag: 'song_cover_${currentSong?.id ?? 0}',
            child: ArtImageWidget(
              id: currentSong?.id ?? 0,
              size: 68,
              borderRadius: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text(
                  '${math.min(currentSongIndex + 1, totalSongs)}/$totalSongs',
                  style: context.theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SongTitle(songTitle: currentSong?.title),
                Text(
                  currentSong?.artist ?? context.localization.unknownArtist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            playerStatus == MusicPlayerStatus.playing
                ? Icons.graphic_eq_rounded
                : Icons.pause_circle_outline_rounded,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ExpandedQueuePreview extends StatelessWidget {
  const _ExpandedQueuePreview({
    required this.currentSong,
    required this.currentSongIndex,
    required this.totalSongs,
    required this.isLandscape,
  });

  final Song? currentSong;
  final int currentSongIndex;
  final int totalSongs;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return GlassCard(
      borderRadius: BorderRadius.circular(30),
      padding: EdgeInsets.all(isLandscape ? 14 : 18),
      child: Row(
        children: [
          Hero(
            tag: 'song_cover_${currentSong?.id ?? 0}',
            child: ArtImageWidget(
              id: currentSong?.id ?? 0,
              size: isLandscape ? 74 : 94,
              borderRadius: 26,
            ),
          ),
          SizedBox(width: isLandscape ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: isLandscape ? 8 : 10,
              children: [
                Text(
                  '${math.min(currentSongIndex + 1, totalSongs)}/$totalSongs',
                  style: context.theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SongTitle(songTitle: currentSong?.title),
                Text(
                  currentSong?.artist ?? context.localization.unknownArtist,
                  maxLines: isLandscape ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                UpnextSheetActionButtons(
                  playIconSize: isLandscape ? 22 : 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueSongTile extends StatelessWidget {
  const _QueueSongTile({
    required this.index,
    required this.song,
    required this.isCurrent,
    required this.isPlayingNow,
    required this.isFavorite,
    required this.onTap,
    this.onPlayPause,
    this.onFavoriteToggle,
    this.onDelete,
    this.onSetAsRingtone,
    this.onAddToPlaylist,
    this.onShare,
  });

  final int index;
  final Song song;
  final bool isCurrent;
  final bool isPlayingNow;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onPlayPause;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onSetAsRingtone;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: isCurrent
            ? LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.16),
                  colorScheme.primary.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCurrent ? null : colorScheme.surface.withValues(alpha: 0.28),
        border: Border.all(
          color: isCurrent
              ? colorScheme.primary.withValues(alpha: 0.24)
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                _QueueTrackIndicator(
                  index: index,
                  isCurrent: isCurrent,
                  isPlayingNow: isPlayingNow,
                  onPressed: isCurrent ? onPlayPause : onTap,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isCurrent ? colorScheme.primary : null,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.62,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            song.duration.format(),
                            style: context.theme.textTheme.labelMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.48,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                    color: isFavorite
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                SongItemMoreOptionMenu(
                  isInPlaylist: false,
                  isCurrentTrack: isCurrent,
                  onAddToPlaylist: onAddToPlaylist,
                  onDelete: onDelete,
                  onSetAsRingtone: onSetAsRingtone,
                  onShare: onShare,
                ),
                const SizedBox(width: 6),
                ArtImageWidget(
                  id: song.id,
                  borderRadius: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QueueTrackIndicator extends StatelessWidget {
  const _QueueTrackIndicator({
    required this.index,
    required this.isCurrent,
    required this.isPlayingNow,
    required this.onPressed,
  });

  final int index;
  final bool isCurrent;
  final bool isPlayingNow;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    if (!isCurrent) {
      return SizedBox(
        width: 38,
        child: Center(
          child: Text(
            '${index + 1}',
            style: context.theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.48),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.84),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isPlayingNow ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _EmptyQueueView extends StatelessWidget {
  const _EmptyQueueView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.queue_music_rounded,
                size: 34,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
