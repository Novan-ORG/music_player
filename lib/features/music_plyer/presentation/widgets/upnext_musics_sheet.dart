import 'dart:async';

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
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UpnextMusicsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: DraggableScrollableSheet(
        minChildSize: 0.5,
        expand: false,
        builder: (context, innerScrollController) {
          return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            bloc: musicPlayerBloc,
            buildWhen: (previous, next) =>
                previous.currentSongIndex != next.currentSongIndex ||
                previous.playList != next.playList,
            builder: (context, state) {
              return _UpNextMusicsView(
                innerScrollController: innerScrollController,
                currentSongIndex: state.currentSongIndex,
                playList: state.playList,
                onTapSong: (index) =>
                    musicPlayerBloc.add(SeekMusicEvent(index: index)),
              );
            },
          );
        },
      ),
    );
  }
}

class _UpNextMusicsView extends StatefulWidget {
  const _UpNextMusicsView({
    required this.playList,
    this.onTapSong,
    this.currentSongIndex,
    this.innerScrollController,
  });

  final void Function(int)? onTapSong;
  final int? currentSongIndex;
  final List<Song> playList;
  final ScrollController? innerScrollController;

  @override
  State<_UpNextMusicsView> createState() => _UpNextMusicsViewState();
}

class _UpNextMusicsViewState extends State<_UpNextMusicsView> {
  static const double _itemHeight = 68;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  void _scrollToCurrent() {
    final idx = widget.currentSongIndex;
    if (idx == null || idx <= 0) return;

    widget.innerScrollController?.animateTo(
      idx * _itemHeight,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant _UpNextMusicsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSongIndex != widget.currentSongIndex) {
      _scrollToCurrent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MusicPlayerBloc, MusicPlayerState, MusicPlayerStatus>(
      selector: (state) => state.status,
      builder: (context, playerStatus) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            final expanded = notification.extent >= 0.7;
            if (expanded != _isExpanded) {
              setState(() => _isExpanded = expanded);
            }
            return false;
          },
          child: Column(
            children: [
              if (_isExpanded)
                _ExpandedHeader(
                  currentSong: widget.playList[widget.currentSongIndex ?? 0],
                ),
              Flexible(
                child: _UpNextList(
                  playList: widget.playList,
                  currentSongIndex: widget.currentSongIndex,
                  playerStatus: playerStatus,
                  innerScrollController: widget.innerScrollController,
                  onTapSong: widget.onTapSong,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UpNextList extends StatefulWidget {
  const _UpNextList({
    required this.playList,
    required this.playerStatus,
    this.innerScrollController,
    this.currentSongIndex,
    this.onTapSong,
  });

  final List<Song> playList;
  final MusicPlayerStatus playerStatus;
  final ScrollController? innerScrollController;
  final int? currentSongIndex;
  final void Function(int)? onTapSong;

  @override
  State<_UpNextList> createState() => _UpNextListState();
}

class _UpNextListState extends State<_UpNextList>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin,
        ToggleLikeMixin {
  @override
  Widget build(BuildContext context) {
    return BottomSheetBaseWidget(
      title: context.localization.upNext,
      body: widget.playList.isEmpty
          ? Center(
              child: Text(
                context.localization.noSongInQueue,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : Expanded(
              child:
                  BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
                    selector: (state) {
                      return state.favoriteSongIds;
                    },
                    builder: (context, favoriteSongIds) {
                      return ListView.builder(
                        controller: widget.innerScrollController,
                        itemCount: widget.playList.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final song = widget.playList[index];
                          final isCurrent = widget.currentSongIndex == index;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SongItem(
                                track: song,
                                blurBackground: false,
                                songImageSize: 48,
                                onTap: () => widget.onTapSong?.call(index),
                                isCurrentTrack: isCurrent,
                                borderRadius: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 2,
                                ),
                                isPlayingNow:
                                    widget.playerStatus ==
                                        MusicPlayerStatus.playing &&
                                    isCurrent,
                                onPlayPause: () {
                                  context.read<MusicPlayerBloc>().add(
                                    const TogglePlayPauseEvent(),
                                  );
                                },
                                isFavorite: favoriteSongIds.contains(
                                  song.id,
                                ),
                                onSetAsRingtone: () => setAsRingtone(song.data),
                                onDelete: () => showDeleteSongDialog(song),
                                onFavoriteToggle: () => onToggleLike(song.id),
                                onAddToPlaylist: () async {
                                  await PlaylistsPage.showSheet(
                                    context: context,
                                    songIds: {song.id},
                                  );
                                },
                                onShare: () => shareSong(song),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0.1,
                                  thickness: 0.1,
                                  color: context.theme.dividerColor,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
            ),
    );
  }
}

class _ExpandedHeader extends StatelessWidget {
  const _ExpandedHeader({required this.currentSong});
  final Song currentSong;

  @override
  Widget build(BuildContext context) {
    final title = currentSong.title;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SongTitle(
                songTitle: title,
              ),
              const SizedBox(height: 8),
              const UpnextSheetActionButtons(playIconSize: 30),
            ],
          ),
        ),
        Hero(
          tag: 'song_cover_${currentSong.id}',
          child: ArtImageWidget(
            id: currentSong.id,
            size: MediaQuery.of(context).size.width * 0.2,
          ),
        ),
        const SizedBox(width: 10),
      ],
    ).paddingOnly(top: 48, bottom: 16);
  }
}
