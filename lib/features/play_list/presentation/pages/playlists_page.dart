import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/play_list/presentation/bloc/play_list_bloc.dart';
import 'package:music_player/features/play_list/presentation/widgets/create_palylist_sheet.dart';
import 'package:music_player/features/songs/presentation/pages/songs_page.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key, this.isSelectionMode = false, this.songId});

  final bool isSelectionMode;
  final int? songId;

  static Future<void> showSheet({required BuildContext context, int? songId}) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: PlaylistsPage(isSelectionMode: true, songId: songId),
      ),
    );
  }

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final Set<int> selectedPlaylistIds = {};

  @override
  void initState() {
    super.initState();
    context.read<PlayListBloc>().add(LoadPlayListsEvent());
  }

  void _showCreatePlaylistSheet() {
    CreatePlaylistSheet.show(context);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.playlist_play, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Playlists Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create First Playlist'),
            onPressed: _showCreatePlaylistSheet,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(playlist) {
    final subtitle = '${playlist.songs.length} song${playlist.songs.length == 1 ? '' : 's'}';
    if (widget.isSelectionMode) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: CheckboxListTile(
          value: selectedPlaylistIds.contains(playlist.id),
          title: Text(playlist.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle),
          secondary: const Icon(Icons.queue_music),
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                selectedPlaylistIds.add(playlist.id);
              } else {
                selectedPlaylistIds.remove(playlist.id);
              }
            });
          },
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: const Icon(Icons.queue_music, color: Colors.black54),
          ),
          title: Text(playlist.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SongsPage(playlist: playlist),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildPlaylistsList(List playlists) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: playlists.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Card(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.add, color: Colors.blueAccent),
              title: const Text('Create New Playlist', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: _showCreatePlaylistSheet,
            ),
          );
        }
        final playlist = playlists[index - 1];
        return _buildPlaylistTile(playlist);
      },
    );
  }

  Widget _buildBody(PlayListState state) {
    switch (state.status) {
      case PlayListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case PlayListStatus.error:
        return Center(child: Text('Error: ${state.errorMessage}'));
      case PlayListStatus.loaded:
        if (state.playLists.isEmpty) {
          return _buildEmptyState();
        }
        return _buildPlaylistsList(state.playLists);
      default:
        return const Center(child: Text('Playlists Page'));
    }
  }

  Widget? _buildBottomBar() {
    if (widget.isSelectionMode && widget.songId != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.playlist_add_check),
          label: const Text('Add to Selected Playlists'),
          onPressed: selectedPlaylistIds.isEmpty
              ? null
              : () {
                  context.read<PlayListBloc>().add(
                        AddSongToPlaylistsEvent(
                          widget.songId!,
                          selectedPlaylistIds.toList(),
                        ),
                      );
                  Navigator.of(context).pop(selectedPlaylistIds.toList());
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'Select Playlists' : 'Playlists'),
        centerTitle: true,
        elevation: 1,
        actions: [
          if (!widget.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Create Playlist',
              onPressed: _showCreatePlaylistSheet,
            ),
        ],
      ),
      body: BlocBuilder<PlayListBloc, PlayListState>(
        builder: (context, state) => _buildBody(state),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}
