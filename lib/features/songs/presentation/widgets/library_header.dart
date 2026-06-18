import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({
    required this.onSearchPressed,
    required this.onStartMixPressed,
    this.compact = false,
    super.key,
  });

  final VoidCallback onSearchPressed;
  final VoidCallback onStartMixPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1B1C1F);

    return BlocBuilder<SongsBloc, SongsState>(
      buildWhen: (previous, next) =>
          previous.allSongs.length != next.allSongs.length ||
          previous.status != next.status,
      builder: (context, songsState) {
        final hasSongs = songsState.allSongs.isNotEmpty;
        return Container(
          margin: compact
              ? const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8)
              : const EdgeInsets.fromLTRB(16, 12, 16, 10),
          padding: EdgeInsets.all(compact ? 14 : 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 24 : 28),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                theme.colorScheme.primary.withValues(alpha: isDark ? 0.5 : 0.3),
                const Color(0xFF00BFA6).withValues(alpha: isDark ? 0.3 : 0.22),
                theme.colorScheme.surface.withValues(alpha: isDark ? 0.8 : 0.9),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.52),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.1),
                blurRadius: 26,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: compact ? 10 : 16,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          context.localization.yourLibrary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              (compact
                                      ? theme.textTheme.headlineSmall
                                      : theme.textTheme.headlineMedium)
                                  ?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        Text(
                          context.localization.libraryHeroSubtitle,
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor.withValues(alpha: 0.74),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _HeaderIconButton(
                    tooltip: context.localization.searchSongs,
                    icon: Icons.search_rounded,
                    onPressed: onSearchPressed,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _LibraryStats(
                      songCount: songsState.allSongs.length,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: hasSongs ? onStartMixPressed : null,
                    icon: const Icon(Icons.shuffle_rounded, size: 19),
                    label: Text(context.localization.startMix),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF202124),
                      disabledBackgroundColor: Colors.white.withValues(
                        alpha: 0.34,
                      ),
                      disabledForegroundColor: textColor.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.18),
          foregroundColor: context.theme.colorScheme.onSurface,
          minimumSize: const Size.square(46),
        ),
      ),
    );
  }
}

class _LibraryStats extends StatelessWidget {
  const _LibraryStats({required this.songCount});

  final int songCount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumsBloc, AlbumsState>(
      buildWhen: (previous, next) =>
          previous.allAlbums.length != next.allAlbums.length,
      builder: (context, albumState) {
        return BlocBuilder<ArtistsBloc, ArtistsState>(
          buildWhen: (previous, next) =>
              previous.allArtists.length != next.allArtists.length,
          builder: (context, artistsState) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                spacing: 8,
                children: [
                  _StatPill(
                    icon: Icons.music_note_rounded,
                    value: songCount,
                    label: context.localization.songs,
                  ),
                  _StatPill(
                    icon: Icons.album_rounded,
                    value: albumState.allAlbums.length,
                    label: context.localization.albums,
                  ),
                  _StatPill(
                    icon: Icons.person_rounded,
                    value: artistsState.allArtists.length,
                    label: context.localization.artists,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.22 : 0.07,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Icon(icon, size: 15, color: theme.colorScheme.onSurface),
          Text(
            '$value $label',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
