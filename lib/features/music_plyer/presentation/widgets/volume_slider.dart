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

  IconData get _volumeIcon =>
      _volume == 0 ? Icons.volume_mute : Icons.volume_down;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              _volumeIcon,
              color: _volume == 0 ? context.theme.colorScheme.secondary : null,
            ),
            onPressed: _mute,
          ),
          Expanded(
            child: Slider(
              value: _volume,
              padding: EdgeInsets.zero,
              divisions: 100,
              onChanged: (newValue) {
                if (newValue != _volume) {
                  _setVolume(newValue);
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => _setVolume(1),
          ),
        ],
      ),
    );
  }
}
