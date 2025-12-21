import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';
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
    with
        PlaylistManagementMixin,
        SongDeletionMixin,
        SongSharingMixin,
        RingtoneMixin {
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

  void _handleSongLongPress(Song song) {
    Navigator.of(context).push<Set<int>>(
      MaterialPageRoute<Set<int>>(
        builder: (_) => SongsSelectionPage(
          title: _detailsBloc.state.playlist.name,
          availableSongs: _detailsBloc.state.songs,
          selectedSongIds: {song.id},
        ),
      ),
    );
  }

  // Event handlers for song actions
  Future<void> _handleSongTap(int songIndex, List<Song> songs) async {
    context.read<MusicPlayerBloc>().add(PlayMusicEvent(songIndex, songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
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
            onAddSongs: () async {
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
            onPlaylistRenamed: () {
              Navigator.pop(context);
            },
          ),
          body: state.status == PlaylistDetailsStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : songs.isEmpty
              ? NoSongsWidget(
                  message: context.localization.noSongInPlaylist,
                  onRefresh: onRefresh,
                )
              : RefreshIndicator(
                  onRefresh: onRefresh,
                  child:
                      BlocSelector<
                        FavoriteSongsBloc,
                        FavoriteSongsState,
                        Set<int>
                      >(
                        selector: (state) {
                          return state.favoriteSongIds;
                        },
                        builder: (context, favoriteSongs) {
                          return ListView.builder(
                            itemCount: songs.length,
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            itemBuilder: (context, index) {
                              final song = songs[index];
                              return SongItem(
                                track: song,
                                isInPlaylist: true,
                                isFavorite: favoriteSongs.contains(song.id),
                                onSetAsRingtone: () => setAsRingtone(song.data),
                                onDelete: () => showDeleteSongDialog(song),
                                onFavoriteToggle: () => context
                                    .read<FavoriteSongsBloc>()
                                    .add(ToggleFavoriteSongEvent(song.id)),
                                onShare: () => shareSong(song),
                                onRemoveFromPlaylist: () async {
                                  removeSongsFromPlaylist({
                                    song.id,
                                  }, state.playlist);
                                  await Future<void>.delayed(
                                    const Duration(milliseconds: 200),
                                  );
                                  _loadPlaylistSongs();
                                },
                                onLongPress: () => _handleSongLongPress(song),
                                onTap: () async {
                                  await _handleSongTap(index, songs);
                                },
                              );
                            },
                          );
                        },
                      ),
                ),
        );
      },
    );
  }
}
