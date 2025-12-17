import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';
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

        if (albumState.status == AlbumsStatus.error) {
          return const SongsErrorLoading();
        }

        final albums = albumState.allAlbums;
        if (albums.isEmpty) {
          return const NoSongsWidget();
        }
        return ListView.builder(
          itemCount: albumState.allAlbums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return AlbumItem(
              album: album,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => QuerySongsPage(
                      fromType: SongsFromType.albumId,
                      where: album.id,
                      title: album.album,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
