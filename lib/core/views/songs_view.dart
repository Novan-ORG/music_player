import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/no_songs_widget.dart';
import 'package:music_player/core/widgets/song_item.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/playlist.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';

class SongsView extends StatefulWidget {
  const SongsView({
    required this.songs,
    this.onRefresh,
    super.key,
  });

  final List<Song> songs;
  final Future<void> Function()? onRefresh;

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin,
        ToggleLikeMixin {
  // Event handlers for song actions
  Future<void> _handleSongTap(int songIndex, List<Song> songs) async {
    context.read<MusicPlayerBloc>().add(PlayMusicEvent(songIndex, songs));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MusicPlayerPage(),
      ),
    );
  }

  Future<void> onLongPress(Song song, List<Song> songs) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SongsSelectionPage(
          title: context.localization.songs,
          availableSongs: songs,
          selectedSongIds: {song.id},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.songs.isEmpty) {
      return const NoSongsWidget();
    }
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      bloc: context.read<MusicPlayerBloc>(),
      buildWhen: (previous, next) =>
          previous.currentSongIndex != next.currentSongIndex ||
          previous.playList != next.playList ||
          previous.status != next.status,
      builder: (context, musicPlayerState) {
        return RefreshIndicator(
          onRefresh: widget.onRefresh ?? () async {},
          child: BlocSelector<FavoriteSongsBloc, FavoriteSongsState, Set<int>>(
            selector: (state) {
              return state.favoriteSongIds;
            },
            builder: (context, favoriteSongIds) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                itemCount: widget.songs.length,
                itemBuilder: (context, index) {
                  final song = widget.songs[index];
                  final isCurrent = musicPlayerState.currentSong?.id == song.id;
                  return SongItem(
                    track: song,
                    isCurrentTrack: isCurrent,
                    isPlayingNow:
                        musicPlayerState.status == MusicPlayerStatus.playing &&
                        isCurrent,
                    isFavorite: favoriteSongIds.contains(song.id),
                    onSetAsRingtone: () => setAsRingtone(song.data),
                    onDelete: () => showDeleteSongDialog(song),
                    onFavoriteToggle: () => onToggleLike(song.id),
                    onAddToPlaylist: () async {
                      await PlaylistsPage.showSheet(
                        context: context,
                        songIds: {song.id},
                      );
                    },
                    onShare: () => shareSong(song),
                    onLongPress: () => onLongPress(song, widget.songs),
                    onTap: () => _handleSongTap(index, widget.songs),
                    onPlayPause: () {
                      context.read<MusicPlayerBloc>().add(
                        const TogglePlayPauseEvent(),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
