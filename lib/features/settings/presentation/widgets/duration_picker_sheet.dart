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
  int _pickerVersion = 0;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  void _updateSelectedDuration(Duration duration) {
    setState(() {
      _selectedDuration = duration;
      _pickerVersion++;
    });
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

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: BottomSheetBaseWidget(
        bodyFlexible: true,
        title: context.localization.sleepTimer,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final presets = <({Duration duration, String label})>[
              (
                duration: const Duration(minutes: 15),
                label: context.localization.min15,
              ),
              (
                duration: const Duration(minutes: 30),
                label: context.localization.min30,
              ),
              (
                duration: const Duration(hours: 1),
                label: context.localization.hour1,
              ),
            ];
            final picker = Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
              child: SizedBox(
                height: isLandscape ? 180 : 210,
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
                    key: ValueKey(_pickerVersion),
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
                    initialDateTime: DateTime.now().add(_selectedDuration),
                  ),
                ),
              ),
            );

            final summary = Container(
              padding: EdgeInsets.all(isLandscape ? 18 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.16),
                    theme.colorScheme.surface.withValues(alpha: 0.98),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.14),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isLandscape
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Container(
                    width: isLandscape ? 52 : 58,
                    height: isLandscape ? 52 : 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      Icons.bedtime_rounded,
                      color: theme.colorScheme.primary,
                      size: isLandscape ? 26 : 30,
                    ),
                  ),
                  const SizedBox(height: 14),
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
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: isLandscape
                        ? AlignmentDirectional.centerStart
                        : Alignment.center,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: presets.map((preset) {
                        final isSelected =
                            _selectedDuration.inMinutes ==
                            preset.duration.inMinutes;
                        return ChoiceChip(
                          label: Text(preset.label),
                          selected: isSelected,
                          onSelected: (_) =>
                              _updateSelectedDuration(preset.duration),
                          labelStyle: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.surface,
                          side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.08,
                                  ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );

            final actions = Flex(
              direction: isLandscape ? Axis.vertical : Axis.horizontal,
              children: [
                Expanded(
                  flex: isLandscape ? 0 : 1,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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
                  child: FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pop(_selectedDuration),
                    icon: const Icon(Icons.timer_rounded),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    label: Text(context.localization.setTimer),
                  ),
                ),
              ],
            );

            final content = isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: picker,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            summary,
                            const SizedBox(height: 14),
                            actions,
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      summary,
                      const SizedBox(height: 16),
                      picker,
                      const SizedBox(height: 16),
                      actions,
                    ],
                  );

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: content,
            );
          },
        ),
      ),
    );
  }
}
