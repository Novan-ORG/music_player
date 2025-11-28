import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/mixins/playlist_management_mixin.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_appbar.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_item.dart';
import 'package:music_player/features/playlist/presentation/widgets/recently_playlist_item.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/features/search/presentation/pages/search_songs_page.dart';

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
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PlaylistsPage(isSelectionMode: true, songIds: songIds),
    );
  }

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage>
    with PlaylistManagementMixin {
  final Set<int> selectedPlaylistIds = {};

  @override
  void initState() {
    super.initState();
    context.read<PlayListBloc>().add(LoadPlayListsEvent());
  }

  Future<void> _showCreatePlaylistSheet() => CreatePlaylistSheet.show(context);

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
      return PlaylistItem(
        playlist: playlist,
        onAddMusicToPlaylist: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PlaylistDetailsPage(
                playlistModel: playlist,
              ),
            ),
          );
        },
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PlaylistDetailsPage(
                playlistModel: playlist,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildAllPlaylists(List<Playlist> playlists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          'All Playlist',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              return _buildPlaylistTile(playlists[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomBar() {
    if (widget.isSelectionMode && widget.songIds != null) {
      return SafeArea(
        child: Container(
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
        ),
      );
    }
    return null;
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PlaylistAppbar(
        onSearchButtonPressed: _onSearchButtonPressed,
      ),
      body: BlocBuilder<PlayListBloc, PlayListState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16),
          child: _buildBody(theme),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.surface,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: _showCreatePlaylistSheet,
        tooltip: context.localization.createPlaylist,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.primary,
          size: 38,
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorite Playlist',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return const RecentlyPlaylistItem();
            },
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.3,
          indent: 6,
          endIndent: 6,
          height: 6,
        ),
        Expanded(
          child: BlocBuilder<PlayListBloc, PlayListState>(
            builder: (context, state) {
              if (state.status == PlayListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == PlayListStatus.error) {
                return Center(
                  child: Text(
                    '${context.localization.error}: ${state.errorMessage}',
                  ),
                );
              } else if (state.status == PlayListStatus.initial) {
                return Center(child: Text(context.localization.playListPage));
              } else {
                if (state.playLists.isEmpty) {
                  return const EmptyPlaylist();
                } else {
                  return _buildAllPlaylists(state.playLists);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
