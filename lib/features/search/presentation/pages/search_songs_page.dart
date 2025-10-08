import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SearchSongsPage extends StatefulWidget {
  const SearchSongsPage({super.key});

  @override
  State<SearchSongsPage> createState() => _SearchSongsPageState();
}

class _SearchSongsPageState extends State<SearchSongsPage> {
  final searchStream = StreamController<String>();

  @override
  void dispose() {
    unawaited(searchStream.close());
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
          onChanged: searchStream.add,
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
                return ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return ListTile(
                      leading: SongImageWidget(songId: song.id),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      onTap: () async {
                        context.read<MusicPlayerBloc>().add(
                          PlayMusicEvent(index, filteredSongs),
                        );
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
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
