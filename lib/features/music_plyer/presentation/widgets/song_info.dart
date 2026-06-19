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
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chipMaxWidth = math
              .max(
                144,
                math.min(280, constraints.maxWidth * 0.52),
              )
              .toDouble();
          final isCompact = constraints.maxWidth < 400;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          song?.displayNameWOExt ?? context.localization.song,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: onSurface.withValues(alpha: 0.56),
                            letterSpacing: 0.32,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SongTitle(songTitle: song?.title),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 6),
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
              SizedBox(height: isCompact ? 10 : 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _MetaChip(
                      icon: Icons.person_outline_rounded,
                      label: context.localization.artist,
                      value: artist,
                      maxWidth: chipMaxWidth,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.album_outlined,
                      label: context.localization.album,
                      value: album,
                      maxWidth: chipMaxWidth,
                    ),
                  ],
                ),
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
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
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
            size: 15,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 7),
          SizedBox(
            width: maxWidth,
            child: Row(
              children: [
                Text(
                  label,
                  style: context.theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.62),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.32),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
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
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        padding: EdgeInsets.zero,
        splashRadius: 20,
        icon: Icon(icon, color: color ?? colorScheme.onSurface),
      ),
    );
  }
}
