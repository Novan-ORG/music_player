import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';
import 'package:music_player/features/play_list/presentation/pages/pages.dart';
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
  late final MusicPlayerBloc musicPlayerBloc = context.read<MusicPlayerBloc>();
  SongModel? currentSong;
  int currentSongIndex = -1;
  late final StreamSubscription<int?> streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = musicPlayerBloc.currentIndexStream.listen(
      _onMusicChanged,
    );
  }

  @override
  void dispose() {
    unawaited(streamSubscription.cancel());
    super.dispose();
  }

  void _onMusicChanged(int? index) {
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
      appBar: AppBar(title: Text(context.localization.appTitle)),
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
              onAddToPlaylistPressed: () async {
                await PlaylistsPage.showSheet(
                  context: context,
                  songId: currentSong?.id,
                );
              },
              onSharePressed: () async {
                await SharePlus.instance.share(
                  ShareParams(
                    text: currentSong?.displayNameWOExt ?? 'Unknown Song',
                    subject: currentSong?.artist ?? 'Unknown Artist',
                    files: [XFile(currentSong?.data ?? '')],
                  ),
                );
              },
              onMusicQueuePressed: () async {
                await UpnextMusicsSheet.show(context);
              },
            ),
            VolumeSlider(volumeController: getIt.get<VolumeController>()),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8),
      ),
      bottomSheet: SafeArea(
        child: const PlayerActionButtons().paddingSymmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),
    );
  }
}
