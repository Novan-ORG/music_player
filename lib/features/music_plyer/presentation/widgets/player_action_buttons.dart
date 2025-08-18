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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.shuffle),
          isSelected: isShuffled,
          selectedIcon: const Icon(Icons.shuffle_on_rounded),
          onPressed: () {
            toggleShuffle();
          },
        ),
        IconButton(
          icon: Opacity(
            opacity: musicPlayer.hasPrevious ? 1 : 0.5,
            child: const Icon(Icons.skip_previous),
          ),
          onPressed: musicPlayer.hasPrevious
              ? () {
                  musicPlayer.add(PreviousMusicEvent());
                  setState(() {});
                }
              : null,
        ),
        StreamBuilder(
          stream: playerStateStream,
          builder: (context, asyncSnapshot) {
            return IconButton(
              iconSize: 38,
              icon: const Icon(Icons.play_arrow),
              selectedIcon: const Icon(Icons.pause),
              isSelected: asyncSnapshot.hasData
                  ? asyncSnapshot.data!.playing
                  : false,
              onPressed: () {
                togglePlay();
              },
            );
          },
        ),
        IconButton(
          icon: Opacity(
            opacity: musicPlayer.hasNext ? 1 : 0.5,
            child: const Icon(Icons.skip_next),
          ),
          onPressed: musicPlayer.hasNext
              ? () {
                  musicPlayer.add(NextMusicEvent());
                  setState(() {});
                }
              : null,
        ),
        StreamBuilder(
          stream: loopModeStream,
          builder: (context, asyncSnapshot) {
            final loopMode = asyncSnapshot.data ?? LoopMode.off;
            return IconButton(
              icon: Icon(
                loopMode == LoopMode.off
                    ? Icons.repeat
                    : loopMode == LoopMode.all
                    ? Icons.repeat_on_rounded
                    : Icons.repeat_one_on_rounded,
              ),
              isSelected: loopMode == LoopMode.all || loopMode == LoopMode.one,
              onPressed: () {
                musicPlayer.setNextLoopMode(loopMode);
              },
            );
          },
        ),
      ],
    );
  }
}
