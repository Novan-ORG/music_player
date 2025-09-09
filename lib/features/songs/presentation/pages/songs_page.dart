import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/core/services/ringtone_set/ringtone_set.dart';
import 'package:music_player/extensions/padding_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/music_player_page.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/no_songs_widget.dart';
import 'package:music_player/features/songs/presentation/widgets/song_item.dart';
import 'package:music_player/features/songs/presentation/widgets/top_head_actions.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide PlaylistModel;
import 'package:permission_handler/permission_handler.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key, this.playlist, this.isFavorites = false});

  final PlaylistModel? playlist;
  final bool isFavorites;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late final SongsBloc songsBloc;
  late final MusicPlayerBloc musicPlayerBloc;

  @override
  void initState() {
    super.initState();
    songsBloc = context.read<SongsBloc>();
    musicPlayerBloc = context.read<MusicPlayerBloc>();
  }

  Future<void> _setAsRingtone(BuildContext context, String songPath) async {
    if (await Permission.systemAlertWindow.request().isGranted) {
      await RingtoneSet.setRingtone(songPath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission not granted to set ringtone')),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, SongModel song) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Song'),
        content: const Text('Are you sure you want to delete this song?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              songsBloc.add(DeleteSongEvent(song));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<SongModel> _filterSongs(SongsState state, List<int> likedSongIds) {
    List<SongModel> songs = List<SongModel>.from(state.allSongs);

    if (widget.playlist != null) {
      songs.retainWhere((song) => widget.playlist!.songs.contains(song.id));
    }
    if (widget.isFavorites) {
      songs.retainWhere((song) => likedSongIds.contains(song.id));
    }
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFavorites
              ? 'Favorite Songs'
              : widget.playlist?.name ?? 'All Songs Page',
        ),
      ),
      body: BlocBuilder<SongsBloc, SongsState>(
        bloc: songsBloc,
        builder: (context, state) {
          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == SongsStatus.error) {
            return const Center(child: Text('Error loading songs'));
          }
          if (state.allSongs.isEmpty) {
            return NoSongsWidget(
              onRefresh: () async => songsBloc.add(LoadSongsEvent()),
            );
          }
          return BlocSelector<MusicPlayerBloc, MusicPlayerState, List<int>>(
            bloc: musicPlayerBloc,
            selector: (state) => state.likedSongIds,
            builder: (context, likedSongIds) {
              final filteredSongs = _filterSongs(state, likedSongIds);

              if (filteredSongs.isEmpty) {
                return NoSongsWidget(
                  message: widget.isFavorites
                      ? 'No favorite songs yet'
                      : 'No songs available in this playlist',
                  onRefresh: () async => songsBloc.add(LoadSongsEvent()),
                );
              }

              return Column(
                children: [
                  TopHeadActions(
                    songCount: filteredSongs.length,
                    onShuffleAll: () {
                      musicPlayerBloc.add(
                        ShuffleMusicEvent(songs: filteredSongs),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MusicPlayerPage(),
                        ),
                      );
                    },
                    onSortSongs: (sortType) {
                      songsBloc.add(SortSongsEvent(sortType));
                    },
                    sortType: state.sortType,
                  ).paddingSymmetric(horizontal: 12),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => songsBloc.add(LoadSongsEvent()),
                      child: ListView.builder(
                        itemCount: filteredSongs.length,
                        itemBuilder: (context, index) {
                          final song = filteredSongs[index];
                          return SongItem(
                            song: song,
                            isLiked: likedSongIds.contains(song.id),
                            onSetAsRingtonePressed: () =>
                                _setAsRingtone(context, song.data),
                            onDeletePressed: () =>
                                _showDeleteDialog(context, song),
                            onToggleLike: () => musicPlayerBloc.add(
                              ToggleLikeMusicEvent(song.id),
                            ),
                            onTap: () {
                              musicPlayerBloc.add(
                                PlayMusicEvent(index, filteredSongs),
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const MusicPlayerPage(),
                                ),
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
          );
        },
      ),
    );
  }
}
