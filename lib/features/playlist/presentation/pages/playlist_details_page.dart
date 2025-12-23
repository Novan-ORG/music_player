import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/core/widgets/floating_circle_buttton.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/features/search/presentation/pages/search_songs_page.dart';
import 'package:music_player/injection/service_locator.dart';

class PlaylistDetailsPage extends StatelessWidget {
  const PlaylistDetailsPage({required this.playlistModel, super.key});
  final Playlist playlistModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistDetailsBloc(
        playlist: playlistModel,
        getPlaylistSongs: getIt.get(),
        getRecentlyPlayedSongs: getIt.get(),
      ),
      child: const _PlaylistDetailsView(),
    );
  }
}

class _PlaylistDetailsView extends StatefulWidget {
  const _PlaylistDetailsView();

  @override
  State<_PlaylistDetailsView> createState() => _PlaylistDetailsViewState();
}

class _PlaylistDetailsViewState extends State<_PlaylistDetailsView>
    with PlaylistManagementMixin {
  late final PlaylistDetailsBloc _detailsBloc = context
      .read<PlaylistDetailsBloc>();

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  void _loadPlaylistSongs() {
    _detailsBloc.add(
      const GetPlaylistSongsEvent(),
    );
  }

  Future<void> onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _loadPlaylistSongs();
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaylistDetailsBloc, PlaylistDetailsState>(
      listener: (context, state) {
        if (state.status == PlaylistDetailsStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final songCount = state.songs.length;
        final songs = state.songs;

        return Scaffold(
          appBar: PlaylistDetailsAppbar(
            playlist: state.playlist,
            songCount: songCount,
            onSearchButtonPressed: _onSearchButtonPressed,
          ),
          body: state.status == PlaylistDetailsStatus.loading
              ? const Loading()
              : songs.isEmpty
              ? NoSongsWidget(
                  message: context.localization.noSongInPlaylist,
                )
              : SongsView(
                  songs: songs,
                  playlist: state.playlist,
                  onRefresh: onRefresh,
                ),

          floatingActionButton: FloatingCircleButton(
            onPressed: () async {
              final result = await addSongsToPlaylist(
                state.playlist,
                songs.map((e) => e.id).toSet(),
              );
              if (result != null) {
                await Future<void>.delayed(
                  const Duration(milliseconds: 200),
                );
                _loadPlaylistSongs();
              }
            },
          ),
        );
      },
    );
  }
}
