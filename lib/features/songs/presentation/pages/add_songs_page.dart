import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

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
  final Set<int> _selectedSongIds = {};

  @override
  void initState() {
    _selectedSongIds.addAll(widget.selectedSongIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${context.localization.addTo} ${widget.listName}'),
        actions: [
          TextButton(
            onPressed: _selectedSongIds.isEmpty
                ? null
                : () => Navigator.of(context).pop(_selectedSongIds),
            child: Text(
              context.localization.add(_selectedSongIds.length),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: widget.availableSongs.isEmpty
          ? Center(
              child: Text(
                context.localization.allSongsAlreadyExistInPlaylist,
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
                final isSelected = _selectedSongIds.contains(song.id);

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
                          _selectedSongIds.add(song.id);
                        } else {
                          _selectedSongIds.remove(song.id);
                        }
                      });
                    },
                    secondary: SizedBox(
                      width: 54,
                      height: 54,
                      child: ArtImageWidget(
                        id: song.id,
                        borderRadius: 8,
                      ),
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
            ),
    );
  }
}
