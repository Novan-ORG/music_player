import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
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
    return StreamBuilder<int?>(
      stream: musicPlayerBloc.currentIndexStream,
      builder: (context, snapShotData) {
        return _UpNextMusicsView(
          currentSongIndex: snapShotData.data,
          playList: musicPlayerBloc.state.playList,
          onTapSong: (index) {
            musicPlayerBloc.add(SkipToMusicIndexEvent(index));
          },
        );
      },
    );
  }
}

class _UpNextMusicsView extends StatelessWidget {
  const _UpNextMusicsView({
    required this.playList,
    this.onTapSong,
    this.currentSongIndex,
  });

  final void Function(int)? onTapSong;
  final int? currentSongIndex;
  final List<SongModel> playList;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final scrollController = ItemScrollController();
    scheduleMicrotask(() {
      if (currentSongIndex == null || currentSongIndex! <= 0) return;
      unawaited(
        scrollController.scrollTo(
          index: currentSongIndex!,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
      );
    });
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
          _Header(),
          const SizedBox(height: 12),
          Flexible(
            child: playList.isEmpty
                ? Center(
                    child: Text(
                      context.localization.noSongInQueue,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ScrollablePositionedList.separated(
                    itemScrollController: scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: playList.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final song = playList[index];
                      final isPlaying = currentSongIndex == index;
                      return ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        leading: Transform.scale(
                          scale: isPlaying ? 1.2 : 1,
                          child: Icon(
                            Icons.music_note,
                            color: isPlaying ? primaryColor : Colors.blueAccent,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          song.displayNameWOExt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isPlaying ? primaryColor : null,
                              ),
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.person,
                              size: 12,
                              color: isPlaying ? primaryColor : null,
                            ),
                            Flexible(
                              child: Text(
                                song.artist ?? 'Unknown Artist',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: isPlaying ? primaryColor : null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          Duration(milliseconds: song.duration ?? 0).format(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: isPlaying ? primaryColor : null,
                              ),
                        ),
                        onTap: () => onTapSong?.call(index),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hoverColor: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(5),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
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
        Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[600]),
      ],
    );
  }
}
