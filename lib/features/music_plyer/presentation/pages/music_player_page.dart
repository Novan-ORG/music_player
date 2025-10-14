import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';
import 'package:music_player/features/play_list/presentation/pages/pages.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  void _showErrorBanner(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              context.localization.dismiss,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      bloc: musicPlayerBloc,
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (state.errorMessage != null) {
          _showErrorBanner(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(title: Text(context.localization.appTitle)),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Hero(
                    tag: 'mini_cover_${state.currentSong?.id ?? 'no_song'}',
                    child: SongArtwork(song: state.currentSong),
                  ),
                  const SizedBox(height: 24),
                  SongInfo(
                    song: state.currentSong,
                    onLikePressed: () {
                      if (state.currentSong != null) {
                        musicPlayerBloc.add(
                          ToggleLikeMusicEvent(state.currentSong!.id),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  AudioProgress(
                    durationStream: musicPlayerBloc.durationStream,
                    positionStream: musicPlayerBloc.positionStream,
                    onSeek: (duration) {
                      musicPlayerBloc.add(SeekMusicEvent(position: duration));
                    },
                  ),
                  const SizedBox(height: 16),
                  MoreActionButtons(
                    onAddToPlaylistPressed: () async {
                      await PlaylistsPage.showSheet(
                        context: context,
                        songId: state.currentSong?.id,
                      );
                    },
                    onSharePressed: () async {
                      await SharePlus.instance.share(
                        ShareParams(
                          text: state.currentSong?.title ?? 'Unknown Song',
                          subject:
                              state.currentSong?.artist ?? 'Unknown Artist',
                          files: [XFile(state.currentSong?.uri ?? '')],
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
          ),
        );
      },
    );
  }
}
