import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/song_item.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/play_list_bloc.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class PlaylistDetailsPage extends StatefulWidget {
  const PlaylistDetailsPage({required this.playlistModel, super.key});

  final Playlist playlistModel;

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage>
    with
        PlaylistManagementMixin,
        SongDeletionMixin,
        SongSharingMixin,
        RingtoneMixin {
  late final PlayListBloc _playlistBloc = context.read<PlayListBloc>();
  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  void _loadPlaylistSongs() {
    _playlistBloc.add(
      GetPlaylistSongsEvent(playlistId: widget.playlistModel.id),
    );
  }

  Future<void> onRefresh() async {
    _loadPlaylistSongs();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  void _handleSongLongPress(Song song) {
    Navigator.of(context).push<Set<int>>(
      MaterialPageRoute<Set<int>>(
        builder: (_) => SongsSelectionPage(
          title: widget.playlistModel.name,
          availableSongs: _playlistBloc.state.currentPlaylistSongs,
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

  bool isSelected(Song song) {
    // Implement your selection check logic here
    return false; // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayListBloc, PlayListState>(
      listener: (context, state) {
        if (state.status == PlayListStatus.error &&
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
        final songCount = state.currentPlaylistId == widget.playlistModel.id
            ? state.currentPlaylistSongs.length
            : 0;

        // Get songs for current playlist
        final songs = state.currentPlaylistId == widget.playlistModel.id
            ? state.currentPlaylistSongs
            : <Song>[];

        return Scaffold(
          appBar: PlaylistDetailsAppbar(
            playlist: state.playLists.firstWhere(
              (playlist) => playlist.id == widget.playlistModel.id,
              orElse: () => widget.playlistModel,
            ),
            songCount: songCount,
            onAddSongs: () => addSongsToPlaylist(
              widget.playlistModel,
              state.currentPlaylistSongs.map((e) => e.id).toSet(),
            ),
          ),
          body: state.status == PlayListStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : songs.isEmpty
              ? NoSongsWidget(
                  message: context.localization.noSongInPlaylist,
                  onRefresh: onRefresh,
                )
              : RefreshIndicator.adaptive(
                  onRefresh: onRefresh,
                  child: ListView.builder(
                    itemCount: songs.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return SongItem(
                        song: song,
                        existInPlaylist: true,
                        isLiked: context
                            .read<FavoriteSongsBloc>()
                            .state
                            .favoriteSongIds
                            .contains(song.id),
                        onSetAsRingtonePressed: () => setAsRingtone(song.data),
                        onDeletePressed: () => showDeleteSongDialog(song),
                        onToggleLike: () => context
                            .read<FavoriteSongsBloc>()
                            .add(ToggleFavoriteSongEvent(song.id)),
                        onSharePressed: () => shareSong(song),
                        onRemoveFromPlaylistPressed: () {
                          removeSongsFromPlaylist({
                            song.id,
                          }, widget.playlistModel);
                        },
                        onLongPress: () => _handleSongLongPress(song),
                        onTap: () async {
                          await _handleSongTap(index, songs);
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
