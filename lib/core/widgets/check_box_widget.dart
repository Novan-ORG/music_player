import 'package:flutter/material.dart';
import 'package:music_player/core/theme/app_themes.dart';

/// Custom checkbox widget with configurable styling.
///
/// Features:
/// - Customizable color (defaults to theme primary color)
/// - Scaled appearance for better visibility
/// - Used in selection lists
class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    required this.isSelected,
    super.key,
    this.color,
  });

  final bool isSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;

    return Transform.scale(
      scale: 1.1,
      child: Checkbox(
        value: isSelected,
        onChanged: null,
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return Colors.black.withValues(alpha: 0.9);
          },
        ),
        checkColor: AppLightColors.surface,
      ),
    );
  }
}
