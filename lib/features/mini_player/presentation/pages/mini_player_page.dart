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
    return StreamBuilder<int?>(
      stream: musicPlayerBloc.currentIndexStream,
      builder: (_, snapShot) {
        final index = snapShot.data ?? -1;
        if (index < 0) {
          return const Center(child: CircularProgressIndicator());
        }
        final currentSong = musicPlayerBloc.state.playList[index];
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => MusicPlayerPage()));
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withAlpha(8),
                    Theme.of(context).colorScheme.secondary.withAlpha(6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                leading: Hero(
                  tag: 'mini_cover_${currentSong.id}',
                  child: MiniCoverAndProgress(
                    positionStream: musicPlayerBloc.positionStream,
                    durationStream: musicPlayerBloc.durationStream,
                    songId: currentSong.id,
                  ),
                ),
                title: _buildTitle(context, currentSong.displayNameWOExt),
                subtitle: _buildSubtitle(context, currentSong.artist),
                trailing: _MiniPlayerControls(
                  musicPlayerBloc: musicPlayerBloc,
                  currentSongId: currentSong.id,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return AutoSizeText(
      title,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflowReplacement: SizedBox(
        height: 18,
        child: Marquee(
          text: title,
          blankSpace: 60,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, String? artist) {
    final displayArtist = artist?.isNotEmpty == true ? artist! : 'unknown';
    return AutoSizeText(
      displayArtist,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
      maxLines: 1,
      overflowReplacement: SizedBox(
        height: 20,
        child: Marquee(
          text: displayArtist,
          blankSpace: 60,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
        ),
      ),
    );
  }
}

class _MiniPlayerControls extends StatelessWidget {
  final MusicPlayerBloc musicPlayerBloc;
  final int currentSongId;

  const _MiniPlayerControls({
    required this.musicPlayerBloc,
    required this.currentSongId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocSelector<MusicPlayerBloc, MusicPlayerState, List<int>>(
          selector: (state) => state.likedSongIds,
          builder: (context, likedSongIds) {
            final isLiked = likedSongIds.contains(currentSongId);
            return IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
              tooltip: isLiked ? 'Unlike' : 'Like',
              onPressed: () {
                musicPlayerBloc.add(ToggleLikeMusicEvent(currentSongId));
              },
            );
          },
        ),
        StreamBuilder(
          stream: musicPlayerBloc.palyerStateStream,
          builder: (context, asyncSnapshot) {
            final isPlaying = asyncSnapshot.data?.playing ?? false;
            return IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              tooltip: isPlaying ? 'Pause' : 'Play',
              onPressed: () {
                musicPlayerBloc.add(TogglePlayPauseEvent());
              },
            );
          },
        ),
      ],
    );
  }
}
