import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/widgets/search_songs_appbar.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

/// Search page for finding songs by query.
///
/// Features:
/// - Text search input with voice-to-text option
/// - Real-time search results
/// - Recent searches display
/// - Play searched songs
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
      appBar: SearchSongsAppbar(searchStream: searchStream),
      body: BlocBuilder<SongsBloc, SongsState>(
        builder: (_, state) {
          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SongsStatus.error) {
            return SongsErrorLoading(
              message: context.localization.errorLoadingSongs,
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
              return SafeArea(
                top: false,
                left: false,
                right: false,
                child: SongsView(
                  songs: filteredSongs,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
