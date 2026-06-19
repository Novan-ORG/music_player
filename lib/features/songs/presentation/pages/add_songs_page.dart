import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
import 'package:music_player/core/widgets/song_image_widget.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<Song> get _filteredSongs {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return widget.availableSongs;
    }

    return widget.availableSongs
        .where((song) {
          return song.title.toLowerCase().contains(normalizedQuery) ||
              song.artist.toLowerCase().contains(normalizedQuery) ||
              song.album.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  @override
  void initState() {
    _selectedSongIds.addAll(widget.selectedSongIds);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSongSelection(int songId, {bool? forceSelected}) {
    setState(() {
      final shouldSelect = forceSelected ?? !_selectedSongIds.contains(songId);
      if (shouldSelect) {
        _selectedSongIds.add(songId);
      } else {
        _selectedSongIds.remove(songId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final filteredSongs = _filteredSongs;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.18),
              const Color(0xFF00BFA6).withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0, 0.16, 0.42, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _AddSongsHeader(
                listName: widget.listName,
                selectedCount: _selectedSongIds.length,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: context.localization.searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.trim().isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: theme.colorScheme.surface.withValues(
                      alpha: 0.94,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.06,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: widget.availableSongs.isEmpty
                    ? AppStateView(
                        eyebrow: context.localization.playlist,
                        title:
                            context.localization.allSongsAlreadyExistInPlaylist,
                        message: widget.listName,
                        accentColor: theme.colorScheme.primary,
                      )
                    : filteredSongs.isEmpty
                    ? AppStateView(
                        eyebrow: context.localization.searchSongs,
                        title: context.localization.searchNoMatchesTitle(
                          _query,
                        ),
                        message: context.localization.searchNoMatchesMessage,
                        actionLabel: context.localization.dismiss,
                        onAction: () => setState(() {
                          _query = '';
                          _searchController.clear();
                        }),
                        accentColor: theme.colorScheme.primary,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredSongs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final song = filteredSongs[index];
                          final isSelected = _selectedSongIds.contains(song.id);

                          return _SongSelectionTile(
                            song: song,
                            isSelected: isSelected,
                            onTap: () => _toggleSongSelection(song.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: _selectedSongIds.isEmpty
                ? null
                : () => Navigator.of(context).pop(_selectedSongIds),
            icon: const Icon(Icons.playlist_add_check_rounded),
            label: Text(context.localization.add(_selectedSongIds.length)),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddSongsHeader extends StatelessWidget {
  const _AddSongsHeader({
    required this.listName,
    required this.selectedCount,
    required this.onBackPressed,
  });

  final String listName;
  final int selectedCount;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              theme.colorScheme.primary.withValues(alpha: isDark ? 0.46 : 0.2),
              const Color(0xFF00BFA6).withValues(alpha: isDark ? 0.24 : 0.14),
              theme.colorScheme.surface.withValues(alpha: isDark ? 0.86 : 0.95),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.42),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: onBackPressed,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$selectedCount ${context.localization.selected}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${context.localization.addTo} $listName',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.localization.searchSongsReadyCount(selectedCount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SongSelectionTile extends StatelessWidget {
  const _SongSelectionTile({
    required this.song,
    required this.isSelected,
    required this.onTap,
  });

  final Song song;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.4)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: isSelected
                  ? [
                      theme.colorScheme.primary.withValues(alpha: 0.16),
                      const Color(0xFF00BFA6).withValues(alpha: 0.08),
                    ]
                  : [
                      theme.colorScheme.surface.withValues(
                        alpha: isDark ? 0.26 : 0.92,
                      ),
                      theme.colorScheme.surface.withValues(
                        alpha: isDark ? 0.18 : 0.8,
                      ),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.48),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: theme.colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 58,
                height: 58,
                child: ArtImageWidget(
                  id: song.id,
                  borderRadius: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
