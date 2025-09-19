import 'dart:async';

import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeSlider extends StatefulWidget {
  final VolumeController volumeController;

  const VolumeSlider({super.key, required this.volumeController});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _volume = 0.5;

  late final StreamSubscription _volumeSubscription;

  @override
  void initState() {
    widget.volumeController.getVolume().then((initialVolume) {
      setState(() {
        _volume = initialVolume;
      });
    });

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
    _volumeSubscription.cancel();
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
            onPressed: () {
              widget.volumeController.setMute(true);
            },
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: Slider(
                value: _volume,
                min: 0,
                max: 1,
                onChanged: (newValue) {
                  if (newValue != _volume) {
                    widget.volumeController.setVolume(newValue);
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () {
              widget.volumeController.setVolume(1);
            },
          ),
        ],
      ),
    );
  }
}
