import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/duration_ex.dart';
import 'package:music_player/features/songs/presentation/bloc/songs_bloc.dart';

class UpnextMusics extends StatelessWidget {
  const UpnextMusics({super.key});

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
            child: BlocBuilder<SongsBloc, SongsState>(
              builder: (context, state) {
                if (state.status == SongsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == SongsStatus.error) {
                  return const Center(child: Text('Error loading songs'));
                } else if (state.songs.isEmpty) {
                  return const Center(child: Text('No songs found'));
                }
                return ListView.builder(
                  itemCount: state.songs.length,
                  itemExtent: 28,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      leading: Icon(Icons.music_note),
                      title: Text(
                        '${state.songs[index].displayNameWOExt} - ${state.songs[index].artist ?? 'unknown'}',
                        maxLines: 1,
                      ),
                      trailing: Text(
                        Duration(
                          milliseconds: state.songs[index].duration ?? 0,
                        ).format(),
                        maxLines: 1,
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
