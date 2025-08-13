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
  bool isPlayed = false;
  bool isShuffled = false;
  LoopMode loopMode = LoopMode.off;
  late final MusicPlayerBloc musicPlayer;

  @override
  void initState() {
    musicPlayer = context.read<MusicPlayerBloc>();
    isPlayed = musicPlayer.state.status == MusicPlayerStatus.playing;
    isShuffled = musicPlayer.audioPlayer.shuffleModeEnabled;
    loopMode = musicPlayer.audioPlayer.loopMode;
    super.initState();
  }

  void togglePlay() {
    setState(() {
      isPlayed = !isPlayed;
    });
    musicPlayer.add(TogglePlayPauseEvent());
  }

  void toggleShuffle() {
    setState(() {
      isShuffled = !isShuffled;
    });
    musicPlayer.audioPlayer.setShuffleModeEnabled(isShuffled);
  }

  void toggleRepeat() {
    setState(() {
      if (loopMode == LoopMode.off) {
        loopMode = LoopMode.all;
      } else if (loopMode == LoopMode.all) {
        loopMode = LoopMode.one;
      } else {
        loopMode = LoopMode.off;
      }
    });
    musicPlayer.audioPlayer.setLoopMode(loopMode);
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
            opacity: musicPlayer.audioPlayer.hasPrevious ? 1 : 0.5,
            child: const Icon(Icons.skip_previous),
          ),
          onPressed: musicPlayer.audioPlayer.hasPrevious
              ? () {
                  musicPlayer.add(PreviousMusicEvent());
                  setState(() {});
                }
              : null,
        ),
        IconButton(
          iconSize: 38,
          icon: const Icon(Icons.play_arrow),
          selectedIcon: const Icon(Icons.pause),
          isSelected: isPlayed,
          onPressed: () {
            togglePlay();
          },
        ),
        IconButton(
          icon: Opacity(
            opacity: musicPlayer.audioPlayer.hasNext ? 1 : 0.5,
            child: const Icon(Icons.skip_next),
          ),
          onPressed: musicPlayer.audioPlayer.hasNext
              ? () {
                  musicPlayer.add(NextMusicEvent());
                  setState(() {});
                }
              : null,
        ),
        IconButton(
          icon: Icon(
            loopMode == LoopMode.off
                ? Icons.repeat
                : loopMode == LoopMode.all
                    ? Icons.repeat_on_rounded
                    : Icons.repeat_one_on_rounded,
          ),
          isSelected: loopMode == LoopMode.all || loopMode == LoopMode.one,
          onPressed: () {
            toggleRepeat();
          },
        ),
      ],
    );
  }
}
