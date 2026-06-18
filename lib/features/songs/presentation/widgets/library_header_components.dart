part of 'library_header.dart';

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.collapseProgress,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final double collapseProgress;

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
          minimumSize: Size.square(_lerp(46, 40, collapseProgress)),
        ),
      ),
    );
  }
}

class _LibraryStats extends StatelessWidget {
  const _LibraryStats({
    required this.songCount,
    required this.collapseProgress,
  });

  final int songCount;
  final double collapseProgress;

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
                    collapseProgress: collapseProgress,
                  ),
                  _StatPill(
                    icon: Icons.album_rounded,
                    value: albumState.allAlbums.length,
                    label: context.localization.albums,
                    collapseProgress: collapseProgress,
                  ),
                  _StatPill(
                    icon: Icons.person_rounded,
                    value: artistsState.allArtists.length,
                    label: context.localization.artists,
                    collapseProgress: collapseProgress,
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
    required this.collapseProgress,
  });

  final IconData icon;
  final int value;
  final String label;
  final double collapseProgress;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isTight = collapseProgress > 0.72;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _lerp(10, 9, collapseProgress),
        vertical: _lerp(7, 6, collapseProgress),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: _lerp(
            theme.brightness == Brightness.dark ? 0.22 : 0.07,
            theme.brightness == Brightness.dark ? 0.18 : 0.05,
            collapseProgress,
          ),
        ),
        borderRadius: BorderRadius.circular(_lerp(16, 14, collapseProgress)),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: _lerp(0.16, 0.1, collapseProgress),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: _lerp(6, 5, collapseProgress),
        children: [
          Icon(
            icon,
            size: _lerp(15, 14, collapseProgress),
            color: theme.colorScheme.onSurface,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: Text(
              isTight ? '$value' : '$value $label',
              key: ValueKey('$isTight-$value-$label'),
              style:
                  TextStyle.lerp(
                    theme.textTheme.labelMedium,
                    theme.textTheme.labelSmall,
                    collapseProgress,
                  )?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartMixButton extends StatelessWidget {
  const _StartMixButton({
    required this.enabled,
    required this.collapseProgress,
    required this.onPressed,
    this.forceIconOnly = false,
    this.expand = false,
  });

  final bool enabled;
  final double collapseProgress;
  final VoidCallback onPressed;
  final bool forceIconOnly;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final labelVisible = !forceIconOnly && collapseProgress < 0.56;
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF202124),
      disabledBackgroundColor: Colors.white.withValues(alpha: 0.34),
      disabledForegroundColor: const Color(0xFF202124).withValues(alpha: 0.42),
      padding: EdgeInsets.symmetric(
        horizontal: _lerp(14, 10, collapseProgress),
        vertical: _lerp(10, 8, collapseProgress),
      ),
      minimumSize: Size(
        expand ? double.infinity : _lerp(0, 40, collapseProgress),
        _lerp(40, 38, collapseProgress),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_lerp(18, 16, collapseProgress)),
      ),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: labelVisible
          ? FilledButton.icon(
              key: const ValueKey('mix-label'),
              onPressed: enabled ? onPressed : null,
              icon: const Icon(Icons.shuffle_rounded, size: 19),
              label: Text(context.localization.startMix),
              style: buttonStyle,
            )
          : Tooltip(
              key: const ValueKey('mix-icon'),
              message: context.localization.startMix,
              child: FilledButton(
                onPressed: enabled ? onPressed : null,
                style: buttonStyle,
                child: const Icon(Icons.shuffle_rounded, size: 18),
              ),
            ),
    );
  }
}
