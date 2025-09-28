import 'dart:async';

import 'package:flutter/material.dart';
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
    unawaited(
      widget.volumeController.getVolume().then((initialVolume) {
        setState(() {
          _volume = initialVolume;
        });
      }),
    );

    _volumeSubscription = widget.volumeController.addListener((newVolume) {
      if (newVolume != _volume) {
        setState(() {
          _volume = newVolume;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    unawaited(_volumeSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_volume == 0 ? Icons.volume_mute : Icons.volume_down),
            onPressed: () async {
              await widget.volumeController.setMute(true);
            },
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(),
              ),
              child: Slider(
                value: _volume,
                onChanged: (newValue) async {
                  if (newValue != _volume) {
                    await widget.volumeController.setVolume(newValue);
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () async {
              await widget.volumeController.setVolume(1);
            },
          ),
        ],
      ),
    );
  }
}
