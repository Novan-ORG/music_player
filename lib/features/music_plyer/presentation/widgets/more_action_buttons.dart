import 'package:flutter/material.dart';

class MoreActionButtons extends StatelessWidget {
  const MoreActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.playlist_add_outlined),
          onPressed: () {
            // Handle showing the list of all songs
          },
        ),
        IconButton(
          icon: const Icon(Icons.lyrics),
          onPressed: () {
            // Handle lyrics action
          },
        ),
      ],
    );
  }
}
