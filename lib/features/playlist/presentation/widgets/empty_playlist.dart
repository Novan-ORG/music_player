import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class EmptyPlaylist extends StatelessWidget {
  const EmptyPlaylist({super.key, this.onAddPressed});

  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.playlist_play, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.localization.noPlaylistFound,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(context.localization.createFirstPlaylist),
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
