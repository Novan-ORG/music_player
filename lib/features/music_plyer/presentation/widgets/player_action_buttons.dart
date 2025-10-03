import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';

class PlayerActionButtons extends StatelessWidget {
  const PlayerActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayer = context.read<MusicPlayerBloc>();
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
          child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            builder: (context, state) {
              final isPlaying = state.status == MusicPlayerStatus.playing;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: state.shuffleEnabled
                        ? 'Disable Shuffle'
                        : 'Enable Shuffle',
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        key: ValueKey(state.shuffleEnabled),
                        icon: Icon(
                          state.shuffleEnabled
                              ? Icons.shuffle_on_rounded
                              : Icons.shuffle,
                          color: state.shuffleEnabled
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(70),
                        ),
                        splashRadius: 28,
                        onPressed: () {
                          musicPlayer.add(
                            SetShuffleEnabledEvent(
                              isEnabled: !state.shuffleEnabled,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Previous',
                    child: IconButton(
                      icon: const Icon(Icons.skip_previous),
                      splashRadius: 28,
                      onPressed: state.hasPrevious
                          ? () {
                              musicPlayer.add(
                                SeekMusicEvent(
                                  index: state.currentSongIndex - 1,
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                  Tooltip(
                    message: state.status == MusicPlayerStatus.playing
                        ? 'Pause'
                        : 'Play',
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
                        onPressed: () {
                          musicPlayer.add(const TogglePlayPauseEvent());
                        },
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Next',
                    child: IconButton(
                      icon: const Icon(Icons.skip_next),
                      splashRadius: 28,
                      onPressed: state.hasNext
                          ? () {
                              musicPlayer.add(
                                SeekMusicEvent(
                                  index: state.currentSongIndex + 1,
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                  Builder(
                    builder: (_) {
                      IconData icon;
                      String tooltip;
                      Color color;
                      switch (state.loopMode) {
                        case PlayerLoopMode.one:
                          icon = Icons.repeat_one_on_rounded;
                          tooltip = 'Repeat One';
                          color = colorScheme.primary;
                        case PlayerLoopMode.all:
                          icon = Icons.repeat_on_rounded;
                          tooltip = 'Repeat All';
                          color = colorScheme.primary;

                        case PlayerLoopMode.off:
                          icon = Icons.repeat;
                          tooltip = 'No Repeat';
                          color = colorScheme.onSurface.withAlpha(
                            (0.7 * 255).round(),
                          );
                      }
                      return Tooltip(
                        message: tooltip,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: IconButton(
                            key: ValueKey(state.loopMode),
                            icon: Icon(icon, color: color),
                            splashRadius: 28,
                            onPressed: () {
                              musicPlayer.add(
                                SetPlayerLoopModeEvent(state.loopMode),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
