import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_image_widget.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_item_more_action.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    required this.playlist,
    this.margin = const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    this.borderRadius = 22,
    this.onTap,
    this.blurBackground = true,
    this.isPinned = false,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.compact = false,
    this.onPinned,
    this.onAddMusicToPlaylist,
    super.key,
  });

  final Playlist playlist;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final bool blurBackground;
  final VoidCallback? onTap;

  final bool isPinned;
  final bool isSelectionMode;
  final bool isSelected;
  final bool compact;

  // Callbacks
  final VoidCallback? onPinned;
  final VoidCallback? onAddMusicToPlaylist;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final selectionGradient = isSelectionMode
        ? LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: isSelected
                ? [
                    theme.colorScheme.primary.withValues(alpha: 0.18),
                    const Color(0xFF00BFA6).withValues(alpha: 0.09),
                    theme.colorScheme.surface.withValues(
                      alpha: isDark ? 0.42 : 0.92,
                    ),
                  ]
                : [
                    theme.colorScheme.surface.withValues(
                      alpha: isDark ? 0.34 : 0.94,
                    ),
                    theme.colorScheme.surface.withValues(
                      alpha: isDark ? 0.22 : 0.82,
                    ),
                  ],
          )
        : LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              theme.colorScheme.surface.withValues(alpha: isDark ? 0.34 : 0.92),
              theme.colorScheme.surface.withValues(alpha: isDark ? 0.2 : 0.76),
            ],
          );
    final cardBorderColor = isSelectionMode && isSelected
        ? theme.colorScheme.primary.withValues(alpha: 0.46)
        : null;
    final cardBorderWidth = isSelectionMode && isSelected ? 1.2 : null;
    final cardShadow = isSelectionMode && isSelected
        ? [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ]
        : null;

    final content = Row(
      children: [
        PlaylistImageWidget(
          playlistId: playlist.id,
          size: compact ? 54 : 60,
          borderRadius: compact ? 14 : 16,
        ),
        SizedBox(width: compact ? 8 : 10),
        Expanded(child: _buildTitle(context)),
        const SizedBox(width: 6),
        if (isSelectionMode)
          _SelectionIndicator(isSelected: isSelected)
        else
          _buildActionButtons(context),
      ],
    );

    if (blurBackground) {
      return GlassCard(
        margin: margin,
        borderRadius: BorderRadius.circular(borderRadius),
        padding: padding,
        onTap: onTap,
        gradient: selectionGradient,
        borderColor: cardBorderColor,
        borderWidth: cardBorderWidth,
        boxShadow: cardShadow,
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
      spacing: 3,
      children: [
        if (isPinned && !isSelectionMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              context.localization.pinned,
              style: context.theme.textTheme.labelSmall?.copyWith(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        Text(
          playlist.name,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style:
              (compact
                      ? Theme.of(context).textTheme.titleSmall
                      : Theme.of(context).textTheme.titleMedium)
                  ?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
        SongsCount(
          songCount: playlist.numOfSongs,
          isPlaylistItem: true,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = context.theme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: isPinned
              ? context.localization.unpinPlaylist
              : context.localization.pinPlaylist,
          child: IconButton.filledTonal(
            onPressed: onPinned,
            icon: Transform.rotate(
              angle: 0.75,
              child: Icon(
                Icons.push_pin_rounded,
                color: isPinned
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.66),
              ),
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.7),
              minimumSize: Size.square(compact ? 34 : 38),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface.withValues(alpha: 0.92),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.24),
          width: 1.6,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: isSelected
          ? Icon(
              Icons.check_rounded,
              size: 18,
              color: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
