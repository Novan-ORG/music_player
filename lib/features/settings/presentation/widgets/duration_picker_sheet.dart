import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';
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
  late int _hours;
  late int _minutes;
  late int _seconds;

  late final WheelPickerController _hoursController;
  late final WheelPickerController _minutesController;
  late final WheelPickerController _secondsController;

  static const int _maxHours = 24;

  @override
  void initState() {
    super.initState();

    _hours = widget.initialDuration.inHours;
    _minutes = widget.initialDuration.inMinutes.remainder(60);
    _seconds = widget.initialDuration.inSeconds.remainder(60);

    _hoursController = WheelPickerController(
      itemCount: _maxHours,
      initialIndex: _hours,
    );
    _minutesController = WheelPickerController(
      itemCount: 60,
      initialIndex: _minutes,
    );
    _secondsController = WheelPickerController(
      itemCount: 60,
      initialIndex: _seconds,
    );
  }

  Duration get _selectedDuration => Duration(
    hours: _hours,
    minutes: _minutes,
    seconds: _seconds,
  );

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  Widget _buildWheel({
    required WheelPickerController controller,
    required int current,
    required ValueChanged<int> onChanged,
  }) {
    final style = WheelPickerStyle(
      itemExtent: 40,
      magnification: 1.3,
      surroundingOpacity: 0.3,
      diameterRatio: 0.7,
    );

    return Expanded(
      child: SizedBox(
        height: 200, // ارتفاع محدود برای جلوگیری از infinite height
        child: Stack(
          children: [
            // نوار انتخاب وسط
            Center(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            WheelPicker(
              controller: controller,
              onIndexChanged: (index, _) => onChanged(index),
              looping: true,
              style: style,
              selectedIndexColor: Theme.of(context).colorScheme.primary,
              builder: (context, index) {
                final bool isSelected = index == current;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSelected ? 22 : 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
              Text(
                _format(_selectedDuration),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildWheel(
                    controller: _hoursController,
                    current: _hours,
                    onChanged: (v) => setState(() => _hours = v),
                  ),
                  const SizedBox(width: 8),
                  _buildWheel(
                    controller: _minutesController,
                    current: _minutes,
                    onChanged: (v) => setState(() => _minutes = v),
                  ),
                  const SizedBox(width: 8),
                  _buildWheel(
                    controller: _secondsController,
                    current: _seconds,
                    onChanged: (v) => setState(() => _seconds = v),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.localization.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, _selectedDuration),
                      child: Text(context.localization.set),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
