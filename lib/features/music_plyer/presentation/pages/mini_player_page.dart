import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';

class MiniPlayerPage extends StatefulWidget {
  const MiniPlayerPage({super.key});

  @override
  State<MiniPlayerPage> createState() => _MiniPlayerPageState();
}

class _MiniPlayerPageState extends State<MiniPlayerPage>
    with TickerProviderStateMixin {
  bool _isMinimized = false;
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeAnimation =
        Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _fadeAnimation =
        Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMinimize() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
    if (_isMinimized) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) =>
          previous.likedSongIds != current.likedSongIds ||
          previous.currentSong?.id != current.currentSong?.id ||
          previous.status != current.status,
      builder: (context, state) {
        final currentId = state.currentSong?.id ?? -1;
        final isLiked = state.likedSongIds.contains(currentId);
        final isPlaying = state.status == MusicPlayerStatus.playing;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            if (_isMinimized) {
              return _buildMinimizedPlayer(
                context,
                musicPlayerBloc,
                state.currentSong?.id ?? 0,
                isPlaying,
              );
            }

            return Transform.scale(
              scale: _sizeAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.of(
                        context,
                      ).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const MusicPlayerPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      leading: Hero(
                        tag: 'mini_cover_${state.currentSong?.id ?? 0}',
                        child: MiniCoverAndProgress(
                          positionStream: musicPlayerBloc.positionStream,
                          durationStream: musicPlayerBloc.durationStream,
                          songId: state.currentSong?.id ?? 0,
                        ),
                      ),
                      title: _buildTitle(
                        context,
                        state.currentSong?.title ?? 'No song',
                      ),
                      subtitle: _buildSubtitle(
                        context,
                        state.currentSong?.artist,
                      ),
                      trailing: _MiniPlayerControls(
                        musicPlayerBloc: musicPlayerBloc,
                        currentSongId: state.currentSong?.id ?? 0,
                        isLiked: isLiked,
                        isPlaying: isPlaying,
                        onMinimize: _toggleMinimize,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMinimizedPlayer(
    BuildContext context,
    MusicPlayerBloc musicPlayerBloc,
    int currentSongId,
    bool isPlaying,
  ) {
    return GestureDetector(
      onLongPress: _toggleMinimize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'mini_cover_$currentSongId',
            child: MiniCoverAndProgress(
              positionStream: musicPlayerBloc.positionStream,
              durationStream: musicPlayerBloc.durationStream,
              songId: currentSongId,
            ),
          ),
          IconButton(
            onPressed: () {
              musicPlayerBloc.add(const TogglePlayPauseEvent());
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTitle(BuildContext context, String title) {
  final baseStyle =
      Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 14);
  final style = baseStyle.copyWith(fontWeight: FontWeight.bold);
  return AutoSizeText(
    title,
    style: style,
    maxLines: 1,
    overflowReplacement: SizedBox(
      height: 18,
      child: Marquee(
        text: title,
        blankSpace: 60,
        style: style,
      ),
    ),
  );
}

Widget _buildSubtitle(BuildContext context, String? artist) {
  final displayArtist = (artist?.isNotEmpty ?? false) ? artist! : 'unknown';
  final baseStyle =
      Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);
  final style = baseStyle.copyWith(color: Colors.grey[700]);
  return AutoSizeText(
    displayArtist,
    style: style,
    maxLines: 1,
    overflowReplacement: SizedBox(
      height: 20,
      child: Marquee(
        text: displayArtist,
        blankSpace: 60,
        style: style,
      ),
    ),
  );
}

class _MiniPlayerControls extends StatelessWidget {
  const _MiniPlayerControls({
    required this.musicPlayerBloc,
    required this.currentSongId,
    required this.isLiked,
    required this.isPlaying,
    required this.onMinimize,
  });

  final MusicPlayerBloc musicPlayerBloc;
  final int currentSongId;
  final bool isLiked;
  final bool isPlaying;
  final VoidCallback onMinimize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
          ),
          tooltip: isLiked ? 'Unlike' : 'Like',
          onPressed: () {
            musicPlayerBloc.add(ToggleLikeMusicEvent(currentSongId));
          },
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          tooltip: isPlaying ? 'Pause' : 'Play',
          onPressed: () {
            musicPlayerBloc.add(const TogglePlayPauseEvent());
          },
        ),
        IconButton(
          icon: const Icon(Icons.minimize),
          tooltip: 'Minimize',
          onPressed: onMinimize,
        ),
      ],
    );
  }
}
