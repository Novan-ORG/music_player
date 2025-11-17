import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UpnextMusicsSheet extends StatelessWidget {
  const UpnextMusicsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.5,
      backgroundColor: Colors.transparent,
      builder: (_) => const UpnextMusicsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      bloc: musicPlayerBloc,
      buildWhen: (state, newState) =>
          state.currentSongIndex != newState.currentSongIndex ||
          state.playList != newState.playList,
      builder: (context, newState) {
        return _UpNextMusicsView(
          currentSongIndex: newState.currentSongIndex,
          playList: newState.playList,
          onTapSong: (index) {
            musicPlayerBloc.add(SeekMusicEvent(index: index));
          },
        );
      },
    );
  }
}

class _UpNextMusicsView extends StatefulWidget {
  const _UpNextMusicsView({
    required this.playList,
    this.onTapSong,
    this.currentSongIndex,
  });

  final void Function(int)? onTapSong;
  final int? currentSongIndex;
  final List<Song> playList;

  @override
  State<_UpNextMusicsView> createState() => _UpNextMusicsViewState();
}

class _UpNextMusicsViewState extends State<_UpNextMusicsView> {
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the current song once the frame is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrent();
    });
  }

  void _scrollToCurrent() {
    final idx = widget.currentSongIndex;
    if (idx == null || idx <= 0) return;
    unawaited(
      _scrollController.scrollTo(
        index: idx,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      ),
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
    final cardColor = Theme.of(context).cardColor;

    return BlocSelector<MusicPlayerBloc, MusicPlayerState, MusicPlayerStatus>(
      selector: (state) => state.status,
      builder: (context, playerStatus) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              const _Header(),
              const SizedBox(height: 12),
              Flexible(
                child: _UpNextList(
                  playList: widget.playList,
                  currentSongIndex: widget.currentSongIndex,
                  playerStatus: playerStatus,
                  scrollController: _scrollController,
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

class _UpNextList extends StatelessWidget {
  const _UpNextList({
    required this.playList,
    required this.playerStatus,
    required this.scrollController,
    this.currentSongIndex,
    this.onTapSong,
  });

  final List<Song> playList;
  final MusicPlayerStatus playerStatus;
  final ItemScrollController scrollController;
  final int? currentSongIndex;
  final void Function(int)? onTapSong;

  @override
  Widget build(BuildContext context) {
    if (playList.isEmpty) {
      return Center(
        child: Text(
          context.localization.noSongInQueue,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ScrollablePositionedList.separated(
      itemScrollController: scrollController,
      padding: EdgeInsets.zero,
      itemCount: playList.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 0.1).paddingSymmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final song = playList[index];
        final isCurrent = currentSongIndex == index;
        return SongItem(
          track: song,
          blurBackground: false,
          onTap: () => onTapSong?.call(index),
          isCurrentTrack: isCurrent,
          borderRadius: 0,
          isPlayingNow: playerStatus == MusicPlayerStatus.playing && isCurrent,
          onPlayPause: () {
            context.read<MusicPlayerBloc>().add(const TogglePlayPauseEvent());
          },
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.localization.upNext,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
