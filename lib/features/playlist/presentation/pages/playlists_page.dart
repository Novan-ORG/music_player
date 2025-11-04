import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({
    super.key,
    this.isSelectionMode = false,
    this.songIds,
  });

  final bool isSelectionMode;
  final Set<int>? songIds;

  static Future<void> showSheet({
    required BuildContext context,
    Set<int>? songIds,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: PlaylistsPage(isSelectionMode: true, songIds: songIds),
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

  Future<void> _showCreatePlaylistSheet() => CreatePlaylistSheet.show(context);

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.playlist_play, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.localization.noPlaylistFound,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(context.localization.createFirstPlaylist),
            onPressed: _showCreatePlaylistSheet,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(Playlist playlist) {
    final subtitle =
        '${playlist.numOfSongs} ${context.localization.song}'
        '${playlist.numOfSongs <= 1 ? '' : context.localization.s}';
    if (widget.isSelectionMode) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: CheckboxListTile(
          value: selectedPlaylistIds.contains(playlist.id),
          title: Text(
            playlist.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(subtitle),
          secondary: const Icon(Icons.queue_music),
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) {
            setState(() {
              if (value ?? false) {
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
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(10),
            child: const Icon(Icons.queue_music, color: Colors.black54),
          ),
          title: Text(
            playlist.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(subtitle),
          trailing: PlaylistItemMoreAction(playlist: playlist),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PlaylistDetailsPage(playlistModel: playlist),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildPlaylistsList(List<Playlist> playlists) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: playlists.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Card(
            color: Theme.of(context).colorScheme.primary.withAlpha(8),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.add, color: Colors.blueAccent),
              title: Text(
                context.localization.createNewPlaylist,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
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
        return Center(
          child: Text('${context.localization.error}: ${state.errorMessage}'),
        );
      case PlayListStatus.loaded:
        if (state.playLists.isEmpty) {
          return _buildEmptyState();
        }
        return _buildPlaylistsList(state.playLists);

      case PlayListStatus.initial:
        return Center(child: Text(context.localization.playListPage));
    }
  }

  Widget? _buildBottomBar() {
    if (widget.isSelectionMode && widget.songIds != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.playlist_add_check),
          label: Text(context.localization.addToSelectedPlaylist),
          onPressed: selectedPlaylistIds.isEmpty
              ? null
              : () {
                  context.read<PlayListBloc>().add(
                    AddSongsToPlaylistsEvent(
                      widget.songIds!,
                      selectedPlaylistIds.toList(),
                    ),
                  );
                  Navigator.of(context).pop(selectedPlaylistIds.toList());
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
        backgroundColor: const Color(0xFF7F53AC),
        title: Text(
          widget.isSelectionMode
              ? context.localization.selectPlaylist
              : context.localization.playlists,
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          if (!widget.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: context.localization.createPlaylist,
              onPressed: _showCreatePlaylistSheet,
            ),
        ],
      ),
      body: BackgroundGradient(
        child: BlocBuilder<PlayListBloc, PlayListState>(
          builder: (context, state) => _buildBody(state),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}
