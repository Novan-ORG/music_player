import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SongSelectionPage extends StatefulWidget {
  const SongSelectionPage({
    required this.playlist,
    required this.excludeIds,
    super.key,
  });

  final PlaylistModel playlist;
  final Set<int> excludeIds;

  @override
  State<SongSelectionPage> createState() => _SongSelectionPageState();
}

class _SongSelectionPageState extends State<SongSelectionPage> {
  final Set<int> selectedSongIds = {};

  List<Song> get availableSongs {
    final songsBloc = context.read<SongsBloc>();
    return songsBloc.state.allSongs
        .where((song) => !widget.excludeIds.contains(song.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F53AC),
        title: Text('Add to ${widget.playlist.name}'),
        actions: [
          TextButton(
            onPressed: selectedSongIds.isEmpty
                ? null
                : () => Navigator.of(context).pop(selectedSongIds),
            child: Text(
              'Add (${selectedSongIds.length})',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BackgroundGradient(
        child: BlocBuilder<SongsBloc, SongsState>(
          builder: (context, state) {
            if (state.status == SongsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == SongsStatus.error) {
              return Center(
                child: Text(context.localization.errorLoadingSongs),
              );
            }

            final songs = availableSongs;

            if (songs.isEmpty) {
              return Center(
                child: Text(
                  'All songs are already in this playlist',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final isSelected = selectedSongIds.contains(song.id);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (selected) {
                      setState(() {
                        if (selected ?? false) {
                          selectedSongIds.add(song.id);
                        } else {
                          selectedSongIds.remove(song.id);
                        }
                      });
                    },
                    secondary: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SongImageWidget(songId: song.id, size: 54),
                    ),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
