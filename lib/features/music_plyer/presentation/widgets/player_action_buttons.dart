import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';

class PlayerActionButtons extends StatefulWidget {
  const PlayerActionButtons({super.key});

  @override
  State<PlayerActionButtons> createState() => _PlayerActionButtonsState();
}

class _PlayerActionButtonsState extends State<PlayerActionButtons> {
  late Stream<PlayerState> playerStateStream;
  bool isShuffled = false;
  late Stream<LoopMode> loopModeStream;
  late final MusicPlayerBloc musicPlayer;

  @override
  void initState() {
    musicPlayer = context.read<MusicPlayerBloc>();
    playerStateStream = musicPlayer.palyerStateStream;
    isShuffled = musicPlayer.shuffleModeEnabled;
    loopModeStream = musicPlayer.loopModeStream;
    super.initState();
  }

  void togglePlay() {
    musicPlayer.add(TogglePlayPauseEvent());
  }

  void toggleShuffle() {
    setState(() {
      isShuffled = !isShuffled;
    });
    musicPlayer.setShuffleModeEnabled(isShuffled);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withAlpha(10),
                colorScheme.secondary.withAlpha(8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: isShuffled ? 'Disable Shuffle' : 'Enable Shuffle',
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: IconButton(
                    key: ValueKey(isShuffled),
                    icon: Icon(
                      isShuffled ? Icons.shuffle_on_rounded : Icons.shuffle,
                      color: isShuffled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(70),
                    ),
                    splashRadius: 28,
                    onPressed: toggleShuffle,
                  ),
                ),
              ),
              Tooltip(
                message: 'Previous',
                child: IconButton(
                  icon: const Icon(Icons.skip_previous),
                  splashRadius: 28,
                  onPressed: musicPlayer.hasPrevious
                      ? () {
                          musicPlayer.add(PreviousMusicEvent());
                          setState(() {});
                        }
                      : null,
                ),
              ),
              StreamBuilder<PlayerState>(
                stream: playerStateStream,
                builder: (context, asyncSnapshot) {
                  final isPlaying = asyncSnapshot.data?.playing ?? false;
                  return Tooltip(
                    message: isPlaying ? 'Pause' : 'Play',
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: IconButton(
                        key: ValueKey(isPlaying),
                        iconSize: 44,
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: colorScheme.primary,
                        ),
                        splashRadius: 32,
                        onPressed: togglePlay,
                      ),
                    ),
                  );
                },
              ),
              Tooltip(
                message: 'Next',
                child: IconButton(
                  icon: const Icon(Icons.skip_next),
                  splashRadius: 28,
                  onPressed: musicPlayer.hasNext
                      ? () {
                          musicPlayer.add(NextMusicEvent());
                          setState(() {});
                        }
                      : null,
                ),
              ),
              StreamBuilder<LoopMode>(
                stream: loopModeStream,
                builder: (context, asyncSnapshot) {
                  final loopMode = asyncSnapshot.data ?? LoopMode.off;
                  IconData icon;
                  String tooltip;
                  Color color;
                  switch (loopMode) {
                    case LoopMode.one:
                      icon = Icons.repeat_one_on_rounded;
                      tooltip = 'Repeat One';
                      color = colorScheme.primary;
                      break;
                    case LoopMode.all:
                      icon = Icons.repeat_on_rounded;
                      tooltip = 'Repeat All';
                      color = colorScheme.primary;
                      break;
                    default:
                      icon = Icons.repeat;
                      tooltip = 'No Repeat';
                      color = colorScheme.onSurface.withAlpha(70);
                  }
                  return Tooltip(
                    message: tooltip,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        key: ValueKey(loopMode),
                        icon: Icon(icon, color: color),
                        splashRadius: 28,
                        onPressed: () {
                          musicPlayer.setNextLoopMode(loopMode);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
