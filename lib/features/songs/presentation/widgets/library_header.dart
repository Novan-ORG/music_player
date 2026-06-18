import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

part 'library_header_components.dart';

double _lerp(num begin, num end, double t) =>
    ui.lerpDouble(begin.toDouble(), end.toDouble(), t)!;

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({
    required this.onSearchPressed,
    required this.onStartMixPressed,
    this.compact = false,
    this.collapseProgress = 0,
    super.key,
  });

  final VoidCallback onSearchPressed;
  final VoidCallback onStartMixPressed;
  final bool compact;
  final double collapseProgress;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1B1C1F);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isNarrow = width < 380;
        final isVeryNarrow = width < 332;

        return BlocBuilder<SongsBloc, SongsState>(
          buildWhen: (previous, next) =>
              previous.allSongs.length != next.allSongs.length ||
              previous.status != next.status,
          builder: (context, songsState) {
            final hasSongs = songsState.allSongs.isNotEmpty;
            final baseProgress = compact ? 0.32 : 0.0;
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
                final progress = Curves.easeOutCubic.transform(
                  animatedProgress,
                );
                final subtitleVisibility =
                    1 - Curves.easeIn.transform(progress.clamp(0.0, 1.0));
                final containerMargin = EdgeInsetsGeometry.lerp(
                  compact
                      ? const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8)
                      : const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  compact
                      ? const EdgeInsetsDirectional.fromSTEB(10, 6, 8, 6)
                      : const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  progress,
                )!;
                final containerPadding = EdgeInsets.lerp(
                  EdgeInsets.all(compact ? 14 : 18),
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  progress,
                )!;
                final contentSpacing = _lerp(compact ? 10 : 16, 8, progress);
                final titleStyle =
                    TextStyle.lerp(
                      compact || isNarrow
                          ? theme.textTheme.headlineSmall
                          : theme.textTheme.headlineMedium,
                      theme.textTheme.titleLarge,
                      progress,
                    )?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                    );
                final useStackedActions = isVeryNarrow && progress < 0.62;
                final forceIconMixButton = isNarrow && progress > 0.28;

                return Container(
                  margin: containerMargin,
                  padding: containerPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      _lerp(compact ? 24 : 28, 20, progress),
                    ),
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [
                        theme.colorScheme.primary.withValues(
                          alpha: _lerp(
                            isDark ? 0.5 : 0.3,
                            isDark ? 0.34 : 0.2,
                            progress,
                          ),
                        ),
                        const Color(0xFF00BFA6).withValues(
                          alpha: _lerp(
                            isDark ? 0.3 : 0.22,
                            isDark ? 0.18 : 0.12,
                            progress,
                          ),
                        ),
                        theme.colorScheme.surface.withValues(
                          alpha: _lerp(
                            isDark ? 0.8 : 0.9,
                            isDark ? 0.94 : 0.98,
                            progress,
                          ),
                        ),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: _lerp(
                          isDark ? 0.12 : 0.52,
                          isDark ? 0.08 : 0.34,
                          progress,
                        ),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: _lerp(
                            isDark ? 0.28 : 0.1,
                            isDark ? 0.18 : 0.06,
                            progress,
                          ),
                        ),
                        blurRadius: _lerp(26, 18, progress),
                        offset: Offset(0, _lerp(16, 10, progress)),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: contentSpacing,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: subtitleVisibility > 0.12 ? 4 : 0,
                              children: [
                                Text(
                                  context.localization.yourLibrary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: titleStyle,
                                ),
                                ClipRect(
                                  child: Align(
                                    heightFactor: subtitleVisibility,
                                    alignment: AlignmentDirectional.topStart,
                                    child: Opacity(
                                      opacity: subtitleVisibility.clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      child: Transform.translate(
                                        offset: Offset(0, -8 * progress),
                                        child: Text(
                                          context
                                              .localization
                                              .libraryHeroSubtitle,
                                          maxLines: compact || isNarrow ? 1 : 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: textColor.withValues(
                                                  alpha: 0.74,
                                                ),
                                                height: 1.35,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _lerp(12, 8, progress)),
                          _HeaderIconButton(
                            tooltip: context.localization.searchSongs,
                            icon: Icons.search_rounded,
                            onPressed: onSearchPressed,
                            collapseProgress: progress,
                          ),
                        ],
                      ),
                      if (useStackedActions) ...[
                        _LibraryStats(
                          songCount: songsState.allSongs.length,
                          collapseProgress: progress,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _StartMixButton(
                            enabled: hasSongs,
                            collapseProgress: progress,
                            onPressed: onStartMixPressed,
                            expand: true,
                          ),
                        ),
                      ] else
                        Row(
                          children: [
                            Expanded(
                              child: _LibraryStats(
                                songCount: songsState.allSongs.length,
                                collapseProgress: progress,
                              ),
                            ),
                            SizedBox(width: _lerp(12, 8, progress)),
                            _StartMixButton(
                              enabled: hasSongs,
                              collapseProgress: progress,
                              onPressed: onStartMixPressed,
                              forceIconOnly: forceIconMixButton,
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
