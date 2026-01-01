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
    return showModalBottomSheet<Duration?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
    return BottomSheetBaseWidget(
      body: widget.initialDuration != null
          ? _ActiveTimerView(
              duration: widget.initialDuration!,
              onCancel: () {
                widget.onCancel?.call();
                Navigator.of(context).pop();
              },
            )
          : const SizedBox.shrink(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.sleepTimerActive,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CountDownTimer(duration: duration, fontSize: 38),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel),
              label: Text(context.localization.cancelTimer),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
