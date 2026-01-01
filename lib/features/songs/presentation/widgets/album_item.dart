import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

/// Album card widget for displaying album information.
///
/// Shows album artwork, name, artist, and song count.
class AlbumItem extends StatelessWidget {
  const AlbumItem({required this.album, this.onTap, super.key});

  final Album album;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final songLocalized = album.numOfSongs > 1
        ? context.localization.songs
        : context.localization.song;
    return GlassCard(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: onTap,
      child: ListTile(
        leading: ArtImageWidget(
          id: album.id,
          type: ArtworkType.ALBUM,
          defaultCover: ImageAssets.albumCover,
        ),
        title: Text(
          album.album,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${album.numOfSongs} $songLocalized',
          style: context.theme.textTheme.labelMedium,
        ),
        trailing: const Icon(Icons.arrow_right),
      ),
    );
  }
}
