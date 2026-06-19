import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
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
          return SongsErrorLoading(
            eyebrow: context.localization.albums,
            title: context.localization.libraryLoadErrorTitle,
            message: context.localization.libraryLoadErrorMessage,
            onRetry: () => context.read<AlbumsBloc>().add(
              LoadAlbumsEvent(sortType: albumState.sortType),
            ),
          );
        }

        final albums = albumState.allAlbums;
        if (albums.isEmpty) {
          return NoSongsWidget(
            eyebrow: context.localization.albums,
            title: context.localization.emptyAlbumsTitle,
            message: context.localization.emptyAlbumsMessage,
            onRefresh: () => context.read<AlbumsBloc>().add(
              LoadAlbumsEvent(sortType: albumState.sortType),
            ),
          );
        }
        final mediaQuery = MediaQuery.of(context);
        final isWideCompact =
            mediaQuery.size.width >= 700 && mediaQuery.size.height < 620;
        final hasMiniPlayer = context
            .read<MusicPlayerBloc>()
            .state
            .playList
            .isNotEmpty;
        final bottomPadding = hasMiniPlayer
            ? (isWideCompact ? 104.0 : 132.0)
            : 16.0;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 6, bottom: bottomPadding),
          itemCount: albumState.allAlbums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return AlbumItem(
              album: album,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AppRouteBlocScope.fromContext(
                      context: context,
                      child: QuerySongsPage(
                        fromType: SongsFromType.albumId,
                        where: album.id,
                        title: album.album,
                      ),
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
