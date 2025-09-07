import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/extensions/padding_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/music_player_page.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/song_item.dart';
import 'package:music_player/features/songs/presentation/widgets/top_head_actions.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide PlaylistModel;

class SongsPage extends StatefulWidget {
  const SongsPage({super.key, this.playlist});

  final PlaylistModel? playlist;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  Widget build(BuildContext context) {
    final songsBloc = context.read<SongsBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.playlist != null ? widget.playlist!.name : 'All Songs Page',
        ),
      ),
      body: BlocBuilder<SongsBloc, SongsState>(
        bloc: songsBloc,
        builder: (_, state) {
          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == SongsStatus.error) {
            return const Center(child: Text('Error loading songs'));
          } else if (state.allSongs.isEmpty) {
            return const Center(child: Text('No songs found'));
          }
          final songs = List<SongModel>.from(state.allSongs);
          if (widget.playlist != null) {
            songs.retainWhere(
              (song) => widget.playlist!.songs.contains(song.id),
            );
          }
          if (songs.isEmpty) {
            return const Center(child: Text('No songs in this playlist'));
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TopHeadActions(
                songCount: songs.length,
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    songsBloc.add(LoadSongsEvent());
                  },
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (_, index) {
                      return BlocSelector<
                        MusicPlayerBloc,
                        MusicPlayerState,
                        List<int>
                      >(
                        selector: (state) {
                          return state.likedSongIds;
                        },
                        builder: (context, state) {
                          return SongItem(
                            song: songs[index],
                            isLiked: state.contains(songs[index].id),
                            onToggleLike: () {
                              context.read<MusicPlayerBloc>().add(
                                ToggleLikeMusicEvent(songs[index].id),
                              );
                            },
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
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
