import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/constants/constants.dart';
import 'package:music_player/features/songs/presentation/widgets/songs_appbar.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  // Getters for BLoCs
  SongsBloc get _songsBloc => context.read<SongsBloc>();
  MusicPlayerBloc get _musicPlayerBloc => context.read<MusicPlayerBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongsBloc, SongsState>(
      bloc: _songsBloc,
      builder: (context, songsState) {
        return Scaffold(
          appBar: SongsAppbar(
            onSearchButtonPressed: _onSearchButtonPressed,
          ),
          body: _buildSongsContent(songsState),
        );
      },
    );
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }

  Widget _buildSongsContent(SongsState songsState) {
    // Handle loading state
    if (songsState.status == SongsStatus.loading) {
      return const Loading();
    }

    // Handle error state
    if (songsState.status == SongsStatus.error) {
      return SongsErrorLoading(
        message: context.localization.errorLoadingSongs,
        onRetry: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    // Handle empty songs
    if (songsState.allSongs.isEmpty) {
      return NoSongsWidget(
        message: context.localization.noSongTryAgain,
        onRefresh: () => _songsBloc.add(const LoadSongsEvent()),
      );
    }

    final songs = songsState.allSongs;

    return Column(
      children: [
        SortTypeRuler(
          currentSortType: songsState.sortType,
          onSortTypeChanged: _onSortSongs,
        ),

        Expanded(
          child: SongsView(
            songs: songs,
            onRefresh: () async {
              _songsBloc.add(const LoadSongsEvent());
              await Future<void>.delayed(
                const Duration(milliseconds: 300),
              );
            },
          ),
        ),
        // Bottom spacing for mini player
        if (_musicPlayerBloc.state.playList.isNotEmpty)
          const SizedBox(height: SongsPageConstants.minPlayerHeight),
      ],
    );
  }

  void _onSortSongs(SongsSortType sortType) {
    _songsBloc.add(LoadSongsEvent(sortType: sortType));
  }
}
