import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/padding_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/music_player_page.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/song_item.dart';
import 'package:music_player/features/songs/presentation/widgets/top_head_actions.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SongsView();
  }
}

class _SongsView extends StatelessWidget {
  const _SongsView();

  @override
  Widget build(BuildContext context) {
    final songsBloc = context.read<SongsBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Songs Page')),
      body: BlocBuilder<SongsBloc, SongsState>(
        bloc: songsBloc,
        builder: (_, state) {
          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == SongsStatus.error) {
            return const Center(child: Text('Error loading songs'));
          } else if (state.songs.isEmpty) {
            return const Center(child: Text('No songs found'));
          }
          final songs = state.songs;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TopHeadActions(
                songCount: state.songs.length,
                onShuffleAll: () {
                  context.read<MusicPlayerBloc>().add(
                    ShuffleMusicEvent(songs: songs),
                  );
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => MusicPlayerPage()));
                },
                onSortSongs: (sortType) {
                  songsBloc.add(SortSongsEvent(sortType));
                },
                sortType: state.sortType,
              ).paddingSymmetric(horizontal: 12),
              Expanded(
                child: ListView.builder(
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
              ),
            ],
          );
        },
      ),
    );
  }
}
