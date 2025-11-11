import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';

class PlayerActionButtons extends StatelessWidget {
  const PlayerActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        final musicPlayer = context.read<MusicPlayerBloc>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ShuffleButton(state: state, musicPlayer: musicPlayer),
            _PreviousButton(state: state, musicPlayer: musicPlayer),
            _PlayPauseButton(state: state, musicPlayer: musicPlayer),
            _NextButton(state: state, musicPlayer: musicPlayer),
            _LoopButton(state: state, musicPlayer: musicPlayer),
          ],
        );
      },
    );
  }
}

class _ShuffleButton extends StatelessWidget {
  const _ShuffleButton({
    required this.state,
    required this.musicPlayer,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: state.shuffleEnabled ? 'Disable Shuffle' : 'Enable Shuffle',
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: IconButton(
          key: ValueKey(state.shuffleEnabled),
          icon: Icon(
            state.shuffleEnabled ? Icons.shuffle_on_rounded : Icons.shuffle,
            size: 24,
            color: state.shuffleEnabled
                ? colorScheme.primary
                : colorScheme.onSurface.withAlpha(70),
          ),
          splashRadius: 24,
          onPressed: () => musicPlayer.add(
            SetShuffleEnabledEvent(isEnabled: !state.shuffleEnabled),
          ),
        ),
      ),
    );
  }
}

class _PreviousButton extends StatelessWidget {
  const _PreviousButton({
    required this.state,
    required this.musicPlayer,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Previous',
      child: IconButton(
        icon: const Icon(Icons.skip_previous, size: 32),
        splashRadius: 32,
        onPressed: state.hasPrevious
            ? () => musicPlayer.add(
                SeekMusicEvent(index: state.currentSongIndex - 1),
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
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = state.status == MusicPlayerStatus.playing;

    return Tooltip(
      message: isPlaying ? 'Pause' : 'Play',
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.onPrimary,
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: child,
          ),
          child: IconButton(
            key: ValueKey(isPlaying),
            iconSize: 48,
            splashRadius: 48,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: colorScheme.primary,
            ),
            onPressed: () => musicPlayer.add(const TogglePlayPauseEvent()),
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.state,
    required this.musicPlayer,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Next',
      child: IconButton(
        icon: const Icon(Icons.skip_next, size: 32),
        splashRadius: 32,
        onPressed: state.hasNext
            ? () => musicPlayer.add(
                SeekMusicEvent(index: state.currentSongIndex + 1),
              )
            : null,
      ),
    );
  }
}

class _LoopButton extends StatelessWidget {
  const _LoopButton({
    required this.state,
    required this.musicPlayer,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loopConfig = _getLoopConfiguration(state.loopMode, colorScheme);

    return Tooltip(
      message: loopConfig.tooltip,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: IconButton(
          key: ValueKey(state.loopMode),
          icon: Icon(
            loopConfig.icon,
            color: loopConfig.color,
            size: 24,
          ),
          splashRadius: 24,
          onPressed: () => musicPlayer.add(
            SetPlayerLoopModeEvent(state.loopMode),
          ),
        ),
      ),
    );
  }

  _LoopConfig _getLoopConfiguration(
    PlayerLoopMode mode,
    ColorScheme colorScheme,
  ) {
    return switch (mode) {
      PlayerLoopMode.one => _LoopConfig(
        icon: Icons.repeat_one_on_rounded,
        tooltip: 'Repeat One',
        color: colorScheme.primary,
      ),
      PlayerLoopMode.all => _LoopConfig(
        icon: Icons.repeat_on_rounded,
        tooltip: 'Repeat All',
        color: colorScheme.primary,
      ),
      PlayerLoopMode.off => _LoopConfig(
        icon: Icons.repeat,
        tooltip: 'No Repeat',
        color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
      ),
    };
  }
}

class _LoopConfig {
  const _LoopConfig({
    required this.icon,
    required this.tooltip,
    required this.color,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
}
