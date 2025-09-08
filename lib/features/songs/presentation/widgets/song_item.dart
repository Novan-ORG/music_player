import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    required this.song,
    this.onTap,
    this.isLiked = false,
    this.onToggleLike,
    this.onDeletePressed,
    super.key,
  });

  final SongModel song;
  final VoidCallback? onTap;
  final bool isLiked;
  final VoidCallback? onToggleLike;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        song.displayNameWOExt,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: 2,
        children: [
          Icon(Icons.person, size: 12),
          Flexible(
            child: Text(
              song.artist ?? 'unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      leading: QueryArtworkWidget(
        id: song.id,
        quality: 70,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(8.0),
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/song_cover.png',
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            alignment: Alignment.center,
          ),
        ),
      ),
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: onToggleLike,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == 'delete') {
                onDeletePressed?.call();
              } else if (value == 'ringtone') {
                // Handle set as ringtone action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Set as ringtone pressed')),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ringtone',
                child: Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Set as ringtone'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
