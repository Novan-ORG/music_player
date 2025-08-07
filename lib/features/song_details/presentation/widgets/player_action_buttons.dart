import 'package:flutter/material.dart';

class PlayerActionButtons extends StatefulWidget {
  const PlayerActionButtons({super.key});

  @override
  State<PlayerActionButtons> createState() => _PlayerActionButtonsState();
}

class _PlayerActionButtonsState extends State<PlayerActionButtons> {
  bool isPlayed = false;
  bool isShuffled = false;
  bool isRepeated = false;

  void togglePlay() {
    setState(() {
      isPlayed = !isPlayed;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(isPlayed ? 'Playing' : 'Paused')));
  }

  void toggleShuffle() {
    setState(() {
      isShuffled = !isShuffled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isShuffled ? 'Shuffle On' : 'Shuffle Off')),
    );
  }

  void toggleRepeat() {
    setState(() {
      isRepeated = !isRepeated;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isRepeated ? 'Repeat On' : 'Repeat Off')),
    );
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
            // Handle shuffle action
            toggleShuffle();
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () {
            // Handle skip previous action
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Skip Previous')));
          },
        ),
        IconButton(
          iconSize: 38,
          icon: const Icon(Icons.play_arrow),
          selectedIcon: const Icon(Icons.pause),
          isSelected: isPlayed,
          onPressed: () {
            // Handle play action
            togglePlay();
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            // Handle skip next action
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Skip Next')));
          },
        ),
        IconButton(
          icon: const Icon(Icons.repeat),
          isSelected: isRepeated,
          selectedIcon: const Icon(Icons.repeat_on_rounded),
          onPressed: () {
            // Handle repeat action
            toggleRepeat();
          },
        ),
      ],
    );
  }
}
