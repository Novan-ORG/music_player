import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class ArtistsView extends StatelessWidget {
  const ArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsBloc, ArtistsState>(
      builder: (context, artistsState) {
        if (artistsState.status == ArtistsStatus.loading) {
          return const Loading();
        }

        if (artistsState.status == ArtistsStatus.error) {
          return const SongsErrorLoading();
        }

        final artists = artistsState.allArtists;
        if (artists.isEmpty) {
          return const NoSongsWidget();
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
          itemCount: artistsState.allArtists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            return ArtistItem(
              artist: artist,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => QuerySongsPage(
                      fromType: SongsFromType.artistId,
                      where: artist.id,
                      title: artist.artist,
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
