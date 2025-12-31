import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:wheel_picker/wheel_picker.dart';

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

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              context.localization.selectSleepTimerDuration,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatDuration(_selectedDuration),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            DurationPicker(
              duration: _selectedDuration,
              onChange: (newDuration) {
                setState(() {
                  _selectedDuration = newDuration;
                });
              },
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.localization.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_selectedDuration),
                    child: Text(context.localization.set),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
