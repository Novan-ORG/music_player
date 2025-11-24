import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';

class PlaylistImageWidget extends StatelessWidget {
  const PlaylistImageWidget({
    required this.playlistId,
    this.size = 50,
    this.borderRadius = 12,
    this.artworkFit = BoxFit.cover,
    super.key,
  });

  final int playlistId;
  final double size;
  final double borderRadius;
  final BoxFit artworkFit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            ImageAssets.talebAvatar,
            fit: artworkFit,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
