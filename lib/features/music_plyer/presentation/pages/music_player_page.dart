import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/audio_progress.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/more_action_buttons.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/player_action_buttons.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/upnext_musics.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

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
    musicPlayerBloc.audioPlayer.currentIndexStream.listen(_onMusicChanged);
    super.initState();
  }

  void _onMusicChanged(index) {
    if (index != null && index >= 0 && index != currentSongIndex) {
      currentSongIndex = index;
      currentSong = musicPlayerBloc.state.playList[index];
      musicPlayerBloc.add(
        PlayMusicEvent(index, musicPlayerBloc.state.playList),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 12,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: currentSong != null
                    ? QueryArtworkWidget(
                        id: currentSong!.id,
                        type: ArtworkType.AUDIO,
                        quality: 100,
                        artworkFit: BoxFit.cover,
                        artworkQuality: FilterQuality.high,
                        artworkBorder: BorderRadius.circular(16.0),
                        artworkWidth: MediaQuery.of(context).size.height * 0.33,
                        artworkHeight:
                            MediaQuery.of(context).size.height * 0.33,
                        nullArtworkWidget: Image.asset(
                          'assets/images/song_cover.png',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.height * 0.33,
                          height: MediaQuery.of(context).size.height * 0.33,
                          alignment: Alignment.center,
                        ),
                      )
                    : Image.asset(
                        'assets/images/song_cover.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.height * 0.33,
                        height: MediaQuery.of(context).size.height * 0.33,
                        alignment: Alignment.center,
                      ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: SizedBox(
                height: 28,
                child:
                    (currentSong?.displayNameWOExt ?? 'Unknown Song').length >
                        15
                    ? Marquee(
                        text: currentSong?.displayNameWOExt ?? 'Unknown Song',
                        style: Theme.of(context).textTheme.titleLarge,
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 30.0,
                        showFadingOnlyWhenScrolling: true,
                        velocity: 40.0,
                        pauseAfterRound: Duration(seconds: 1),
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      )
                    : Text(
                        currentSong?.displayNameWOExt ?? 'Unknown Song',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
              ),
              subtitle: Text(
                currentSong?.artist ?? 'Unknown Artist',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite),
              ),
            ),
            AudioProgress(
              durationStream: context
                  .read<MusicPlayerBloc>()
                  .audioPlayer
                  .durationStream,
              positionStream: context
                  .read<MusicPlayerBloc>()
                  .audioPlayer
                  .positionStream,
              onSeek: context.read<MusicPlayerBloc>().audioPlayer.seek,
              onChangeEnd: context.read<MusicPlayerBloc>().audioPlayer.seek,
            ),
            MoreActionButtons(),
            UpNextMusics(onTapSong: _onMusicChanged),
            PlayerActionButtons(),
          ],
        ),
      ),
    );
  }
}
