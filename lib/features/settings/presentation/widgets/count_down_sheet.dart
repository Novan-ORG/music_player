import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';

class CountDownSheet extends StatefulWidget {
  const CountDownSheet._({this.initialDuration, this.onCancel});

  final Duration? initialDuration;
  final VoidCallback? onCancel;

  static Future<Duration?> show({
    required BuildContext context,
    Duration? initialDuration,
    VoidCallback? onCancel,
  }) {
    return showAppModalBottomSheet<Duration?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => CountDownSheet._(
        initialDuration: initialDuration,
        onCancel: onCancel,
      ),
    );
  }

  @override
  State<CountDownSheet> createState() => _CountDownSheetState();
}

class _CountDownSheetState extends State<CountDownSheet> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: BottomSheetBaseWidget(
        title: context.localization.sleepTimer,
        bodyFlexible: true,
        body: widget.initialDuration != null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _ActiveTimerView(
                  duration: widget.initialDuration!,
                  onCancel: () {
                    widget.onCancel?.call();
                    Navigator.of(context).pop();
                  },
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _ActiveTimerView extends StatelessWidget {
  const _ActiveTimerView({
    required this.duration,
    required this.onCancel,
  });

  final Duration duration;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      child: CountDownTimer(
        duration: duration,
        builder: (context, value) {
          final hours = value.inHours;
          final minutes = value.inMinutes.remainder(60);
          final seconds = value.inSeconds.remainder(60);
          final progress = duration.inMilliseconds == 0
              ? 0.0
              : value.inMilliseconds / duration.inMilliseconds;

          final hero = _SleepTimerHero(
            isLandscape: isLandscape,
            hours: hours,
            minutes: minutes,
            seconds: seconds,
          );

          final details = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.localization.sleepTimerActive,
                textAlign: isLandscape ? TextAlign.start : TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: isLandscape
                    ? AlignmentDirectional.centerStart
                    : Alignment.center,
                child: _DurationSummary(
                  hours: hours,
                  minutes: minutes,
                ),
              ),
              const SizedBox(height: 16),
              _CountdownCard(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                progress: progress,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded),
                label: Text(context.localization.cancelTimer),
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(isLandscape ? 52 : 56),
                  backgroundColor: theme.colorScheme.error.withValues(
                    alpha: 0.96,
                  ),
                  foregroundColor: theme.colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ],
          );

          return isLandscape
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: hero,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 3,
                      child: details,
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    hero,
                    const SizedBox(height: 18),
                    details,
                  ],
                );
        },
      ),
    );
  }
}

class _SleepTimerHero extends StatelessWidget {
  const _SleepTimerHero({
    required this.isLandscape,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  final bool isLandscape;
  final int hours;
  final int minutes;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final compactTime = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:'
              '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.all(isLandscape ? 18 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            context.theme.colorScheme.primary.withValues(alpha: 0.18),
            context.theme.colorScheme.surface.withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isLandscape ? 70 : 78,
            height: isLandscape ? 70 : 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  theme.colorScheme.primary,
                  const Color(0xFF3559E6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(
              Icons.bedtime_rounded,
              size: isLandscape ? 30 : 34,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.nightlight_round,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.localization.sleepTimerActive,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              compactTime,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.progress,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.12),
            theme.colorScheme.surface.withValues(alpha: 0.99),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress.clamp(0, 1),
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.08,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${hours.toString().padLeft(2, '0')}:'
                '${minutes.toString().padLeft(2, '0')}:'
                '${seconds.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  color: theme.colorScheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                  child: _TimeStatChip(
                    label: context.localization.hours,
                    value: hours.toString().padLeft(2, '0'),
                    accentColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TimeStatChip(
                    label: context.localization.minutes,
                    value: minutes.toString().padLeft(2, '0'),
                    accentColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TimeStatChip(
                    value: seconds.toString().padLeft(2, '0'),
                    label: context.localization.seconds,
                    accentColor: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeStatChip extends StatelessWidget {
  const _TimeStatChip({
    required this.value,
    required this.accentColor,
    this.label,
  });

  final String value;
  final Color accentColor;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              if (label != null)
                Text(
                  label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationSummary extends StatelessWidget {
  const _DurationSummary({
    required this.hours,
    required this.minutes,
  });

  final int hours;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final summary = hours > 0
        ? '${hours.toString().padLeft(2, '0')} ${context.localization.hours}'
              '  •  '
              '${minutes.toString().padLeft(2, '0')} '
              '${context.localization.minutes}'
        : '${minutes.toString().padLeft(2, '0')} '
              '${context.localization.minutes}';

    return Text(
      summary,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
