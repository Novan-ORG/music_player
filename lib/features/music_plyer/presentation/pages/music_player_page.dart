import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/music_plyer/presentation/widgets/widgets.dart';
import 'package:music_player/features/playlist/presentation/pages/pages.dart';
import 'package:music_player/features/settings/presentation/bloc/bloc.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:volume_controller/volume_controller.dart';

/// Full-screen music player page.
///
/// Features:
/// - Large album artwork display
/// - Song information (title, artist)
/// - Waveform-based progress indicator
/// - Playback controls (play, pause, next, prev)
/// - Loop and shuffle modes
/// - Queue/upcoming songs display
/// - Share and favorite options
/// - Volume control
class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({
    this.enableArtworkHero = true,
    super.key,
  });

  final bool enableArtworkHero;

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with
        SongSharingMixin,
        RingtoneMixin,
        PlaylistManagementMixin,
        SongDeletionMixin,
        ToggleLikeMixin {
  static const _sleepTimerOptions = <_SleepTimerOption>[
    _SleepTimerOption(value: '15', icon: Icons.nights_stay_outlined),
    _SleepTimerOption(value: '30', icon: Icons.bedtime_outlined),
    _SleepTimerOption(value: '60', icon: Icons.hotel_rounded),
    _SleepTimerOption(value: 'custom', icon: Icons.tune_rounded),
  ];

  late final VolumeController _volumeController = getIt.get<VolumeController>();

  void _showErrorBanner(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              context.localization.dismiss,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Duration _remainingDuration(DateTime? sleepEndTime) {
    if (sleepEndTime == null) {
      return Duration.zero;
    }

    final remainingDuration = sleepEndTime.difference(DateTime.now());
    return remainingDuration.isNegative ? Duration.zero : remainingDuration;
  }

  Future<void> _handleSleepTimerTap(SettingsState settingsState) async {
    final remainingDuration = _remainingDuration(settingsState.sleepEndTime);

    if (remainingDuration > Duration.zero) {
      await CountDownSheet.show(
        context: context,
        initialDuration: remainingDuration,
        onCancel: _cancelSleepTimer,
      );
      return;
    }

    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _SleepTimerOptionsSheet(
        options: _sleepTimerOptions,
      ),
    );

    if (!mounted || selectedValue == null) {
      return;
    }

    if (selectedValue == 'custom') {
      final duration = await showModalBottomSheet<Duration>(
        context: context,
        isScrollControlled: true,
        builder: (context) => const DurationPickerSheet(),
      );
      if (!mounted || duration == null || duration <= Duration.zero) {
        return;
      }
      _setSleepTimer(duration);
      return;
    }

    final duration = Duration(minutes: int.tryParse(selectedValue) ?? 0);
    if (duration > Duration.zero) {
      _setSleepTimer(duration);
    }
  }

  void _setSleepTimer(Duration duration) {
    context.read<SettingsBloc>().add(
      ChangeSleepTimerEvent(DateTime.now().add(duration)),
    );
  }

  void _cancelSleepTimer() {
    context.read<SettingsBloc>().add(const ChangeSleepTimerEvent(null));
  }

  void _showQueueSheet() {
    UpnextMusicsSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();

    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      bloc: musicPlayerBloc,
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          _showErrorBanner(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final layout = _PlayerPageLayout.fromConstraints(constraints);
            final currentSong = state.currentSong;
            final currentSongId = currentSong?.id ?? 0;

            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leadingWidth: layout.appBarLeadingWidth,
                leading: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: layout.toolbarInset,
                    top: 6,
                  ),
                  child: _ToolbarIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  context.localization.playback,
                  style: context.theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 0.4,
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.62,
                    ),
                  ),
                ),
                actions: [
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, settingsState) {
                      final hasActiveTimer =
                          _remainingDuration(settingsState.sleepEndTime) >
                          Duration.zero;
                      return _ToolbarIconButton(
                        icon: hasActiveTimer
                            ? Icons.timer_rounded
                            : Icons.timer_outlined,
                        isActive: hasActiveTimer,
                        onPressed: () => _handleSleepTimerTap(settingsState),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _ToolbarIconButton(
                    icon: Icons.share_rounded,
                    onPressed: currentSong == null
                        ? null
                        : () => shareSong(currentSong),
                  ),
                  SizedBox(width: layout.toolbarInset),
                ],
              ),
              body: Stack(
                children: [
                  _PlayerBackdrop(
                    songId: currentSongId,
                    layout: layout,
                  ),
                  SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: layout.contentMaxWidth,
                        ),
                        child: SingleChildScrollView(
                          padding: layout.contentPadding,
                          child: _PlayerDetailsContent(
                            enableArtworkHero: widget.enableArtworkHero,
                            layout: layout,
                            currentSongId: currentSongId,
                            songInfo: SongInfo(
                              song: currentSong,
                              onLikePressed: currentSong == null
                                  ? null
                                  : () => onToggleLike(currentSong.id),
                              onDeletePressed: currentSong == null
                                  ? null
                                  : () => showDeleteSongDialog(currentSong),
                              onSetAsRingtonePressed: currentSong == null
                                  ? null
                                  : () => setAsRingtone(currentSong.data),
                              onAddToPlaylistPressed: () {
                                PlaylistsPage.showSheet(
                                  context: context,
                                  songIds: currentSong == null
                                      ? null
                                      : {currentSong.id},
                                );
                              },
                            ),
                            playbackCard: _PlayerPlaybackCard(
                              layout: layout,
                              songIndex: state.currentSongIndex,
                              durationStream: musicPlayerBloc.durationStream,
                              positionStream: musicPlayerBloc.positionStream,
                              volumeController: _volumeController,
                              onSeek: (duration) {
                                musicPlayerBloc.add(
                                  SeekMusicEvent(position: duration),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: _QueueHandleButton(
                size: layout.queueButtonSize,
                iconSize: layout.queueIconSize,
                onTap: _showQueueSheet,
              ),
            );
          },
        );
      },
    );
  }
}

class _PlayerPageLayout {
  const _PlayerPageLayout({
    required this.viewportWidth,
    required this.viewportHeight,
    required this.isWideLayout,
    required this.contentMaxWidth,
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.sectionSpacing,
    required this.cardPadding,
    required this.artworkSize,
    required this.artworkFramePadding,
    required this.artworkBorderRadius,
    required this.artworkFrameBorderRadius,
    required this.playButtonIconSize,
    required this.queueButtonSize,
    required this.queueIconSize,
    required this.toolbarInset,
    required this.appBarLeadingWidth,
  });

  factory _PlayerPageLayout.fromConstraints(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    final isCompact = width < 360;
    final isWideLayout = width >= 720 && width > height * 1.1;
    final isExpanded = width >= 720;
    final contentMaxWidth =
        (isWideLayout
                ? math.min(width - 32, 1180)
                : isExpanded
                ? 720
                : width)
            .toDouble();
    final horizontalPadding = (isCompact ? 12 : 16).toDouble();
    final availableWidth =
        math.min(width, contentMaxWidth) - (horizontalPadding * 2);
    final artworkSize = math
        .min(
          isWideLayout
              ? math.min(height * 0.52, 360)
              : isExpanded
              ? 380
              : 330,
          math.max(
            180,
            availableWidth *
                (isWideLayout
                    ? 0.34
                    : isExpanded
                    ? 0.58
                    : 0.74),
          ),
        )
        .toDouble();

    return _PlayerPageLayout(
      viewportWidth: width,
      viewportHeight: height,
      isWideLayout: isWideLayout,
      contentMaxWidth: contentMaxWidth,
      horizontalPadding: horizontalPadding,
      topPadding: isWideLayout
          ? 12
          : isCompact
          ? 12
          : 16,
      bottomPadding: isCompact ? 104 : 120,
      sectionSpacing: isWideLayout
          ? 20
          : isCompact
          ? 16
          : 18,
      cardPadding: isCompact ? 16 : 18,
      artworkSize: artworkSize,
      artworkFramePadding: isCompact ? 14 : 18,
      artworkBorderRadius: isCompact ? 24 : 28,
      artworkFrameBorderRadius: isCompact ? 32 : 38,
      playButtonIconSize: isExpanded ? 52 : 48,
      queueButtonSize: isCompact ? 60 : 68,
      queueIconSize: isCompact ? 24 : 28,
      toolbarInset: isCompact ? 8 : 12,
      appBarLeadingWidth: isCompact ? 72 : 84,
    );
  }

  final double viewportWidth;
  final double viewportHeight;
  final bool isWideLayout;
  final double contentMaxWidth;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double sectionSpacing;
  final double cardPadding;
  final double artworkSize;
  final double artworkFramePadding;
  final double artworkBorderRadius;
  final double artworkFrameBorderRadius;
  final double playButtonIconSize;
  final double queueButtonSize;
  final double queueIconSize;
  final double toolbarInset;
  final double appBarLeadingWidth;

  EdgeInsets get contentPadding => EdgeInsets.fromLTRB(
    horizontalPadding,
    topPadding,
    horizontalPadding,
    bottomPadding,
  );
}

class _PlayerPlaybackCard extends StatefulWidget {
  const _PlayerPlaybackCard({
    required this.layout,
    required this.songIndex,
    required this.durationStream,
    required this.positionStream,
    required this.volumeController,
    required this.onSeek,
  });

  final _PlayerPageLayout layout;
  final int songIndex;
  final Stream<Duration?> durationStream;
  final Stream<Duration> positionStream;
  final VolumeController volumeController;
  final ValueChanged<Duration> onSeek;

  @override
  State<_PlayerPlaybackCard> createState() => _PlayerPlaybackCardState();
}

class _PlayerDetailsContent extends StatelessWidget {
  const _PlayerDetailsContent({
    required this.enableArtworkHero,
    required this.layout,
    required this.currentSongId,
    required this.playbackCard,
    required this.songInfo,
  });

  final bool enableArtworkHero;
  final _PlayerPageLayout layout;
  final int currentSongId;
  final Widget playbackCard;
  final Widget songInfo;

  @override
  Widget build(BuildContext context) {
    final artworkChild = _ArtworkShowcase(
      songId: currentSongId,
      layout: layout,
    );
    final artwork = enableArtworkHero
        ? Hero(
            tag: 'song_cover_$currentSongId',
            child: artworkChild,
          )
        : artworkChild;

    if (!layout.isWideLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: layout.sectionSpacing,
        children: [
          artwork,
          songInfo,
          playbackCard,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: layout.sectionSpacing),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: artwork,
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: layout.sectionSpacing,
            children: [
              songInfo,
              playbackCard,
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerPlaybackCardState extends State<_PlayerPlaybackCard> {
  static const _waveBarWidth = 5.0;

  List<double> _waveformData = const [];
  int _lastWaveformSongIndex = -2;
  double _lastWaveformWidth = 0;

  List<double> _resolveWaveformData(double availableWidth) {
    final normalizedWidth = math.max(availableWidth, 1).toDouble();

    if (_waveformData.isEmpty ||
        _lastWaveformSongIndex != widget.songIndex ||
        (normalizedWidth - _lastWaveformWidth).abs() > 24) {
      final seed = widget.songIndex < 0 ? 0 : widget.songIndex;
      final random = math.Random(seed);
      final totalWaveBars = math.max(
        1,
        (normalizedWidth / _waveBarWidth).floor(),
      );

      _waveformData = List.generate(
        totalWaveBars,
        (_) => random.nextDouble() * 33 + 5,
      );
      _lastWaveformSongIndex = widget.songIndex;
      _lastWaveformWidth = normalizedWidth;
    }

    return _waveformData;
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = context.theme.colorScheme.onSurface.withValues(
      alpha: 0.08,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final waveformData = _resolveWaveformData(
          constraints.maxWidth - (widget.layout.cardPadding * 2),
        );

        return GlassCard(
          borderRadius: BorderRadius.circular(32),
          padding: EdgeInsets.all(widget.layout.cardPadding),
          child: Column(
            spacing: widget.layout.sectionSpacing,
            children: [
              AudioProgress(
                durationStream: widget.durationStream,
                positionStream: widget.positionStream,
                waveformData: waveformData,
                onSeek: widget.onSeek,
              ),
              Divider(height: 1, color: dividerColor),
              PlayerActionButtons(
                playIconSize: widget.layout.playButtonIconSize,
              ),
              Divider(height: 1, color: dividerColor),
              VolumeSlider(
                volumeController: widget.volumeController,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArtworkShowcase extends StatelessWidget {
  const _ArtworkShowcase({
    required this.songId,
    required this.layout,
  });

  final int songId;
  final _PlayerPageLayout layout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Center(
      child: Container(
        padding: EdgeInsets.all(layout.artworkFramePadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(layout.artworkFrameBorderRadius),
          gradient: LinearGradient(
            colors: [
              colorScheme.surface.withValues(alpha: 0.96),
              colorScheme.surface.withValues(alpha: 0.72),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.18),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: ArtImageWidget(
          qualitySize: 500,
          id: songId,
          size: layout.artworkSize,
          borderRadius: layout.artworkBorderRadius,
        ),
      ),
    );
  }
}

class _PlayerBackdrop extends StatelessWidget {
  const _PlayerBackdrop({
    required this.songId,
    required this.layout,
  });

  final int songId;
  final _PlayerPageLayout layout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final isDark = context.theme.brightness == Brightness.dark;
    final primaryGlowSize = math
        .min(layout.viewportWidth * 0.52, 220)
        .toDouble();
    final secondaryGlowSize = math
        .min(
          layout.viewportWidth * 0.44,
          190,
        )
        .toDouble();
    final accentGlowSize = math
        .min(layout.viewportWidth * 0.38, 160)
        .toDouble();

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withValues(alpha: isDark ? 0.96 : 0.98),
                colorScheme.surfaceContainerLowest.withValues(alpha: 0.98),
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -20,
          child: _BackdropGlow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            size: primaryGlowSize,
          ),
        ),
        Positioned(
          top: 200,
          left: -60,
          child: _BackdropGlow(
            color: colorScheme.secondary.withValues(alpha: 0.14),
            size: secondaryGlowSize,
          ),
        ),
        Positioned(
          bottom: 60,
          right: -40,
          child: _BackdropGlow(
            color: colorScheme.primary.withValues(alpha: 0.12),
            size: accentGlowSize,
          ),
        ),
        IgnorePointer(
          child: Opacity(
            opacity: 0.05,
            child: Align(
              alignment: Alignment.topCenter,
              child: ArtImageWidget(
                id: songId,
                size: math.min(layout.viewportWidth * 1.15, 760).toDouble(),
                qualitySize: 700,
                borderRadius: 60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackdropGlow extends StatelessWidget {
  const _BackdropGlow({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 100,
              spreadRadius: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    this.onPressed,
    this.isActive = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.74),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.22)
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isActive ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _QueueHandleButton extends StatelessWidget {
  const _QueueHandleButton({
    required this.size,
    required this.iconSize,
    required this.onTap,
  });

  final double size;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.localization.upNext,
      child: GestureDetector(
        onTap: onTap,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            onTap();
          }
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                context.theme.colorScheme.primary,
                context.theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.primary.withValues(
                  alpha: 0.32,
                ),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: 0.88),
              shape: BoxShape.circle,
            ),
            child: ImageIcon(
              const AssetImage(ImageAssets.arrowUp),
              size: iconSize,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SleepTimerOptionsSheet extends StatelessWidget {
  const _SleepTimerOptionsSheet({
    required this.options,
  });

  final List<_SleepTimerOption> options;

  @override
  Widget build(BuildContext context) {
    final localizedLabels = <String, String>{
      '15': context.localization.min15,
      '30': context.localization.min30,
      '60': context.localization.hour1,
      'custom': context.localization.custom,
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final itemWidth = isLandscape
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.selectSleepTimerDuration,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: options
                      .map((option) {
                        return SizedBox(
                          width: itemWidth,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: context.theme.colorScheme.primary
                                    .withValues(
                                      alpha: 0.1,
                                    ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                option.icon,
                                color: context.theme.colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              localizedLabels[option.value] ?? option.value,
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () =>
                                Navigator.of(context).pop(option.value),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SleepTimerOption {
  const _SleepTimerOption({
    required this.value,
    required this.icon,
  });

  final String value;
  final IconData icon;
}
