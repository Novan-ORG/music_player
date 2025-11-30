import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
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
        title: Text(
          widget.title,
          style: context.theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          SelectionMoreButton(
            onAddToPlaylist: onAddToPlaylist,
            onDelete: onDelete,
            onShare: onShare,
            selectedCount: selectedSongIds.length,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SelectionActionBar(
            selectedCount: selectedSongIds.length,
            totalCount: widget.availableSongs.map((e) => e.id).toSet().length,
            onSelectAll: onSelectAll,
            onDeselectAll: onDeselectAll,
          ),
        ),
      ),
      body: widget.availableSongs.isEmpty
          ? const NoSongsWidget()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              itemCount: widget.availableSongs.length,
              separatorBuilder: (context, index) => Container(
                height: 0.3,
                margin: const EdgeInsets.all(6),
                color: Theme.of(context).dividerColor,
              ),
              itemBuilder: (context, index) {
                final song = widget.availableSongs[index];
                final isSelected = selectedSongIds.contains(song.id);

                return SelectionSongCard(
                  song: song,
                  isSelected: isSelected,
                  onChanged: ({bool? isSelected}) {
                    setState(() {
                      if (isSelected ?? false) {
                        selectedSongIds.add(song.id);
                      } else {
                        selectedSongIds.remove(song.id);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
