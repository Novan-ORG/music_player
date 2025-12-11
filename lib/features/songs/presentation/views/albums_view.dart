import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class AlbumsView extends StatelessWidget {
  const AlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumsBloc, AlbumsState>(
      builder: (context, albumState) {
        if (albumState.status == AlbumsStatus.loading) {
          return const Loading();
        }

        final albums = albumState.allAlbums;
        return ListView.builder(
          itemCount: albumState.allAlbums.length,
          itemBuilder: (context, index) {
            return AlbumItem(album: albums[index]);
          },
        );
      },
    );
  }
}
