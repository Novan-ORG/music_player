import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/background_gradient.dart';
import 'package:music_player/extensions/context_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/music_player_page.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/no_songs_widget.dart';
import 'package:music_player/features/songs/presentation/widgets/song_image_widget.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SearchSongsPage extends StatefulWidget {
  const SearchSongsPage({super.key});

  @override
  State<SearchSongsPage> createState() => _SearchSongsPageState();
}

class _SearchSongsPageState extends State<SearchSongsPage> {
  final searchStream = StreamController<String>();

  @override
  void dispose() {
    searchStream.close();
    super.dispose();
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
          onChanged: (query) {
            searchStream.add(query);
          },
        ),
      ),
      body: BackgroundGradient(
        child: BlocBuilder<SongsBloc, SongsState>(
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
                  context.read<SongsBloc>().add(LoadSongsEvent());
                },
              );
            }
            return StreamBuilder(
              stream: searchStream.stream,
              builder: (context, searchQuery) {
                final query = searchQuery.data?.toLowerCase() ?? '';
                List<SongModel> filteredSongs;
                if (query.isNotEmpty) {
                  filteredSongs = state.allSongs.where((song) {
                    final title = song.title.toLowerCase();
                    final artist = song.artist?.toLowerCase() ?? "";
                    final album = song.album?.toLowerCase() ?? "";
                    return title.contains(query) ||
                        artist.contains(query) ||
                        album.contains(query);
                  }).toList();
                } else {
                  filteredSongs = state.allSongs;
                }
                return ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return ListTile(
                      leading: SongImageWidget(songId: song.id),
                      title: Text(song.title),
                      subtitle: Text(song.artist ?? 'Unknown Artist'),
                      onTap: () {
                        context.read<MusicPlayerBloc>().add(
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
