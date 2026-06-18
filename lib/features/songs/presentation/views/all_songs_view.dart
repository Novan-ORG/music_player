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
    if (songsBloc.state.status == SongsStatus.initial) {
      scheduleMicrotask(() => songsBloc.add(const LoadSongsEvent()));
    }

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
        final mediaQuery = MediaQuery.of(context);
        final isWideCompact =
            mediaQuery.size.width >= 700 && mediaQuery.size.height < 620;
        final hasMiniPlayer = context
            .read<MusicPlayerBloc>()
            .state
            .playList
            .isNotEmpty;
        final bottomPadding = hasMiniPlayer
            ? (isWideCompact ? 104.0 : 132.0)
            : 16.0;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.localization.libraryReady,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilterButton(
                    onTap: () async {
                      final selectedSortConfig =
                          await SongsSortBottomSheet.show(
                            context: context,
                            selectedSortConfig: songsState.sortConfig,
                          );
                      if (selectedSortConfig != null) {
                        songsBloc.add(
                          LoadSongsEvent(sortConfig: selectedSortConfig),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: SongsCount(songCount: songs.length),
              ),
            ),

            Expanded(
              child: SongsView(
                songs: songs,
                bottomPadding: bottomPadding,
                onRefresh: () async {
                  songsBloc.add(const LoadSongsEvent());
                  await Future<void>.delayed(
                    const Duration(milliseconds: 300),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
