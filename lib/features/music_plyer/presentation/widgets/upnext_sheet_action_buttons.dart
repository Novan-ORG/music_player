import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';

class UpnextSheetActionButtons extends StatelessWidget {
  const UpnextSheetActionButtons({
    super.key,
    this.playIconSize = 48,
  });

  final double playIconSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) {
        return previous.currentSongIndex != current.currentSongIndex ||
            previous.status != current.status;
      },
      builder: (context, state) {
        final musicPlayer = context.read<MusicPlayerBloc>();
        final secondarySize = playIconSize * 0.8;

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderTransportButton(
                icon: Icons.skip_previous_rounded,
                tooltip: context.localization.previous,
                size: secondarySize + 18,
                iconSize: secondarySize,
                onPressed: state.hasPrevious
                    ? () => musicPlayer.add(const SkipToPreviousEvent())
                    : null,
              ),
              const SizedBox(width: 10),
              _HeaderTransportButton(
                key: ValueKey(state.status),
                icon: state.status == MusicPlayerStatus.playing
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                tooltip: state.status == MusicPlayerStatus.playing
                    ? context.localization.pause
                    : context.localization.play,
                size: playIconSize + 22,
                iconSize: playIconSize,
                isPrimary: true,
                onPressed: () => musicPlayer.add(const TogglePlayPauseEvent()),
              ),
              const SizedBox(width: 10),
              _HeaderTransportButton(
                icon: Icons.skip_next_rounded,
                tooltip: context.localization.next,
                size: secondarySize + 18,
                iconSize: secondarySize,
                onPressed: state.hasNext
                    ? () => musicPlayer.add(const SkipToNextEvent())
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderTransportButton extends StatelessWidget {
  const _HeaderTransportButton({
    required this.icon,
    required this.tooltip,
    required this.size,
    required this.iconSize,
    this.isPrimary = false,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final double size;
  final double iconSize;
  final bool isPrimary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final enabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.84),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary
              ? null
              : colorScheme.surface.withValues(alpha: enabled ? 0.66 : 0.34),
          border: Border.all(
            color: isPrimary
                ? colorScheme.primary.withValues(alpha: 0.18)
                : colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.26),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          iconSize: iconSize,
          splashRadius: size / 2,
          icon: Icon(
            icon,
            color: isPrimary
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withValues(
                    alpha: enabled ? 0.82 : 0.34,
                  ),
          ),
        ),
      ),
    );
  }
}
