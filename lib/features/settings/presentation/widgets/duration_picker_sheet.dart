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
    return BottomSheetBaseWidget(
      title: context.localization.sleepTimer,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: context.theme.brightness,
                primaryColor: context.theme.primaryColor,
                scaffoldBackgroundColor: context.theme.scaffoldBackgroundColor,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: context.theme.textTheme.titleLarge,
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
          ),
          Text(
            _formattedDuration(_selectedDuration),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: context.theme.colorScheme.surfaceDim,
                ),
                child: Text(
                  context.localization.cancel,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selectedDuration),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(150),
                  backgroundColor: context.theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  context.localization.setTimer,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
