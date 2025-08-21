import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/features/mini_player/presentation/widgets/mini_cover_and_progress.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/music_player_page.dart';

class MiniPlayerPage extends StatelessWidget {
  const MiniPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return StreamBuilder(
      stream: musicPlayerBloc.currentIndexStream,
      builder: (_, snapShot) {
        final index = snapShot.data ?? -1;
        if (index < 0) {
          return const Center(child: CircularProgressIndicator());
        }
        final currentSong = musicPlayerBloc.state.playList[index];
        return ListTile(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => MusicPlayerPage()));
          },
          leading: MiniCoverAndProgress(
            positionStream: musicPlayerBloc.positionStream,
            durationStream: musicPlayerBloc.durationStream,
            songId: currentSong.id,
          ),
          title: AutoSizeText(
            currentSong.displayNameWOExt,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflowReplacement: SizedBox(
              height: 18,
              child: Marquee(
                text: currentSong.displayNameWOExt,
                blankSpace: 60,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          subtitle: AutoSizeText(
            currentSong.artist ?? 'unknown',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflowReplacement: SizedBox(
              height: 20,
              child: Marquee(
                text: currentSong.artist ?? 'unknwon',
                blankSpace: 60,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              BlocSelector<MusicPlayerBloc, MusicPlayerState, List<int>>(
                selector: (state) {
                  return state.likedSongIds;
                },
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      musicPlayerBloc.add(ToggleLikeMusicEvent(currentSong.id));
                    },
                    icon: Icon(
                      state.contains(currentSong.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  );
                },
              ),
              const SizedBox(width: 1),
              IconButton(
                onPressed: musicPlayerBloc.hasPrevious
                    ? () {
                        musicPlayerBloc.add(PreviousMusicEvent());
                      }
                    : null,
                icon: Icon(Icons.skip_previous),
              ),
              StreamBuilder(
                stream: musicPlayerBloc.palyerStateStream,
                builder: (context, asyncSnapshot) {
                  final isPlaying = asyncSnapshot.data?.playing ?? false;
                  return IconButton(
                    onPressed: () {
                      musicPlayerBloc.add(TogglePlayPauseEvent());
                    },
                    icon: Icon(!isPlaying ? Icons.play_arrow : Icons.pause),
                  );
                },
              ),
              IconButton(
                onPressed: musicPlayerBloc.hasNext
                    ? () {
                        musicPlayerBloc.add(NextMusicEvent());
                      }
                    : null,
                icon: Icon(Icons.skip_next),
              ),
            ],
          ),
        );
      },
    );
  }
}
