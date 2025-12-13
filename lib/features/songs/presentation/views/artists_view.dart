import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
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

        return ListView.builder(
          itemCount: artistsState.allArtists.length,
          itemBuilder: (context, index) {
            return ArtistItem(artist: artists[index]);
          },
        );
      },
    );
  }
}
