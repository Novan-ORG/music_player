import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
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
  final List<Song> _availableSongs = [];

  List<Song> get _selectedSongs => _availableSongs
      .where((song) => selectedSongIds.contains(song.id))
      .toList();

  int get _totalSongs => _availableSongs.map((song) => song.id).toSet().length;

  String get _selectionTitle {
    final label =
        selectedSongIds.length == 1 ||
            Localizations.localeOf(context).languageCode == 'fa'
        ? context.localization.song
        : context.localization.songs;
    return '${selectedSongIds.length} $label ${context.localization.selected}';
  }

  Future<void> onAddToPlaylist() async {
    if (_selectedSongs.isEmpty) {
      return;
    }
    await showPlaylistSheetForAddingSongs(_selectedSongs);
  }

  Future<void> onDelete() async {
    final songsToDelete = _selectedSongs;
    if (songsToDelete.isEmpty) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        icon: Icons.delete_sweep_rounded,
        title: dialogContext.localization.deleteSongsAlertTitle(
          songsToDelete.length,
        ),
        message: dialogContext.localization.deleteSongsAlertContent,
        confirmLabel: dialogContext.localization.deleteFromDevice,
        isDestructive: true,
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    context.read<SongsBloc>().add(DeleteSongsEvent(songsToDelete));
    final deletedIds = songsToDelete.map((song) => song.id).toSet();

    setState(() {
      _availableSongs.removeWhere((song) => deletedIds.contains(song.id));
      selectedSongIds.removeAll(deletedIds);
    });

    final songLabel = songsToDelete.length == 1
        ? context.localization.song
        : context.localization.songs;
    AppSnackBar.showInfo(
      context,
      title: context.localization.deleted,
      message: '${songsToDelete.length} $songLabel',
      icon: Icons.delete_sweep_rounded,
    );

    if (_availableSongs.isEmpty && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> onShare() async {
    await shareSongs(
      context,
      _selectedSongs,
      onSuccess: () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  void onSelectAll() {
    setState(() {
      selectedSongIds.addAll(
        _availableSongs.map((song) => song.id),
      );
    });
  }

  void onDeselectAll() {
    setState(selectedSongIds.clear);
  }

  void _toggleSongSelection(int songId, {bool? forceSelected}) {
    setState(() {
      final shouldSelect = forceSelected ?? !selectedSongIds.contains(songId);
      if (shouldSelect) {
        selectedSongIds.add(songId);
      } else {
        selectedSongIds.remove(songId);
      }
    });
  }

  @override
  void initState() {
    _availableSongs.addAll(widget.availableSongs);
    selectedSongIds.addAll(widget.selectedSongIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 4,
        title: Text(
          _selectionTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          SelectionMoreButton(
            onAddToPlaylist: onAddToPlaylist,
            onDelete: onDelete,
            onShare: onShare,
            selectedCount: selectedSongIds.length,
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        offset: selectedSongIds.isEmpty ? const Offset(0, 1) : Offset.zero,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: selectedSongIds.isEmpty ? 0 : 1,
          child: SelectionActionDock(
            selectedCount: selectedSongIds.length,
            onAddToPlaylist: onAddToPlaylist,
            onDelete: onDelete,
            onShare: onShare,
          ),
        ),
      ),
      body: _availableSongs.isEmpty
          ? const NoSongsWidget()
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.08),
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor,
                  ],
                  stops: const [0, 0.14, 0.42],
                ),
              ),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  12,
                  10,
                  12,
                  selectedSongIds.isEmpty ? 16 : 88,
                ),
                itemCount: _availableSongs.length + 1,
                separatorBuilder: (context, index) => index == 0
                    ? const SizedBox(height: 10)
                    : const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SelectionActionBar(
                      selectedCount: selectedSongIds.length,
                      totalCount: _totalSongs,
                      onSelectAll: onSelectAll,
                      onDeselectAll: onDeselectAll,
                    );
                  }

                  final song = _availableSongs[index - 1];
                  final isSelected = selectedSongIds.contains(song.id);

                  return SelectionSongCard(
                    song: song,
                    isSelected: isSelected,
                    onChanged: ({bool? isSelected}) {
                      _toggleSongSelection(
                        song.id,
                        forceSelected: isSelected,
                      );
                    },
                    onTap: () => _toggleSongSelection(song.id),
                  );
                },
              ),
            ),
    );
  }
}
