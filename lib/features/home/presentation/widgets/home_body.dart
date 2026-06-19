import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';

class HomeBody extends StatelessWidget {
  const HomeBody(this.page, {super.key});

  final Widget page;

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: page,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            bloc: musicPlayerBloc,
            builder: (_, state) {
              if (state.playList.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return const MiniPlayerPage();
              }
            },
          ),
        ),
      ],
    );
  }
}
