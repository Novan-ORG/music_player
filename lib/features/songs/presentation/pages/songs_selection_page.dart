import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SongsSelectionPage extends StatefulWidget {
  const SongsSelectionPage({
    required this.title,
    required this.availableSongs,
    this.selectedSongIds = const {},
    super.key,
  });

  final String title;
  final List<Song> availableSongs;
  final Set<int> selectedSongIds;

  @override
  State<SongsSelectionPage> createState() => _SongsSelectionPageState();
}

class _SongsSelectionPageState extends State<SongsSelectionPage>
    with SongSharingMixin, SongDeletionMixin, PlaylistManagementMixin {
  final Set<int> selectedSongIds = {};

  List<Song> get _selectedSongs => widget.availableSongs
      .where((song) => selectedSongIds.contains(song.id))
      .toList();

  void onAddToPlaylist() {
    showPlaylistSheetForAddingSongs(_selectedSongs);
  }

  void onDelete() {
    showDeleteSongsDialog(_selectedSongs);
  }

  void onShare() {
    shareSongs(
      context,
      _selectedSongs,
      onSuccess: () {
        Navigator.of(context).pop();
      },
    );
  }

  void onSelectAll() {
    setState(() {
      selectedSongIds.addAll(
        widget.availableSongs.map((song) => song.id),
      );
    });
  }

  void onDeselectAll() {
    setState(selectedSongIds.clear);
  }

  @override
  void initState() {
    selectedSongIds.addAll(widget.selectedSongIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SelectionActionBar(
            selectedCount: selectedSongIds.length,
            totalCount: widget.availableSongs.map((e) => e.id).toSet().length,
            onAddToPlaylist: onAddToPlaylist,
            onDelete: onDelete,
            onShare: onShare,
            onSelectAll: onSelectAll,
            onDeselectAll: onDeselectAll,
          ),
        ),
      ),
      body: BackgroundGradient(
        child: widget.availableSongs.isEmpty
            ? const NoSongsWidget()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                itemCount: widget.availableSongs.length,
                itemBuilder: (context, index) {
                  final song = widget.availableSongs[index];
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
