import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class DurationPickerSheet extends StatefulWidget {
  const DurationPickerSheet({
    super.key,
    this.initialDuration = const Duration(minutes: 15),
  });

  final Duration initialDuration;

  @override
  State<DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  String _formattedDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    final hoursStr = '$hours ${context.localization.hours}';
    final minutesStr = '$minutes ${context.localization.minutes}';

    return hours > 0 ? '$hoursStr, $minutesStr' : minutesStr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BottomSheetBaseWidget(
      title: context.localization.sleepTimer,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final picker = SizedBox(
            height: isLandscape ? 180 : 200,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: theme.brightness,
                primaryColor: theme.primaryColor,
                scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: theme.textTheme.titleLarge,
                ),
              ),
              child: CupertinoDatePicker(
                onDateTimeChanged: (selectedDateTime) {
                  final now = DateTime.now();
                  var selectedDuration = selectedDateTime.difference(now);
                  if (selectedDuration.isNegative) {
                    selectedDuration += const Duration(hours: 24);
                  }
                  setState(() {
                    _selectedDuration = selectedDuration;
                  });
                },
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now().add(widget.initialDuration),
              ),
            ),
          );

          final summary = Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isLandscape
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  context.localization.selectSleepTimerDuration,
                  textAlign: isLandscape ? TextAlign.start : TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _formattedDuration(_selectedDuration),
                  textAlign: isLandscape ? TextAlign.start : TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Flex(
                  direction: isLandscape ? Axis.vertical : Axis.horizontal,
                  children: [
                    Expanded(
                      flex: isLandscape ? 0 : 1,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(context.localization.cancel),
                      ),
                    ),
                    SizedBox(
                      width: isLandscape ? 0 : 12,
                      height: isLandscape ? 12 : 0,
                    ),
                    Expanded(
                      flex: isLandscape ? 0 : 1,
                      child: FilledButton(
                        onPressed: () =>
                            Navigator.of(context).pop(_selectedDuration),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(context.localization.setTimer),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          if (isLandscape) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: picker,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 2,
                    child: summary,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                picker,
                const SizedBox(height: 16),
                summary,
              ],
            ),
          );
        },
      ),
    );
  }
}
