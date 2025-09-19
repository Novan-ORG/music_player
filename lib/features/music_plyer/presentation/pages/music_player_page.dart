import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/padding_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/audio_progress.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/more_action_buttons.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/player_action_buttons.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/song_artwork.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/song_info.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/upnext_musics_sheet.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/volume_slider.dart';
import 'package:music_player/features/play_list/presentation/pages/playlists_page.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late final musicPlayerBloc = context.read<MusicPlayerBloc>();
  SongModel? currentSong;
  int currentSongIndex = -1;
  late final StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = musicPlayerBloc.currentIndexStream.listen(
      _onMusicChanged,
    );
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Hero(
              tag: 'mini_cover_${currentSong?.id ?? 'no_song'}',
              child: SongArtwork(song: currentSong),
            ),
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
              onMusicQueuePressed: () {
                UpnextMusicsSheet.show(context);
              },
            ),
            VolumeSlider(volumeController: getIt.get<VolumeController>()),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8),
      ),
      bottomSheet: SafeArea(
        child: PlayerActionButtons().paddingSymmetric(
          vertical: 4,
          horizontal: 16,
        ),
      ),
    );
  }
}
