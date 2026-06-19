import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({required this.folder, this.onTap, super.key});

  final Folder folder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final songLocalized = folder.songCount > 1
        ? context.localization.songs
        : context.localization.song;

    return GlassCard(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      padding: const EdgeInsets.all(10),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      onTap: onTap,
      child: Row(
        children: [
          const _FolderIconBadge(size: 64),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  folder.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${folder.songCount} $songLocalized',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.76,
                    ),
                  ),
                ),
                Text(
                  folder.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.62,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _FolderIconBadge extends StatelessWidget {
  const _FolderIconBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    const amber = Color(0xFFFFB300);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            amber.withValues(alpha: isDark ? 0.34 : 0.24),
            primary.withValues(alpha: isDark ? 0.22 : 0.16),
            if (isDark) const Color(0xFF202124) else Colors.white,
          ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : amber.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: amber.withValues(alpha: isDark ? 0.18 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.folder_rounded,
            size: size * 0.5,
            color: isDark
                ? Colors.white.withValues(alpha: 0.92)
                : const Color(0xFF202124),
          ),
          PositionedDirectional(
            end: 6,
            bottom: 7,
            child: Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF202124) : Colors.white,
                border: Border.all(
                  color: primary.withValues(alpha: 0.38),
                ),
              ),
              child: Icon(
                Icons.music_note_rounded,
                size: size * 0.19,
                color: amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
