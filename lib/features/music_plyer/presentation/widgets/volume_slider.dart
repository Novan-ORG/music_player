import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({
    required this.volumeController,
    super.key,
  });

  final VolumeController volumeController;

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _volume = 0.5;
  late final StreamSubscription<double> _volumeSubscription;

  @override
  void initState() {
    super.initState();
    _initializeVolume();
    _listenToVolumeChanges();
  }

  @override
  void dispose() {
    unawaited(_volumeSubscription.cancel());
    super.dispose();
  }

  void _initializeVolume() {
    unawaited(
      widget.volumeController.getVolume().then((initialVolume) {
        if (mounted) {
          setState(() => _volume = initialVolume);
        }
      }),
    );
  }

  void _listenToVolumeChanges() {
    _volumeSubscription = widget.volumeController.addListener((newVolume) {
      if (mounted && newVolume != _volume) {
        setState(() => _volume = newVolume);
      }
    });
  }

  Future<void> _setVolume(double volume) async {
    await widget.volumeController.setVolume(volume);
  }

  Future<void> _mute() async {
    await widget.volumeController.setMute(true);
  }

  Future<void> _setMaxVolume() async {
    await _setVolume(1);
  }

  IconData get _volumeIcon =>
      _volume == 0 ? Icons.volume_mute : Icons.volume_down;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;
          final actionButtonSize = isCompact ? 44.0 : 48.0;
          final horizontalGap = isCompact ? 8.0 : 12.0;

          return Row(
            children: [
              _VolumeActionButton(
                icon: _volumeIcon,
                isHighlighted: _volume == 0,
                size: actionButtonSize,
                onPressed: _mute,
              ),
              SizedBox(width: horizontalGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${(_volume * 100).round()}%',
                            style: context.theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.72,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _volume == 0
                              ? context.localization.muted
                              : context.localization.volume,
                          style: context.theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.52,
                            ),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _volume,
                      padding: EdgeInsets.zero,
                      divisions: 100,
                      onChanged: (newValue) {
                        if (newValue != _volume) {
                          _setVolume(newValue);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: horizontalGap),
              _VolumeActionButton(
                icon: Icons.volume_up_rounded,
                size: actionButtonSize,
                onPressed: _setMaxVolume,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VolumeActionButton extends StatelessWidget {
  const _VolumeActionButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    this.isHighlighted = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHighlighted
            ? colorScheme.primary.withValues(alpha: 0.12)
            : colorScheme.surface.withValues(alpha: 0.68),
        border: Border.all(
          color: isHighlighted
              ? colorScheme.primary.withValues(alpha: 0.24)
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isHighlighted
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.82),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
