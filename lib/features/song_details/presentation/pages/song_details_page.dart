import 'package:flutter/material.dart';
import 'package:music_player/features/song_details/presentation/widgets/audio_progress.dart';
import 'package:music_player/features/song_details/presentation/widgets/more_action_buttons.dart';
import 'package:music_player/features/song_details/presentation/widgets/player_action_buttons.dart';
import 'package:music_player/features/song_details/presentation/widgets/upnext_musics.dart';

class SongDetailsPage extends StatelessWidget {
  const SongDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Song Details')),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 12,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/song_cover.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.height * 0.33,
                  height: MediaQuery.of(context).size.height * 0.33,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Row(
              spacing: 16,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Song Title',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Artist Name',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
              ],
            ),
            AudioProgress(
              progress: 0.5,
              duration: const Duration(minutes: 3, seconds: 30),
              position: const Duration(minutes: 1, seconds: 45),
              onSeek: (newPosition) {
                // Handle seek action
                debugPrint('Seek to $newPosition');
              },
              onChangeEnd: (newPosition) {
                // Handle change end action
                debugPrint('Change ended at $newPosition');
              },
              onChangeStart: (newPosition) {
                // Handle change start action
                debugPrint('Change started at $newPosition');
              },
            ),
            MoreActionButtons(),
            UpnextMusics(),
            PlayerActionButtons(),
          ],
        ),
      ),
    );
  }
}
