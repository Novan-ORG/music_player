import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class SelectionSongCard extends StatelessWidget {
  const SelectionSongCard({
    required this.song,
    required this.isSelected,
    this.onChanged,
    this.onTap,
    super.key,
  });
  final Song song;
  final bool isSelected;
  final void Function({bool? isSelected})? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final selectionColor = theme.colorScheme.primary;

    return GlassCard(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.all(10),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isSelected
            ? [
                selectionColor.withValues(alpha: 0.14),
                theme.colorScheme.surface.withValues(alpha: 0.96),
              ]
            : [
                theme.colorScheme.surface.withValues(alpha: 0.9),
                theme.colorScheme.surface.withValues(alpha: 0.82),
              ],
      ),
      borderColor: isSelected
          ? selectionColor.withValues(alpha: 0.2)
          : theme.colorScheme.outline.withValues(alpha: 0.1),
      boxShadow: [
        BoxShadow(
          color: (isSelected ? selectionColor : Colors.black).withValues(
            alpha: isSelected ? 0.1 : 0.04,
          ),
          blurRadius: isSelected ? 18 : 12,
          offset: Offset(0, isSelected ? 8 : 6),
        ),
      ],
      child: Row(
        children: [
          _SelectionIndicator(
            isSelected: isSelected,
            onTap: () => onChanged?.call(isSelected: !isSelected),
          ),
          const SizedBox(width: 10),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ArtImageWidget(
                id: song.id,
                size: 52,
                borderRadius: 16,
              ),
              if (isSelected)
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectionColor,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isSelected ? selectionColor : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ArtistWidget(artist: song.artist),
                    ),
                    const SizedBox(width: 8),
                    _MetaPill(
                      icon: Icons.schedule_rounded,
                      label: song.duration.format(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final selectionColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? selectionColor
              : theme.colorScheme.surface.withValues(alpha: 0.9),
          border: Border.all(
            color: isSelected
                ? selectionColor
                : theme.colorScheme.outline.withValues(alpha: 0.36),
            width: 1.5,
          ),
        ),
        child: Icon(
          isSelected ? Icons.check_rounded : Icons.add_rounded,
          size: 18,
          color: isSelected
              ? Colors.white
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final pillColor = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.42,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
