import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/play_list/presentation/bloc/play_list_bloc.dart';
import 'package:music_player/features/play_list/presentation/widgets/create_palylist_sheet.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
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
                    return ListTile(title: Text(playlist.name));
                  }
                },
              );
            }
          }
          return Center(child: Text('Playlists Page'));
        },
      ),
    );
  }
}
