import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

class AppRouteBlocScope extends StatelessWidget {
  const AppRouteBlocScope({
    required this.child,
    required this.songsBloc,
    required this.playListBloc,
    required this.favoriteSongsBloc,
    required this.musicPlayerBloc,
    super.key,
  });

  factory AppRouteBlocScope.fromContext({
    required BuildContext context,
    required Widget child,
    Key? key,
  }) {
    return AppRouteBlocScope(
      key: key,
      songsBloc: context.read<SongsBloc>(),
      playListBloc: context.read<PlayListBloc>(),
      favoriteSongsBloc: context.read<FavoriteSongsBloc>(),
      musicPlayerBloc: context.read<MusicPlayerBloc>(),
      child: child,
    );
  }

  final Widget child;
  final SongsBloc songsBloc;
  final PlayListBloc playListBloc;
  final FavoriteSongsBloc favoriteSongsBloc;
  final MusicPlayerBloc musicPlayerBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: songsBloc),
        BlocProvider.value(value: playListBloc),
        BlocProvider.value(value: favoriteSongsBloc),
        BlocProvider.value(value: musicPlayerBloc),
      ],
      child: child,
    );
  }
}
