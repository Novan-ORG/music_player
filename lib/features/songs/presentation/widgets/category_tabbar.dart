import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

double _lerp(num begin, num end, double t) =>
    ui.lerpDouble(begin.toDouble(), end.toDouble(), t)!;

class CategoryTabbar extends StatelessWidget {
  const CategoryTabbar({
    required this.tabController,
    this.compact = false,
    this.collapseProgress = 0,
    super.key,
    this.onTabChanged,
  });

  final TabController tabController;
  final bool compact;
  final double collapseProgress;
  final void Function(int index)? onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final labels = <String>[
      context.localization.allSongs,
      context.localization.albums,
      context.localization.artists,
      context.localization.folders,
    ];
    final baseProgress = compact ? 0.22 : 0.0;
    final targetProgress =
        (baseProgress + ((1 - baseProgress) * collapseProgress)).clamp(
          0.0,
          1.0,
        );

    return TweenAnimationBuilder<double>(
      tween: Tween(end: targetProgress),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
        final progress = Curves.easeOutCubic.transform(animatedProgress);
        final width = MediaQuery.sizeOf(context).width;
        final shouldScrollTabs = width < 390;
        return Container(
          height: _lerp(52, 44, progress),
          margin: EdgeInsetsGeometry.lerp(
            const EdgeInsets.symmetric(horizontal: 16),
            const EdgeInsets.symmetric(horizontal: 12),
            progress,
          ),
          padding: EdgeInsets.all(_lerp(4, 3, progress)),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(
              alpha: _lerp(
                isDark ? 0.72 : 0.9,
                isDark ? 0.82 : 0.96,
                progress,
              ),
            ),
            borderRadius: BorderRadius.circular(
              _lerp(20, 16, progress),
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(
                      alpha: _lerp(0.08, 0.06, progress),
                    )
                  : Colors.black.withValues(
                      alpha: _lerp(0.06, 0.05, progress),
                    ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _lerp(
                    isDark ? 0.22 : 0.08,
                    isDark ? 0.14 : 0.05,
                    progress,
                  ),
                ),
                blurRadius: _lerp(18, 12, progress),
                offset: Offset(0, _lerp(8, 5, progress)),
              ),
            ],
          ),
          child: TabBar(
            controller: tabController,
            onTap: (index) => onTabChanged?.call(index),
            isScrollable: shouldScrollTabs,
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: shouldScrollTabs ? TabAlignment.start : null,
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.symmetric(
              horizontal: shouldScrollTabs
                  ? _lerp(12, 8, progress)
                  : _lerp(10, 6, progress),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withValues(
              alpha: 0.76,
            ),
            labelStyle: TextStyle.lerp(
              theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              (shouldScrollTabs
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.labelLarge)
                  ?.copyWith(fontWeight: FontWeight.w800),
              progress,
            ),
            unselectedLabelStyle: TextStyle.lerp(
              theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              (shouldScrollTabs
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.labelLarge)
                  ?.copyWith(fontWeight: FontWeight.w600),
              progress,
            ),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _lerp(16, 13, progress),
              ),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9C27B0),
                  Color(0xFF00BFA6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(
                    alpha: _lerp(0.28, 0.18, progress),
                  ),
                  blurRadius: _lerp(16, 10, progress),
                  offset: Offset(0, _lerp(8, 4, progress)),
                ),
              ],
            ),
            tabs: labels
                .map(
                  (label) => Tab(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
