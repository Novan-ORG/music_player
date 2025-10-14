import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';

class MiniPlayerPage extends StatelessWidget {
  const MiniPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) =>
          previous.likedSongIds != current.likedSongIds ||
          previous.currentSong?.id != current.currentSong?.id ||
          previous.status != current.status,
      builder: (context, state) {
        final isLiked = state.likedSongIds.contains(state.currentSong?.id);
        final isPlaying = state.status == MusicPlayerStatus.playing;
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () async {
              await Navigator.of(
                context,
              ).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MusicPlayerPage(),
                ),
              );
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
                  tag: 'mini_cover_${state.currentSong?.id}',
                  child: MiniCoverAndProgress(
                    positionStream: musicPlayerBloc.positionStream,
                    durationStream: musicPlayerBloc.durationStream,
                    songId: state.currentSong?.id ?? 0,
                  ),
                ),
                title: _buildTitle(
                  context,
                  state.currentSong?.title ?? 'No song',
                ),
                subtitle: _buildSubtitle(context, state.currentSong?.artist),
                trailing: _MiniPlayerControls(
                  musicPlayerBloc: musicPlayerBloc,
                  currentSongId: state.currentSong?.id ?? 0,
                  isLiked: isLiked,
                  isPlaying: isPlaying,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
  final displayArtist = artist?.isNotEmpty ?? false ? artist! : 'unknown';
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

class _MiniPlayerControls extends StatelessWidget {
  const _MiniPlayerControls({
    required this.musicPlayerBloc,
    required this.currentSongId,
    required this.isLiked,
    required this.isPlaying,
  });

  final MusicPlayerBloc musicPlayerBloc;
  final int currentSongId;
  final bool isLiked;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
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
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          tooltip: isPlaying ? 'Pause' : 'Play',
          onPressed: () {
            musicPlayerBloc.add(const TogglePlayPauseEvent());
          },
        ),
      ],
    );
  }
}
