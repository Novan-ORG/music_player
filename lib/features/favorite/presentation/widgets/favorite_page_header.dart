import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/app_popup_menu.dart';
import 'package:music_player/core/widgets/songs_count.dart';
import 'package:music_player/extensions/extensions.dart';

class FavoritePageHeader extends StatelessWidget {
  const FavoritePageHeader({
    required this.favoriteCount,
    super.key,
    this.collapseProgress = 0,
    this.onClearAllPressed,
  });

  final int favoriteCount;
  final double collapseProgress;
  final VoidCallback? onClearAllPressed;

  bool get _hasActions => onClearAllPressed != null && favoriteCount > 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final progress = Curves.easeOutCubic.transform(collapseProgress);
    final titleColor = isDark ? Colors.white : const Color(0xFF1F2023);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isNarrow = constraints.maxWidth < 390;
        final compact = progress > 0.5 || isLandscape;
        final subtitleVisibility = 1 - Curves.easeIn.transform(progress);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            compact ? 6 : 12,
          ),
          padding: EdgeInsets.all(compact ? 16 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 22 : 28),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                theme.colorScheme.primary.withValues(
                  alpha: isDark ? 0.5 : 0.24,
                ),
                const Color(0xFFE85D75).withValues(alpha: isDark ? 0.22 : 0.14),
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
                blurRadius: compact ? 18 : 26,
                offset: Offset(0, compact ? 10 : 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: compact ? 52 : 60,
                    height: compact ? 52 : 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.12 : 0.78,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: isDark ? 0.08 : 0.36,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: compact ? 26 : 30,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.favoriteSongs,
                          style:
                              (compact
                                      ? theme.textTheme.headlineSmall
                                      : theme.textTheme.headlineMedium)
                                  ?.copyWith(
                                    color: titleColor,
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
                                  context.localization.favoriteSongsPage,
                                  maxLines: isNarrow ? 3 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: titleColor.withValues(alpha: 0.72),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_hasActions) ...[
                    const SizedBox(width: 12),
                    AppPopupMenuButton<_FavoriteHeaderAction>(
                      compact: true,
                      tooltip: context.localization.moreOptions,
                      isHighlighted: true,
                      highlightColor: theme.colorScheme.error,
                      onSelected: (value) {
                        if (value == _FavoriteHeaderAction.clearAll) {
                          onClearAllPressed?.call();
                        }
                      },
                      items: [
                        AppPopupMenuEntry(
                          value: _FavoriteHeaderAction.clearAll,
                          label: context.localization.clearAll,
                          icon: Icons.heart_broken_rounded,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              SizedBox(height: compact ? 12 : 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _HeaderMetricChip(
                    icon: Icons.favorite_rounded,
                    label: SongsCount(songCount: favoriteCount),
                  ),
                  if (_hasActions && !compact)
                    _HeaderMetricChip(
                      icon: Icons.auto_awesome_rounded,
                      label: Text(context.localization.like),
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

enum _FavoriteHeaderAction { clearAll }

class _HeaderMetricChip extends StatelessWidget {
  const _HeaderMetricChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          IconTheme.merge(
            data: IconThemeData(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              size: 16,
            ),
            child: DefaultTextStyle.merge(
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              child: label,
            ),
          ),
        ],
      ),
    );
  }
}
