import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    required this.song,
    this.onTap,
    this.isLiked = false,
    this.onToggleLike,
    this.onDeletePressed,
    this.onSetAsRingtonePressed,
    super.key,
  });

  final SongModel song;
  final VoidCallback? onTap;
  final bool isLiked;
  final VoidCallback? onToggleLike;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSetAsRingtonePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              Hero(
                tag: 'song_image_${song.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SongImageWidget(songId: song.id, size: 54),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.displayNameWOExt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        const Icon(Icons.person, size: 14, color: Colors.grey),
                        Text(
                          song.artist ?? 'Unknown Artist',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: isLiked ? 'Unlike' : 'Like',
          child: IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: onToggleLike,
          ),
        ),
        _buildPopupMenu(context),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'More options',
      onSelected: (value) {
        if (value == 'delete') {
          onDeletePressed?.call();
        } else if (value == 'ringtone') {
          onSetAsRingtonePressed?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.delete, color: Colors.red),
              Text(context.localization.delete),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ringtone',
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.music_note, color: Colors.blue),
              Text(context.localization.setAsRingtone),
            ],
          ),
        ),
      ],
    );
  }
}
