import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';

class UpnextSheetActionButtons extends StatelessWidget {
  const UpnextSheetActionButtons({
    super.key,
    this.playIconSize = 48,
  });

  final double playIconSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) {
        return previous.currentSongIndex != current.currentSongIndex ||
            previous.status != current.status;
      },
      builder: (context, state) {
        final musicPlayer = context.read<MusicPlayerBloc>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PreviousButton(
              state: state,
              musicPlayer: musicPlayer,
              iconSize: playIconSize,
            ),
            _PlayPauseButton(
              state: state,
              musicPlayer: musicPlayer,
              iconSize: playIconSize,
            ),
            _NextButton(
              state: state,
              musicPlayer: musicPlayer,
              iconSize: playIconSize,
            ),
          ],
        );
      },
    );
  }
}

class _PreviousButton extends StatelessWidget {
  const _PreviousButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Previous',
      child: IconButton(
        icon: Icon(Icons.skip_previous, size: iconSize),
        splashRadius: iconSize,
        onPressed: state.hasPrevious
            ? () => musicPlayer.add(
                const SkipToPreviousEvent(),
              )
            : null,
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final isPlaying = state.status == MusicPlayerStatus.playing;

    return Tooltip(
      message: isPlaying ? 'Pause' : 'Play',
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: child,
        ),
        child: IconButton(
          key: ValueKey(isPlaying),
          iconSize: iconSize,
          splashRadius: iconSize,
          icon: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
          onPressed: () => musicPlayer.add(const TogglePlayPauseEvent()),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Next',
      child: IconButton(
        icon: Icon(Icons.skip_next, size: iconSize),
        splashRadius: iconSize,
        onPressed: state.hasNext
            ? () => musicPlayer.add(
                const SkipToNextEvent(),
              )
            : null,
      ),
    );
  }
}
