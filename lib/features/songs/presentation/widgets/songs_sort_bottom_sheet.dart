import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

class SongsSortBottomSheet extends StatefulWidget {
  const SongsSortBottomSheet._(
    this.selectedSortConfig,
  );

  final SortConfig selectedSortConfig;

  static Future<SortConfig?> show({
    required BuildContext context,
    SortConfig selectedSortConfig = const SortConfig(),
  }) {
    return showModalBottomSheet<SortConfig>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SongsSortBottomSheet._(selectedSortConfig),
    );
  }

  @override
  State<SongsSortBottomSheet> createState() => _SongsSortBottomSheetState();
}

class _SongsSortBottomSheetState extends State<SongsSortBottomSheet> {
  late SongsSortType selectedSortType = widget.selectedSortConfig.sortType;
  late SortOrderType selectedOrderType = widget.selectedSortConfig.orderType;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final shortestSide = mediaQuery.size.shortestSide;
    final isCompactHeight = mediaQuery.size.height < 560;
    final panelWidth = mediaQuery.size.width <= 560
        ? mediaQuery.size.width
        : (mediaQuery.size.width * 0.72).clamp(560.0, 760.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: panelWidth),
        child: DraggableScrollableSheet(
          initialChildSize: isCompactHeight ? 0.9 : 0.68,
          minChildSize: isCompactHeight ? 0.66 : 0.42,
          maxChildSize: shortestSide >= 600 ? 0.82 : 0.94,
          expand: false,
          builder: (context, scrollController) {
            return _SortSheetSurface(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _SheetHeader(
                      title: context.localization.sortSongs,
                      selectedSort: selectedSortType.toLocalizationString(
                        context,
                      ),
                      selectedOrder: _orderLabel(context, selectedOrderType),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 620;
                          return ListView(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              isWide ? 22 : 16,
                              6,
                              isWide ? 22 : 16,
                              14,
                            ),
                            children: [
                              _SectionHeader(
                                icon: Icons.tune_rounded,
                                title: context.localization.sortBy,
                              ),
                              const SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: SongsSortType.values.length,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: isWide ? 210 : 230,
                                      mainAxisExtent: 50,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemBuilder: (context, index) {
                                  final sortType = SongsSortType.values[index];
                                  return _SortChoicePill(
                                    icon: sortType.toIconData(),
                                    title: sortType.toLocalizationString(
                                      context,
                                    ),
                                    selected: sortType == selectedSortType,
                                    onTap: () {
                                      setState(
                                        () => selectedSortType = sortType,
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 18),
                              _SectionHeader(
                                icon: Icons.swap_vert_rounded,
                                title: context.localization.sortOrder,
                              ),
                              const SizedBox(height: 8),
                              _OrderSelector(
                                selectedOrderType: selectedOrderType,
                                orderLabel: _orderLabel,
                                onChanged: (orderType) {
                                  setState(
                                    () => selectedOrderType = orderType,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    _ApplySortButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          widget.selectedSortConfig.copyWith(
                            sortType: selectedSortType,
                            orderType: selectedOrderType,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _orderLabel(BuildContext context, SortOrderType orderType) {
    return switch (orderType) {
      SortOrderType.ascOrSmaller => context.localization.oldestFirst,
      SortOrderType.descOrGreater => context.localization.newestFirst,
    };
  }
}

class _SortSheetSurface extends StatelessWidget {
  const _SortSheetSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.36 : 0.16),
            blurRadius: 28,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.selectedSort,
    required this.selectedOrder,
  });

  final String title;
  final String selectedSort;
  final String selectedOrder;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Column(
        spacing: 10,
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Row(
            children: [
              _HeaderGlyph(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '$selectedSort • $selectedOrder',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.66,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderGlyph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primary = context.theme.colorScheme.primary;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            primary,
            const Color(0xFF00BFA6),
          ],
        ),
      ),
      child: const Icon(Icons.sort_rounded, color: Colors.white, size: 22),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      spacing: 7,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SortChoicePill extends StatelessWidget {
  const _SortChoicePill({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ChoiceSurface(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          _ChoiceIcon(icon: icon, selected: selected),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                color: selected ? context.theme.colorScheme.primary : null,
              ),
            ),
          ),
          if (selected)
            Icon(
              Icons.check_rounded,
              color: context.theme.colorScheme.primary,
              size: 19,
            ),
        ],
      ),
    );
  }
}

class _OrderSelector extends StatelessWidget {
  const _OrderSelector({
    required this.selectedOrderType,
    required this.orderLabel,
    required this.onChanged,
  });

  final SortOrderType selectedOrderType;
  final String Function(BuildContext context, SortOrderType orderType)
  orderLabel;
  final ValueChanged<SortOrderType> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackVertically = constraints.maxWidth < 390;
        final children = SortOrderType.values.map((orderType) {
          return _OrderChoicePill(
            icon: orderType.toIconData(),
            title: orderLabel(context, orderType),
            subtitle: orderType.toLocalizationString(context),
            selected: orderType == selectedOrderType,
            onTap: () => onChanged(orderType),
          );
        }).toList();

        if (stackVertically) {
          return Column(
            spacing: 8,
            children: children,
          );
        }

        return Row(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              Expanded(child: children[index]),
              if (index != children.length - 1) const SizedBox(width: 8),
            ],
          ],
        );
      },
    );
  }
}

class _OrderChoicePill extends StatelessWidget {
  const _OrderChoicePill({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return _ChoiceSurface(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          _ChoiceIcon(icon: icon, selected: selected),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 1,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: selected ? theme.colorScheme.primary : null,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.62,
                    ),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            Icon(
              Icons.check_rounded,
              color: theme.colorScheme.primary,
              size: 19,
            ),
        ],
      ),
    );
  }
}

class _ChoiceSurface extends StatelessWidget {
  const _ChoiceSurface({
    required this.selected,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: selected
            ? primary.withValues(alpha: isDark ? 0.18 : 0.1)
            : theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: isDark ? 0.24 : 0.42,
              ),
        border: Border.all(
          color: selected
              ? primary.withValues(alpha: 0.5)
              : theme.dividerColor.withValues(alpha: isDark ? 0.14 : 0.24),
          width: selected ? 1.1 : 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ChoiceIcon extends StatelessWidget {
  const _ChoiceIcon({
    required this.icon,
    required this.selected,
  });

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primary = theme.colorScheme.primary;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? primary.withValues(alpha: 0.14)
            : theme.dividerColor.withValues(alpha: 0.14),
      ),
      child: Icon(
        icon,
        size: 17,
        color: selected ? primary : theme.iconTheme.color,
      ),
    );
  }
}

class _ApplySortButton extends StatelessWidget {
  const _ApplySortButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.check_rounded),
          label: Text(context.localization.applySort),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
