import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

/// Frosted glass effect card widget using glassmorphism design.
///
/// Features:
/// - Configurable blur effect (sigmaX, sigmaY)
/// - Customizable border radius and padding
/// - Tap and long-press callbacks
/// - Transparent frosted glass appearance
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final double sigmaX;
  final double sigmaY;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          // use provided sigmaX/sigmaY for the blur amount
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
                width: 0.25,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.04),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.28),
                        Colors.white.withValues(alpha: 0.08),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onTap,
                onLongPress: onLongPress,
                splashColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                highlightColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
