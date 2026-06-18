import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';

class MiniPlayerSurface extends StatelessWidget {
  const MiniPlayerSurface({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(32);

    return GlassCard(
      borderRadius: radius,
      onLongPress: onLongPress,
      onTap: onTap,
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: isDark
            ? [
                const Color(0xFF23232A).withValues(alpha: 0.96),
                const Color(0xFF121316).withValues(alpha: 0.98),
              ]
            : [
                const Color(0xFFFFFFFF).withValues(alpha: 0.98),
                const Color(0xFFF8F5EA).withValues(alpha: 0.98),
              ],
      ),
      borderColor: isDark
          ? theme.colorScheme.primary.withValues(alpha: 0.28)
          : theme.colorScheme.primary.withValues(alpha: 0.18),
      borderWidth: isDark ? 0.75 : 1,
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withValues(
            alpha: isDark ? 0.2 : 0.16,
          ),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.38 : 0.12),
          blurRadius: 30,
          offset: const Offset(0, 16),
        ),
      ],
      child: child,
    );
  }
}

class MiniArtwork extends StatelessWidget {
  const MiniArtwork({
    required this.songId,
    required this.isPlaying,
    this.compact = false,
    super.key,
  });

  final int songId;
  final bool isPlaying;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = compact ? 52.0 : 62.0;
    final radius = compact ? 18.0 : 22.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.18),
                const Color(0xFF00BFA6).withValues(alpha: 0.12),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.24),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius - 4),
              child: ArtImageWidget(
                id: songId,
                size: size - 8,
                borderRadius: radius - 4,
                defaultCoverBg: theme.colorScheme.surface,
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: -4,
          bottom: -4,
          child: _PlayingBadge(isPlaying: isPlaying),
        ),
      ],
    );
  }
}

class MiniPlayerHandle extends StatelessWidget {
  const MiniPlayerHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: context.theme.colorScheme.primary.withValues(alpha: 0.26),
      ),
    );
  }
}

class MiniPlaybackChip extends StatelessWidget {
  const MiniPlaybackChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(7, 3, 8, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.album_rounded,
            size: 13,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            context.localization.playback,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class MiniSongTitle extends StatelessWidget {
  const MiniSongTitle({this.songTitle, super.key});

  final String? songTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      songTitle ?? context.localization.unknownSong,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        height: 1.05,
      ),
    );
  }
}

class MiniPlayerSubtitle extends StatelessWidget {
  const MiniPlayerSubtitle({this.artist, super.key});

  final String? artist;

  @override
  Widget build(BuildContext context) {
    final displayArtist = (artist?.isNotEmpty ?? false)
        ? artist!
        : context.localization.unknownArtist;

    return Row(
      children: [
        Icon(
          Icons.person_rounded,
          size: 14,
          color: context.theme.colorScheme.primary.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            displayArtist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: context.theme.textTheme.bodyMedium?.color?.withValues(
                alpha: 0.78,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class MiniPlayerControls extends StatelessWidget {
  const MiniPlayerControls({
    required this.musicPlayerBloc,
    required this.currentSongId,
    required this.isLiked,
    required this.isPlaying,
    this.compact = false,
    super.key,
  });

  final MusicPlayerBloc musicPlayerBloc;
  final int currentSongId;
  final bool isLiked;
  final bool isPlaying;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.58),
            foregroundColor: theme.colorScheme.primary,
            minimumSize: const Size.square(40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 21,
          ),
          tooltip: isLiked
              ? context.localization.unlike
              : context.localization.like,
          onPressed: () {
            context.read<FavoriteSongsBloc>().add(
              ToggleFavoriteSongEvent(currentSongId),
            );
          },
        ),
        const SizedBox(width: 7),
        if (!compact)
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size.square(48),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shadowColor: theme.colorScheme.primary.withValues(alpha: 0.35),
              elevation: 8,
            ),
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 28,
            ),
            tooltip: isPlaying
                ? context.localization.pause
                : context.localization.play,
            onPressed: () {
              musicPlayerBloc.add(const TogglePlayPauseEvent());
            },
          ),
      ],
    );
  }
}

class _PlayingBadge extends StatelessWidget {
  const _PlayingBadge({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary,
        border: Border.all(color: theme.colorScheme.surface, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(
        isPlaying ? Icons.graphic_eq_rounded : Icons.pause_rounded,
        color: theme.colorScheme.onPrimary,
        size: 14,
      ),
    );
  }
}
