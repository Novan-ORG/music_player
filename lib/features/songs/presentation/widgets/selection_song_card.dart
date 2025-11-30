import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';

class SelectionSongCard extends StatelessWidget {
  const SelectionSongCard({
    required this.song,
    required this.isSelected,
    this.onChanged,
    super.key,
  });
  final Song song;
  final bool isSelected;
  final void Function({bool? isSelected})? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 6,
      ),
      child: Row(
        spacing: 8,
        children: [
          SongImageWidget(songId: song.id, size: 54),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ArtistWidget(artist: song.artist),
            ],
          ),
          const Spacer(),
          Checkbox(
            value: isSelected,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (isSelected) => onChanged?.call(isSelected: isSelected),
          ),
        ],
      ),
    );
  }
}
