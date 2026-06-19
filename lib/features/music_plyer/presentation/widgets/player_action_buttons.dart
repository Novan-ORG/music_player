import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';

class PlayerActionButtons extends StatelessWidget {
  const PlayerActionButtons({
    super.key,
    this.playIconSize = 48,
  });

  final double playIconSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 380;
        final isTight = constraints.maxWidth < 330;
        final primaryIconSize = isTight
            ? math.min(playIconSize, 40).toDouble()
            : isCompact
            ? math.min(playIconSize, 44).toDouble()
            : playIconSize;
        final secondaryIconSize = primaryIconSize / 1.45;
        final modeIconSize = primaryIconSize / (isTight ? 2.25 : 2.1);
        final secondaryExtent = secondaryIconSize + 18;
        final primaryExtent = primaryIconSize + 28;
        final modeExtent = math
            .max(isTight ? 48 : 54, modeIconSize * (isTight ? 2.35 : 2.6))
            .toDouble();
        final controlsWidth =
            (modeExtent * 2) + (secondaryExtent * 2) + primaryExtent;
        final controlGap = math
            .max(
              isTight ? 6 : 10,
              math.min(
                isCompact ? 14 : 20,
                (constraints.maxWidth - controlsWidth) / 4,
              ),
            )
            .toDouble();

        return Directionality(
          textDirection: TextDirection.ltr,
          child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            builder: (context, state) {
              final musicPlayer = context.read<MusicPlayerBloc>();

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: modeExtent,
                    child: Center(
                      child: _ShuffleButton(
                        state: state,
                        musicPlayer: musicPlayer,
                        iconSize: modeIconSize,
                        extent: modeExtent,
                      ),
                    ),
                  ),
                  SizedBox(width: controlGap),
                  SizedBox(
                    width: secondaryExtent,
                    child: Center(
                      child: _PreviousButton(
                        state: state,
                        musicPlayer: musicPlayer,
                        iconSize: secondaryIconSize,
                      ),
                    ),
                  ),
                  SizedBox(width: controlGap),
                  SizedBox(
                    width: primaryExtent,
                    child: Center(
                      child: _PlayPauseButton(
                        state: state,
                        musicPlayer: musicPlayer,
                        iconSize: primaryIconSize,
                      ),
                    ),
                  ),
                  SizedBox(width: controlGap),
                  SizedBox(
                    width: secondaryExtent,
                    child: Center(
                      child: _NextButton(
                        state: state,
                        musicPlayer: musicPlayer,
                        iconSize: secondaryIconSize,
                      ),
                    ),
                  ),
                  SizedBox(width: controlGap),
                  SizedBox(
                    width: modeExtent,
                    child: Center(
                      child: _LoopButton(
                        state: state,
                        musicPlayer: musicPlayer,
                        iconSize: modeIconSize,
                        extent: modeExtent,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ShuffleButton extends StatelessWidget {
  const _ShuffleButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
    required this.extent,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;
  final double extent;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: state.shuffleEnabled
          ? context.localization.disableShuffle
          : context.localization.enableShuffle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _ModeToggleButton(
          key: ValueKey(state.shuffleEnabled),
          icon: Icons.shuffle_rounded,
          iconSize: iconSize,
          extent: extent,
          isActive: state.shuffleEnabled,
          onPressed: () => musicPlayer.add(
            SetShuffleEnabledEvent(isEnabled: !state.shuffleEnabled),
          ),
        ),
      ),
    );
  }
}

class _PreviousButton extends StatelessWidget {
  const _PreviousButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.localization.previous,
      child: _ControlButtonShell(
        icon: Icons.skip_previous_rounded,
        iconSize: iconSize,
        onPressed: state.hasPrevious
            ? () => musicPlayer.add(
                const SkipToPreviousEvent(),
              )
            : null,
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final isPlaying = state.status == MusicPlayerStatus.playing;

    return Tooltip(
      message: isPlaying
          ? context.localization.pause
          : context.localization.play,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: child,
        ),
        child: _ControlButtonShell(
          key: ValueKey(isPlaying),
          icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          iconSize: iconSize,
          isPrimary: true,
          onPressed: () => musicPlayer.add(const TogglePlayPauseEvent()),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.localization.next,
      child: _ControlButtonShell(
        icon: Icons.skip_next_rounded,
        iconSize: iconSize,
        onPressed: state.hasNext
            ? () => musicPlayer.add(
                const SkipToNextEvent(),
              )
            : null,
      ),
    );
  }
}

class _LoopButton extends StatelessWidget {
  const _LoopButton({
    required this.state,
    required this.musicPlayer,
    required this.iconSize,
    required this.extent,
  });

  final MusicPlayerState state;
  final MusicPlayerBloc musicPlayer;
  final double iconSize;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final loopConfig = _getLoopConfiguration(state.loopMode, context);

    return Tooltip(
      message: loopConfig.tooltip,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _ModeToggleButton(
          key: ValueKey(state.loopMode),
          icon: loopConfig.icon,
          iconColor: loopConfig.color,
          iconSize: iconSize,
          extent: extent,
          isActive: state.loopMode != PlayerLoopMode.off,
          isSingleMode: state.loopMode == PlayerLoopMode.one,
          onPressed: () => musicPlayer.add(
            SetPlayerLoopModeEvent(state.loopMode),
          ),
        ),
      ),
    );
  }

  _LoopConfig _getLoopConfiguration(
    PlayerLoopMode mode,
    BuildContext context,
  ) {
    final colorScheme = context.theme.colorScheme;

    return switch (mode) {
      PlayerLoopMode.one => _LoopConfig(
        icon: Icons.repeat_one_rounded,
        tooltip: context.localization.repeatOne,
        color: colorScheme.primary,
      ),
      PlayerLoopMode.all => _LoopConfig(
        icon: Icons.repeat_rounded,
        tooltip: context.localization.repeatAll,
        color: colorScheme.primary,
      ),
      PlayerLoopMode.off => _LoopConfig(
        icon: Icons.repeat_rounded,
        tooltip: context.localization.noRepeat,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    };
  }
}

class _LoopConfig {
  const _LoopConfig({
    required this.icon,
    required this.tooltip,
    required this.color,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
}

class _ControlButtonShell extends StatelessWidget {
  const _ControlButtonShell({
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.isPrimary = false,
    super.key,
  });

  final IconData icon;
  final double iconSize;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final enabled = onPressed != null;
    final buttonSize = isPrimary ? iconSize + 28 : iconSize + 18;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: buttonSize,
      height: buttonSize,
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
            : colorScheme.surface.withValues(alpha: enabled ? 0.88 : 0.45),
        border: Border.all(
          color: isPrimary
              ? colorScheme.primary.withValues(alpha: 0.16)
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          if (isPrimary)
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.32),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        splashRadius: buttonSize / 2,
        iconSize: iconSize,
        icon: Icon(
          icon,
          color: isPrimary
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withValues(
                  alpha: enabled ? 0.82 : 0.4,
                ),
        ),
      ),
    );
  }
}

class _ModeToggleButton extends StatelessWidget {
  const _ModeToggleButton({
    required this.icon,
    required this.iconSize,
    required this.extent,
    required this.onPressed,
    this.iconColor,
    this.isActive = false,
    this.isSingleMode = false,
    super.key,
  });

  final IconData icon;
  final double iconSize;
  final double extent;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final bool isActive;
  final bool isSingleMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: extent,
      height: extent,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isActive
            ? LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.16),
                  colorScheme.primary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive ? null : colorScheme.surface.withValues(alpha: 0.66),
        border: Border.all(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.14),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            splashRadius: 28,
            iconSize: iconSize,
            icon: Icon(
              icon,
              color:
                  iconColor ??
                  (isActive
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.74)),
            ),
          ),
          Positioned(
            bottom: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: isActive ? (isSingleMode ? 20 : 16) : 6,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
