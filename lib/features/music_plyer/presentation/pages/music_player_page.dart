import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/padding_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/audio_progress.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/more_action_buttons.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/player_action_buttons.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/song_artwork.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/song_info.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/upnext_musics.dart';
import 'package:music_player/features/play_list/presentation/pages/playlists_page.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late final musicPlayerBloc = context.read<MusicPlayerBloc>();
  SongModel? currentSong;
  int currentSongIndex = -1;

  @override
  void initState() {
    super.initState();
    musicPlayerBloc.currentIndexStream.listen(_onMusicChanged);
  }

  void _onMusicChanged(index) {
    if (index != null &&
        index >= 0 &&
        index != currentSongIndex &&
        index < musicPlayerBloc.state.playList.length) {
      setState(() {
        currentSongIndex = index;
        currentSong = musicPlayerBloc.state.playList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'mini_cover_${currentSong?.id ?? 'no_song'}',
      child: Scaffold(
        appBar: AppBar(title: const Text('Player')),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              SongArtwork(song: currentSong),
              const SizedBox(height: 24),
              SongInfo(
                song: currentSong,
                onLikePressed: () {
                  if (currentSong != null) {
                    musicPlayerBloc.add(ToggleLikeMusicEvent(currentSong!.id));
                  }
                },
              ),
              const SizedBox(height: 16),
              AudioProgress(
                durationStream: musicPlayerBloc.durationStream,
                positionStream: musicPlayerBloc.positionStream,
                onSeek: musicPlayerBloc.seek,
              ),
              const SizedBox(height: 16),
              MoreActionButtons(
                onAddToPlaylistPressed: () {
                  PlaylistsPage.showSheet(
                    context: context,
                    songId: currentSong?.id,
                  );
                },
                onSharePressed: () {
                  SharePlus.instance.share(
                    ShareParams(
                      text: currentSong?.displayNameWOExt ?? 'Unknown Song',
                      subject: currentSong?.artist ?? 'Unknown Artist',
                      files: [XFile(currentSong?.data ?? '')],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              UpNextMusics(
                onTapSong: (index) {
                  musicPlayerBloc.add(SkipToMusicIndexEvent(index));
                },
              ),
              const SizedBox(height: 12),
              const PlayerActionButtons(),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
