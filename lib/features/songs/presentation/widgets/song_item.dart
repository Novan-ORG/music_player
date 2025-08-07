import 'package:flutter/material.dart';
import 'package:music_player/features/song_details/presentation/pages/song_details_page.dart';

class SongItem extends StatelessWidget {
  const SongItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SongDetailsPage()),
        );
      },
      title: Text('Song Title', style: Theme.of(context).textTheme.titleMedium),
      subtitle: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: 2,
        children: [
          Icon(Icons.person, size: 12),
          Text('Artist Name', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/images/song_cover.png',
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          alignment: Alignment.center,
        ),
      ),
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite action
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('favorite pressed')));
            },
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              // Handle more action
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('more pressed')));
            },
          ),
        ],
      ),
    );
  }
}
