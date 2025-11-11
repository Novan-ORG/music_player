import 'dart:math' as math;

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

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin {
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

  List<double> _generateSampleWaveformData(BuildContext context) {
    final random = math.Random();
    const waveBarWidth = 5; // barWidth + spacing
    const padding = 64; // horizontal padding of AudioProgress
    final screenWidth = MediaQuery.of(context).size.width - padding;
    final totalWaveBarNum = (screenWidth / waveBarWidth).toInt();
    // the max height of waveBar is 38
    return List.generate(
      totalWaveBarNum,
      (index) => random.nextDouble() * 33 + 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    var waveformData = _generateSampleWaveformData(context);
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
      buildWhen: (previous, current) {
        if (previous.currentSongIndex != current.currentSongIndex) {
          waveformData = _generateSampleWaveformData(context);
        }
        return true;
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
                spacing: 16,
                children: [
                  Hero(
                    tag: 'song_cover_${state.currentSong?.id ?? 0}',
                    child: SongImageWidget(
                      qualitySize: 400,
                      songId: state.currentSong?.id ?? 0,
                      size: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  SongInfo(
                    song: state.currentSong,
                    onLikePressed: () {
                      if (state.currentSong != null) {
                        context.read<FavoriteSongsBloc>().add(
                          ToggleFavoriteSongEvent(state.currentSong!.id),
                        );
                      }
                    },
                    onDeletePressed: () =>
                        showDeleteSongDialog(state.currentSong!),
                    onSetAsRingtonePressed: () =>
                        setAsRingtone(state.currentSong!.data),
                    onAddToPlaylistPressed: () {
                      PlaylistsPage.showSheet(
                        context: context,
                        songIds: state.currentSong?.id != null
                            ? {state.currentSong!.id}
                            : null,
                      );
                    },
                  ),
                  AudioProgress(
                    durationStream: musicPlayerBloc.durationStream,
                    positionStream: musicPlayerBloc.positionStream,
                    waveformData: waveformData,
                    onSeek: (duration) {
                      musicPlayerBloc.add(SeekMusicEvent(position: duration));
                    },
                  ),
                  const PlayerActionButtons(),
                  VolumeSlider(
                    volumeController: getIt.get<VolumeController>(),
                  ).paddingSymmetric(horizontal: 32),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 8),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                UpnextMusicsSheet.show(context);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                Icons.arrow_upward_outlined,
                color: context.theme.colorScheme.secondary,
              ),
            ),
          ),
        );
      },
    );
  }
}
