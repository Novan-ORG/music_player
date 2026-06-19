import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class PlaylistHomeHeader extends StatelessWidget {
  const PlaylistHomeHeader({
    required this.onCreatePressed,
    this.collapseProgress = 0,
    super.key,
  });

  final VoidCallback onCreatePressed;
  final double collapseProgress;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1B1C1F);
    final progress = Curves.easeOutCubic.transform(collapseProgress);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 390;
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final subtitleVisibility = 1 - Curves.easeIn.transform(progress);
        final iconOnlyButton = isNarrow || progress > 0.64;
        final compactMetrics = progress > 0.55 || isLandscape;
        final compactTitle = progress > 0.42 || isLandscape;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            progress > 0.5 ? 6 : 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: progress > 0.55 ? 14 : 18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(progress > 0.5 ? 22 : 28),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                theme.colorScheme.primary.withValues(
                  alpha: isDark ? 0.5 : 0.24,
                ),
                const Color(0xFF00BFA6).withValues(alpha: isDark ? 0.24 : 0.15),
                theme.colorScheme.surface.withValues(
                  alpha: isDark ? 0.88 : 0.95,
                ),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.42),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.06),
                blurRadius: progress > 0.5 ? 18 : 26,
                offset: Offset(0, progress > 0.5 ? 10 : 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNarrow && progress < 0.34) ...[
                _PlaylistHeaderText(
                  compactTitle: compactTitle,
                  textColor: textColor,
                  subtitleVisibility: subtitleVisibility,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _CreatePlaylistButton(
                    iconOnly: false,
                    onPressed: onCreatePressed,
                  ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _PlaylistHeaderText(
                        compactTitle: compactTitle,
                        textColor: textColor,
                        subtitleVisibility: subtitleVisibility,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _CreatePlaylistButton(
                      iconOnly: iconOnlyButton,
                      onPressed: onCreatePressed,
                    ),
                  ],
                ),
              SizedBox(height: compactMetrics ? 10 : 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetricPill(
                    compact: compactMetrics,
                    icon: Icons.queue_music_rounded,
                    label: context.localization.playlists,
                  ),
                  _MetricPill(
                    compact: compactMetrics,
                    icon: Icons.push_pin_rounded,
                    label: context.localization.favoritePlaylists,
                  ),
                  if (!compactMetrics)
                    _MetricPill(
                      compact: false,
                      icon: Icons.play_circle_outline_rounded,
                      label: context.localization.recentlyPlayed,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlaylistHeaderText extends StatelessWidget {
  const _PlaylistHeaderText({
    required this.compactTitle,
    required this.textColor,
    required this.subtitleVisibility,
  });

  final bool compactTitle;
  final Color textColor;
  final double subtitleVisibility;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.playlists,
          style:
              (compactTitle
                      ? theme.textTheme.headlineSmall
                      : theme.textTheme.headlineMedium)
                  ?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
        ),
        ClipRect(
          child: Align(
            heightFactor: subtitleVisibility,
            alignment: AlignmentDirectional.topStart,
            child: Opacity(
              opacity: subtitleVisibility.clamp(0.0, 1.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  context.localization.playlistHeroSubtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor.withValues(alpha: 0.72),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CreatePlaylistButton extends StatelessWidget {
  const _CreatePlaylistButton({
    required this.onPressed,
    required this.iconOnly,
  });

  final VoidCallback onPressed;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF202124),
      padding: EdgeInsets.symmetric(
        horizontal: iconOnly ? 12 : 16,
        vertical: 13,
      ),
      minimumSize: Size(iconOnly ? 46 : 0, 46),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      textStyle: context.theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: iconOnly
          ? Tooltip(
              key: const ValueKey('playlist-create-icon'),
              message: context.localization.createPlaylist,
              child: FilledButton(
                onPressed: onPressed,
                style: style,
                child: const Icon(Icons.add_rounded, size: 20),
              ),
            )
          : FilledButton.icon(
              key: const ValueKey('playlist-create-label'),
              onPressed: onPressed,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(context.localization.createPlaylist),
              style: style,
            ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 14,
        vertical: compact ? 8 : 9,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.2 : 0.06,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 15 : 16,
            color: theme.colorScheme.onSurface,
          ),
          SizedBox(width: compact ? 6 : 8),
          Text(
            label,
            style:
                (compact
                        ? theme.textTheme.labelMedium
                        : theme.textTheme.labelLarge)
                    ?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
          ),
        ],
      ),
    );
  }
}
