import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class AddSongsPage extends StatefulWidget {
  const AddSongsPage({
    required this.listName,
    required this.availableSongs,
    this.selectedSongIds = const {},
    super.key,
  });

  final String listName;
  final List<Song> availableSongs;
  final Set<int> selectedSongIds;

  @override
  State<AddSongsPage> createState() => _AddSongsPageState();
}

class _AddSongsPageState extends State<AddSongsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F53AC),
        title: Text('Add to ${widget.listName}'),
        actions: [
          TextButton(
            onPressed: widget.selectedSongIds.isEmpty
                ? null
                : () => Navigator.of(context).pop(widget.selectedSongIds),
            child: Text(
              'Add (${widget.selectedSongIds.length})',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BackgroundGradient(
        child: widget.availableSongs.isEmpty
            ? Center(
                child: Text(
                  'All songs are already in this playlist',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                itemCount: widget.availableSongs.length,
                itemBuilder: (context, index) {
                  final song = widget.availableSongs[index];
                  final isSelected = widget.selectedSongIds.contains(song.id);

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
                            widget.selectedSongIds.add(song.id);
                          } else {
                            widget.selectedSongIds.remove(song.id);
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
              ),
      ),
    );
  }
}
