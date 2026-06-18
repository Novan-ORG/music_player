import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/pages/pages.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';

/// Minimizable mini player widget at the bottom of the screen.
///
/// Features:
/// - Compact player display
/// - Swipe to dismiss gesture
/// - Swipe left/right for next/previous song
/// - Expandable to full player view
/// - Album art with progress bar
class MiniPlayerPage extends StatefulWidget {
  const MiniPlayerPage({super.key});

  @override
  State<MiniPlayerPage> createState() => _MiniPlayerPageState();
}

class _MiniPlayerPageState extends State<MiniPlayerPage>
    with TickerProviderStateMixin {
  late final MusicPlayerBloc musicPlayerBloc = context.read<MusicPlayerBloc>();
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
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) =>
          previous.currentSong?.id != current.currentSong?.id ||
          previous.status != current.status,
      builder: (context, state) {
        final isPlaying = state.status == MusicPlayerStatus.playing;
        final mediaQuery = MediaQuery.of(context);
        final useCompactDock =
            mediaQuery.size.width >= 700 && mediaQuery.size.height < 620;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            if (_isMinimized) {
              return Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: _buildMinimizedPlayer(
                  context,
                  musicPlayerBloc,
                  state.currentSong?.id ?? 0,
                  isPlaying,
                ),
              );
            }

            return Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - _sizeAnimation.value)),
                  child: Transform.scale(
                    scale: 0.96 + (_sizeAnimation.value * 0.04),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildDefaultMiniPlayer(
                        isPlaying,
                        state,
                        compact: useCompactDock,
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

  Widget _buildDefaultMiniPlayer(
    bool isPlaying,
    MusicPlayerState state, {
    required bool compact,
  }) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swiped Right
          musicPlayerBloc.add(
            const SkipToPreviousEvent(),
          );
        } else if (details.primaryVelocity! < 0) {
          // Swiped Left
          musicPlayerBloc.add(
            const SkipToNextEvent(),
          );
        }
      },
      child: Dismissible(
        key: const Key('mini_player_dismissible'),
        direction: DismissDirection.down,
        onDismissed: (direction) {
          _toggleMinimize();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, compact ? 6 : 10),
          child: MiniPlayerSurface(
            onLongPress: _toggleMinimize,
            onTap: () async {
              await Navigator.of(
                context,
              ).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MusicPlayerPage(),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!compact) ...[
                  const SizedBox(height: 8),
                  const MiniPlayerHandle(),
                ],
                Padding(
                  padding: compact
                      ? const EdgeInsets.fromLTRB(12, 8, 12, 4)
                      : const EdgeInsets.fromLTRB(14, 7, 14, 8),
                  child: Row(
                    children: [
                      if (compact) ...[
                        IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: context.theme.colorScheme.primary,
                            foregroundColor:
                                context.theme.colorScheme.onPrimary,
                            minimumSize: const Size.square(48),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 28,
                          ),
                          tooltip: isPlaying
                              ? context.localization.pause
                              : context.localization.play,
                          onPressed: () {
                            musicPlayerBloc.add(
                              const TogglePlayPauseEvent(),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                      Hero(
                        tag: 'song_cover_${state.currentSong?.id ?? 0}',
                        child: MiniArtwork(
                          songId: state.currentSong?.id ?? 0,
                          isPlaying: isPlaying,
                          compact: compact,
                        ),
                      ),
                      SizedBox(width: compact ? 10 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: compact ? 3 : 5,
                          children: [
                            if (!compact) const MiniPlaybackChip(),
                            MiniSongTitle(
                              songTitle: state.currentSong?.title,
                            ),
                            MiniPlayerSubtitle(
                              artist: state.currentSong?.artist,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      BlocSelector<
                        FavoriteSongsBloc,
                        FavoriteSongsState,
                        Set<int>
                      >(
                        selector: (state) {
                          return state.favoriteSongIds;
                        },
                        builder: (context, favoriteSongIds) {
                          final currentId = state.currentSong?.id ?? -1;
                          final isLiked = favoriteSongIds.contains(
                            currentId,
                          );
                          return MiniPlayerControls(
                            musicPlayerBloc: musicPlayerBloc,
                            currentSongId: state.currentSong?.id ?? 0,
                            isLiked: isLiked,
                            isPlaying: isPlaying,
                            compact: compact,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                MiniHorizontalProgress(
                  positionStream: musicPlayerBloc.positionStream,
                  durationStream: musicPlayerBloc.durationStream,
                  onSeek: (position) {
                    musicPlayerBloc.add(
                      SeekMusicEvent(position: position),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimizedPlayer(
    BuildContext context,
    MusicPlayerBloc musicPlayerBloc,
    int currentSongId,
    bool isPlaying,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 16, bottom: 12),
      child: GestureDetector(
        onLongPress: _toggleMinimize,
        onTap: _toggleMinimize,
        child: MiniPlayerSurface(
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(7),
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
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.74),
                    minimumSize: const Size.square(34),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    musicPlayerBloc.add(const TogglePlayPauseEvent());
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
