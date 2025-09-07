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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: PlaylistsPage(isSelectionMode: true, songId: songId),
      ),
    );
  }

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final selectedPlaylistIds = <int>{};
  @override
  void initState() {
    context.read<PlayListBloc>().add(LoadPlayListsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayListBloc, PlayListState>(
        builder: (context, state) {
          if (state.status == PlayListStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == PlayListStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.status == PlayListStatus.loaded) {
            if (state.playLists.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 18,
                  children: [
                    Text('No Playlists Found'),
                    TextButton(
                      onPressed: () {
                        CreatePalylistSheet.show(context);
                      },
                      child: Text('Create First Playlist'),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: state.playLists.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: Text('Create New Playlist'),
                      leading: Icon(Icons.add),
                      onTap: () {
                        CreatePalylistSheet.show(context);
                      },
                    );
                  } else {
                    final playlist = state.playLists[index - 1];
                    return widget.isSelectionMode
                        ? CheckboxListTile(
                            value: selectedPlaylistIds.contains(playlist.id),
                            title: Text(playlist.name),
                            subtitle: Text(
                              '${playlist.songs.length} song${playlist.songs.length == 1 ? '' : 's'}',
                            ),
                            onChanged: (value) {
                              if (value == true) {
                                selectedPlaylistIds.add(playlist.id);
                              } else {
                                selectedPlaylistIds.remove(playlist.id);
                              }
                              setState(() {});
                            },
                          )
                        : ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SongsPage(playlist: playlist),
                                ),
                              );
                            },
                            title: Text(playlist.name),
                            subtitle: Text(
                              '${playlist.songs.length} song${playlist.songs.length == 1 ? '' : 's'}',
                            ),
                          );
                  }
                },
              );
            }
          }
          return Center(child: Text('Playlists Page'));
        },
      ),
      bottomNavigationBar: widget.isSelectionMode && widget.songId != null
          ? Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
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
                child: Text('Add to Selected Playlists'),
              ),
            )
          : null,
    );
  }
}
