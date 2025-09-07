import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/duration_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';

class UpNextMusics extends StatelessWidget {
  const UpNextMusics({super.key, this.onTapSong});

  final Function(int)? onTapSong;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('UPNEXT', style: Theme.of(context).textTheme.titleSmall),
              Icon(Icons.arrow_downward),
            ],
          ),
          Flexible(
            child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
              buildWhen: (previous, current) =>
                  previous.playList != current.playList,
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.playList.length,
                  itemExtent: 28,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => onTapSong?.call(index),
                      child: Row(
                        spacing: 6,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.music_note),
                          Expanded(
                            child: Text(
                              '${state.playList[index].displayNameWOExt} - ${state.playList[index].artist ?? 'unknown'}',
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            Duration(
                              milliseconds: state.playList[index].duration ?? 0,
                            ).format(),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
