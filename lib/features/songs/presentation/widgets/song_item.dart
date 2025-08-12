import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongItem extends StatelessWidget {
  const SongItem({required this.song, this.onTap, super.key});

  final SongModel song;
  final VoidCallback? onTap;

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
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite action
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('favorite pressed')));
            },
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              // Handle more action
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('more pressed')));
            },
          ),
        ],
      ),
    );
  }
}
