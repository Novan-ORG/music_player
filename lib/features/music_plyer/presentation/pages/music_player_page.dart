import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayerPage extends StatelessWidget with SongSharingMixin {
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
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => shareSong(state.currentSong!),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'song_cover_${state.currentSong?.id ?? 0}',
                    child: SongImageWidget(
                      qualitySize: 400,
                      songId: state.currentSong?.id ?? 0,
                      size: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SongInfo(
                    song: state.currentSong,
                    onLikePressed: () {
                      if (state.currentSong != null) {
                        context.read<FavoriteSongsBloc>().add(
                          ToggleFavoriteSongEvent(state.currentSong!.id),
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
                        songIds: state.currentSong?.id != null
                            ? {state.currentSong!.id}
                            : null,
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
              child: const PlayerActionButtons().paddingOnly(
                bottom: 48,
                left: 16,
                right: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
