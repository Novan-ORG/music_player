import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';

class SongInfo extends StatelessWidget {
  const SongInfo({
    required this.song,
    this.onLikePressed,
    this.onAddToPlaylistPressed,
    this.onSetAsRingtonePressed,
    this.onDeletePressed,
    super.key,
  });

  final Song? song;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSetAsRingtonePressed;
  final VoidCallback? onAddToPlaylistPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final onSurface = context.theme.colorScheme.onSurface;
    final artist = song?.artist ?? context.localization.unknownArtist;
    final albumName = song?.album;
    final album = (albumName?.trim().isNotEmpty ?? false)
        ? albumName!
        : context.localization.unknownAlbum;

    return GlassCard(
      borderRadius: BorderRadius.circular(28),
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chipMaxWidth = math
              .max(
                132,
                math.min(220, (constraints.maxWidth - 12) / 2),
              )
              .toDouble();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          song?.displayNameWOExt ?? context.localization.song,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelMedium?.copyWith(
                            color: onSurface.withValues(alpha: 0.62),
                            letterSpacing: 0.4,
                          ),
                        ),
                        SongTitle(songTitle: song?.title),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
                    selector: (state) => state.favoriteSongIds,
                    builder: (context, likedSongIds) {
                      final isLiked = likedSongIds.contains(song?.id ?? -1);
                      return _ActionIconButton(
                        icon: isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: context.theme.primaryColor,
                        onPressed: song == null ? null : onLikePressed,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  SongItemMoreOptionMenu(
                    isInPlaylist: false,
                    isCurrentTrack: false,
                    showShare: false,
                    onAddToPlaylist: onAddToPlaylistPressed,
                    onDelete: onDeletePressed,
                    onSetAsRingtone: onSetAsRingtonePressed,
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetaChip(
                    icon: Icons.person_outline_rounded,
                    label: context.localization.artist,
                    value: artist,
                    maxWidth: chipMaxWidth,
                  ),
                  _MetaChip(
                    icon: Icons.album_outlined,
                    label: context.localization.album,
                    value: album,
                    maxWidth: chipMaxWidth,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.maxWidth,
  });

  final IconData icon;
  final String label;
  final String value;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    this.onPressed,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.58),
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? colorScheme.onSurface),
      ),
    );
  }
}
