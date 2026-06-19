import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class HomeNavItem {
  const HomeNavItem({
    required this.icon,
    required this.label,
  });

  final Icon icon;
  final String label;
}

class HomeBottomNavDock extends StatelessWidget {
  const HomeBottomNavDock({
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    super.key,
  });

  final List<HomeNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.colorScheme.surface.withValues(
              alpha: isDark ? 0.9 : 0.96,
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: _BottomNavItem(
                      item: items[index],
                      selected: index == currentIndex,
                      onTap: () => onChanged(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSideNavRail extends StatelessWidget {
  const HomeSideNavRail({
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    super.key,
  });

  final List<HomeNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return SafeArea(
      left: isLtr,
      right: !isLtr,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.colorScheme.surface.withValues(
              alpha: isDark ? 0.7 : 0.82,
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            width: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < items.length; index++)
                  _SideNavItem(
                    item: items[index],
                    selected: index == currentIndex,
                    onTap: () => onChanged(index),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final HomeNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.62);

    return Tooltip(
      message: item.label,
      child: Semantics(
        selected: selected,
        button: true,
        label: item.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: selected
                  ? selectedColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              border: selected
                  ? Border.all(
                      color: selectedColor.withValues(alpha: 0.16),
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: selected ? selectedColor : unselectedColor,
                    size: selected ? 21 : 20,
                  ),
                  child: item.icon,
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: selected ? selectedColor : unselectedColor,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 10.5,
                    height: 1,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final HomeNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.66);

    return Tooltip(
      message: item.label,
      child: Semantics(
        selected: selected,
        button: true,
        label: item.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 44,
            height: 44,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: selected
                  ? selectedColor.withValues(alpha: 0.12)
                  : Colors.transparent,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: selected
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF9C27B0),
                          Color(0xFF00BFA6),
                        ],
                      )
                    : null,
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: selected ? Colors.white : unselectedColor,
                  size: selected ? 22 : 24,
                ),
                child: item.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
