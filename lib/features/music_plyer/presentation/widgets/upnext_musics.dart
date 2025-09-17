import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/duration_ex.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/music_player_bloc.dart';

class UpNextMusics extends StatelessWidget {
  const UpNextMusics({super.key, this.onTapSong, this.currentSongId});

  final Function(int)? onTapSong;
  final int? currentSongId;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                  buildWhen: (previous, current) =>
                      previous.playList != current.playList,
                  builder: (_, state) {
                    if (state.playList.isEmpty) {
                      return Center(
                        child: Text(
                          'No songs in queue',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: state.playList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final song = state.playList[index];
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                          leading: Transform.scale(
                            scale: currentSongId == song.id ? 1.2 : 1,
                            child: Icon(
                              Icons.music_note,
                              color: currentSongId == song.id
                                  ? primaryColor
                                  : Colors.blueAccent,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            song.displayNameWOExt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: currentSongId == song.id
                                      ? primaryColor
                                      : null,
                                ),
                          ),
                          subtitle: Text(
                            song.artist ?? 'Unknown Artist',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: currentSongId == song.id
                                      ? primaryColor
                                      : null,
                                ),
                          ),
                          trailing: Text(
                            Duration(milliseconds: song.duration ?? 0).format(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: currentSongId == song.id
                                      ? primaryColor
                                      : null,
                                ),
                          ),
                          onTap: () => onTapSong?.call(index),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          hoverColor: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(5),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Up Next',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[600]),
      ],
    );
  }
}
