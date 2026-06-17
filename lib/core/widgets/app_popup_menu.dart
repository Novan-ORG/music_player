import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class AppPopupMenuEntry<T> {
  const AppPopupMenuEntry({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  final T value;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final bool isDestructive;
}

class AppPopupMenuButton<T> extends StatelessWidget {
  const AppPopupMenuButton({
    required this.items,
    required this.onSelected,
    super.key,
    this.tooltip,
    this.enabled = true,
    this.icon = Icons.more_vert_rounded,
    this.highlightColor,
    this.isHighlighted = false,
    this.offset = const Offset(0, 12),
  });

  final List<AppPopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;
  final String? tooltip;
  final bool enabled;
  final IconData icon;
  final Color? highlightColor;
  final bool isHighlighted;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final resolvedHighlightColor = highlightColor ?? colorScheme.primary;

    return PopupMenuButton<T>(
      enabled: enabled && items.isNotEmpty,
      tooltip: tooltip,
      elevation: 0,
      padding: EdgeInsets.zero,
      offset: offset,
      color: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      onSelected: onSelected,
      icon: _MenuTriggerIcon(
        icon: icon,
        isEnabled: enabled && items.isNotEmpty,
        isHighlighted: isHighlighted,
        highlightColor: resolvedHighlightColor,
      ),
      itemBuilder: (context) => [
        for (var index = 0; index < items.length; index++)
          PopupMenuItem<T>(
            value: items[index].value,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: _MenuActionTile(entry: items[index]),
          ),
      ],
    );
  }
}

class _MenuTriggerIcon extends StatelessWidget {
  const _MenuTriggerIcon({
    required this.icon,
    required this.isEnabled,
    required this.isHighlighted,
    required this.highlightColor,
  });

  final IconData icon;
  final bool isEnabled;
  final bool isHighlighted;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHighlighted
            ? highlightColor.withValues(alpha: 0.12)
            : colorScheme.surface.withValues(alpha: 0.6),
        border: Border.all(
          color: isHighlighted
              ? highlightColor.withValues(alpha: 0.24)
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Icon(
        icon,
        color: isHighlighted
            ? highlightColor
            : colorScheme.onSurface.withValues(alpha: isEnabled ? 0.88 : 0.34),
      ),
    );
  }
}

class _MenuActionTile<T> extends StatelessWidget {
  const _MenuActionTile({required this.entry});

  final AppPopupMenuEntry<T> entry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final resolvedIconColor =
        entry.iconColor ??
        (entry.isDestructive ? colorScheme.error : colorScheme.primary);
    final labelColor = entry.isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: resolvedIconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              entry.icon,
              color: resolvedIconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
