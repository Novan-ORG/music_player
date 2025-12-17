import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class AllSongsView extends StatelessWidget {
  const AllSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    final songsBloc = context.read<SongsBloc>();
    scheduleMicrotask(() {
      songsBloc.add(const LoadSongsEvent());
    });
    return BlocBuilder<SongsBloc, SongsState>(
      bloc: songsBloc,
      builder: (context, songsState) {
        // Handle loading state
        if (songsState.status == SongsStatus.loading) {
          return const Loading();
        }

        // Handle error state
        if (songsState.status == SongsStatus.error) {
          return SongsErrorLoading(
            message: context.localization.errorLoadingSongs,
            onRetry: () => songsBloc.add(const LoadSongsEvent()),
          );
        }

        // Handle empty songs
        if (songsState.allSongs.isEmpty) {
          return NoSongsWidget(
            message: context.localization.noSongTryAgain,
            onRefresh: () => songsBloc.add(const LoadSongsEvent()),
          );
        }

        final songs = songsState.allSongs;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(
                  onTap: () async {
                    final selectedSortType = await SongsFilterBottomSheet.show(
                      context: context,
                      selectedSortType: songsState.sortType,
                    );
                    if (selectedSortType != null) {
                      songsBloc.add(
                        LoadSongsEvent(sortType: selectedSortType),
                      );
                    }
                  },
                ),
                SongsCount(songCount: songs.length),
              ],
            ).padding(value: 12),

            Expanded(
              child: SongsView(
                songs: songs,
                onRefresh: () async {
                  songsBloc.add(const LoadSongsEvent());
                  await Future<void>.delayed(
                    const Duration(milliseconds: 300),
                  );
                },
              ),
            ),
            // Bottom spacing for mini player
            if (context.read<MusicPlayerBloc>().state.playList.isNotEmpty)
              const SizedBox(height: 68),
          ],
        );
      },
    );
  }
}
