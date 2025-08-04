import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();
    return Scaffold(
      appBar: AppBar(title: const Text('Songs Page')),
      body: Center(
        child: FutureBuilder<List<SongModel>>(
          future: (() async {
            final permissionStatus = await OnAudioQuery().permissionsRequest();
            if (!permissionStatus) {
              throw Exception('Permission denied');
            } else {
              final result = await OnAudioQuery().querySongs();
              return result;
            }
          })(),
          builder: (_, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapShot.hasError) {
              return Text('Error: ${snapShot.error}');
            } else {
              return ListView.builder(
                itemCount: snapShot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final song = snapShot.data![index];
                  return ListTile(
                    title: Text(song.title),
                    subtitle: Text(song.artist ?? 'Unknown Artist'),
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.fill,
                    ),
                    onTap: () async {
                      try {
                        await audioPlayer.setAudioSource(
                          AudioSource.uri(Uri.parse(song.uri!)),
                        );
                        await audioPlayer.play();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error playing song: $e')),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
