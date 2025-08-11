import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/music_player_page.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/song_item.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<SongsBloc, SongsState>(
        builder: (_, state) {
          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == SongsStatus.error) {
            return const Center(child: Text('Error loading songs'));
          } else if (state.songs.isEmpty) {
            return const Center(child: Text('No songs found'));
          }
          return _SongsView(songs: state.songs);
        },
      ),
    );
  }
}

class _SongsView extends StatelessWidget {
  const _SongsView({required this.songs});

  final List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Songs Page')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (_, index) {
          return SongItem(
            song: songs[index],
            onTap: () {
              context.read<MusicPlayerBloc>().add(
                PlayMusicEvent(index, songs),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MusicPlayerPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
