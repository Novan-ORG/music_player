import 'package:flutter/material.dart';

class MoreActionButtons extends StatelessWidget {
  const MoreActionButtons({
    super.key,
    this.onAddToPlaylistPressed,
    this.onSharePressed,
  });

  final VoidCallback? onAddToPlaylistPressed;
  final VoidCallback? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.playlist_add_outlined),
          onPressed: onAddToPlaylistPressed,
        ),
        IconButton(icon: const Icon(Icons.share), onPressed: onSharePressed),
      ],
    );
  }
}
