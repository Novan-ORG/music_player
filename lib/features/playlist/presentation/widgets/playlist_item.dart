import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/playlist_image_widget.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_item_more_action.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    required this.playlist,
    this.margin = const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    this.borderRadius = 16,
    this.songImageSize = 50,
    this.onTap,
    this.blurBackground = true,
    this.isPinned = false,
    this.onPinned,
    this.onAddMusicToPlaylist,
    super.key,
  });

  final Playlist playlist;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final double songImageSize;
  final bool blurBackground;
  final VoidCallback? onTap;

  final bool isPinned;

  // Callbacks
  final VoidCallback? onPinned;
  final VoidCallback? onAddMusicToPlaylist;

  @override
  Widget build(BuildContext context) {
    // Common row content used by both blurred and plain variants
    final content = Row(
      children: [
        PlaylistImageWidget(playlistId: playlist.id, size: songImageSize),
        const SizedBox(width: 12),
        Expanded(child: _buildTitle(context)),
        const SizedBox(width: 8),
        _buildActionButtons(context),
      ],
    );

    if (blurBackground) {
      // GlassCard already provides padding, tap and highlight behaviour.
      return GlassCard(
        margin: margin,
        borderRadius: borderRadius,
        padding: padding,
        onTap: onTap,
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(padding: EdgeInsets.zero, child: content),
        ),
      );
    }

    // Plain card without blur
    return Card(
      color: Colors.transparent,
      margin: margin,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: content,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: isPinned ? 'UnPinned' : 'Pinned',
          child: Transform.rotate(
            angle: 45,
            child: IconButton(
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin,
                color: isPinned ? Colors.red : Colors.grey,
              ),
              onPressed: onPinned,
            ),
          ),
        ),
        PlaylistItemMoreAction(
          playlist: playlist,
          onAddMusicToPlaylist: onAddMusicToPlaylist,
        ),
      ],
    );
  }
}
