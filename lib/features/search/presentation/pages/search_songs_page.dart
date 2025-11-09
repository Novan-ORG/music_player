import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';

class SearchSongsPage extends StatefulWidget {
  const SearchSongsPage({super.key});

  @override
  State<SearchSongsPage> createState() => _SearchSongsPageState();
}

class _SearchSongsPageState extends State<SearchSongsPage>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin {
  MusicPlayerBloc get _musicPlayerBloc => context.read<MusicPlayerBloc>();
  final searchStream = StreamController<String>();

  @override
  void dispose() {
    unawaited(searchStream.close());
    super.dispose();
  }

  void onLongPress(Song song, List<Song> allSongs) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SongsSelectionPage(
          title: context.localization.searchSongs,
          availableSongs: allSongs,
          selectedSongIds: {song.id},
        ),
      ),
    );
  }

  // Event handlers for song actions
  Future<void> _handleSongTap(int songIndex, List<Song> songs) async {
    _musicPlayerBloc.add(PlayMusicEvent(songIndex, songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
      ),
    );
  }

  void onToggleLike(int songId) {
    context.read<FavoriteSongsBloc>().add(ToggleFavoriteSongEvent(songId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: context.localization.searchSongs,
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.titleMedium,
          autofocus: true,
          onChanged: searchStream.add,
        ),
      ),
      body: BlocBuilder<SongsBloc, SongsState>(
        builder: (_, state) {
          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == SongsStatus.error) {
            return Center(
              child: Text(context.localization.errorLoadingSongs),
            );
          }
          if (state.allSongs.isEmpty) {
            return NoSongsWidget(
              onRefresh: () {
                context.read<SongsBloc>().add(const LoadSongsEvent());
              },
            );
          }
          return StreamBuilder(
            stream: searchStream.stream,
            builder: (context, searchQuery) {
              final query = searchQuery.data?.toLowerCase() ?? '';
              List<Song> filteredSongs;
              if (query.isNotEmpty) {
                filteredSongs = state.allSongs.where((song) {
                  final title = song.title.toLowerCase();
                  final artist = song.artist.toLowerCase();
                  final album = song.album.toLowerCase();
                  return title.contains(query) ||
                      artist.contains(query) ||
                      album.contains(query);
                }).toList();
              } else {
                filteredSongs = state.allSongs;
              }
              return BlocSelector<
                FavoriteSongsBloc,
                FavoriteSongsState,
                Set<int>
              >(
                selector: (state) {
                  return state.favoriteSongIds;
                },
                builder: (context, favoriteSongIds) {
                  return ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return SongItem(
                        song: song,
                        isLiked: favoriteSongIds.contains(song.id),
                        onSetAsRingtonePressed: () => setAsRingtone(song.data),
                        onDeletePressed: () => showDeleteSongDialog(song),
                        onToggleLike: () => onToggleLike(song.id),
                        onAddToPlaylistPressed: () async {
                          await PlaylistsPage.showSheet(
                            context: context,
                            songIds: {song.id},
                          );
                        },
                        onSharePressed: () => shareSong(song),
                        onLongPress: () => onLongPress(song, filteredSongs),
                        onTap: () => _handleSongTap(index, filteredSongs),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
