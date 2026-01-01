import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/core/widgets/widgets.dart';
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
    return Center(
      child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) =>
            previous.currentSong?.id != current.currentSong?.id ||
            previous.status != current.status,
        builder: (context, state) {
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

              return Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: _sizeAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildDefaultMiniPlayer(isPlaying, state),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDefaultMiniPlayer(bool isPlaying, MusicPlayerState state) {
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
        child: GlassCard(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
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
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                leading: Hero(
                  tag: 'song_cover_${state.currentSong?.id ?? 0}',
                  child: ArtImageWidget(
                    id: state.currentSong?.id ?? 0,
                  ),
                ),
                title: SongTitle(
                  songTitle: state.currentSong?.title,
                ),
                subtitle: _buildSubtitle(
                  context,
                  state.currentSong?.artist,
                ),
                trailing:
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
                        return _MiniPlayerControls(
                          musicPlayerBloc: musicPlayerBloc,
                          currentSongId: state.currentSong?.id ?? 0,
                          isLiked: isLiked,
                          isPlaying: isPlaying,
                        );
                      },
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
    );
  }

  Widget _buildMinimizedPlayer(
    BuildContext context,
    MusicPlayerBloc musicPlayerBloc,
    int currentSongId,
    bool isPlaying,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
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
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSubtitle(BuildContext context, String? artist) {
  final displayArtist = (artist?.isNotEmpty ?? false) ? artist! : 'unknown';
  final baseStyle =
      Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);
  final style = baseStyle.copyWith(color: Colors.grey[700]);
  return AutoSizeText(
    displayArtist,
    style: style.copyWith(
      color: context.theme.colorScheme.primary,
    ),
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
  });

  final MusicPlayerBloc musicPlayerBloc;
  final int currentSongId;
  final bool isLiked;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: context.theme.colorScheme.primary,
          ),
          tooltip: isLiked ? 'Unlike' : 'Like',
          onPressed: () {
            context.read<FavoriteSongsBloc>().add(
              ToggleFavoriteSongEvent(currentSongId),
            );
          },
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: context.theme.primaryColor,
          ),
          tooltip: isPlaying ? 'Pause' : 'Play',
          onPressed: () {
            musicPlayerBloc.add(const TogglePlayPauseEvent());
          },
        ),
      ],
    );
  }
}
