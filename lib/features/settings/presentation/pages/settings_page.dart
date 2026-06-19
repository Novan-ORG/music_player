import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/utils/utils.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/settings/presentation/bloc/bloc.dart';
import 'package:music_player/features/settings/presentation/pages/pages.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';

/// Settings configuration page.
///
/// Sections:
/// - Appearance (theme mode, language selection)
/// - Playback (sleep timer, sound quality)
/// - Storage (cache clearing)
/// - About (version, contributors, contact)
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (context, state) {
          final mDuration =
              state.sleepEndTime?.difference(DateTime.now()) ?? Duration.zero;
          final hasMiniPlayer = context.select<MusicPlayerBloc, bool>(
            (bloc) => bloc.state.playList.isNotEmpty,
          );

          final languageLabel = state.currentLocale.languageCode == 'fa'
              ? 'فارسی (fa)'
              : 'English (en)';
          final themeLabel = switch (state.themeMode) {
            'dark' => context.localization.dark,
            'light' => context.localization.light,
            _ => context.localization.system,
          };

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.16),
                  const Color(0xFF3559E6).withValues(alpha: 0.06),
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor,
                ],
                stops: const [0, 0.18, 0.42, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth >= 980
                      ? 920.0
                      : constraints.maxWidth;
                  final isWide = maxWidth >= 760;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          hasMiniPlayer ? 152 : 28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SettingsPageHeader(
                              languageLabel: languageLabel,
                              themeLabel: themeLabel,
                            ),
                            if (isWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _AppearanceSection(
                                      state: state,
                                      languageLabel: languageLabel,
                                      themeLabel: themeLabel,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _PlaybackSection(
                                      duration: mDuration,
                                      sleepEndTime: state.sleepEndTime,
                                      settingsBloc: settingsBloc,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              _AppearanceSection(
                                state: state,
                                languageLabel: languageLabel,
                                themeLabel: themeLabel,
                              ),
                              const SizedBox(height: 16),
                              _PlaybackSection(
                                duration: mDuration,
                                sleepEndTime: state.sleepEndTime,
                                settingsBloc: settingsBloc,
                              ),
                            ],
                            const SizedBox(height: 16),
                            SettingsSectionCard(
                              title: context.localization.support,
                              icon: Icons.support_agent_rounded,
                              children: [
                                SettingsTile(
                                  icon: Icons.feedback_rounded,
                                  title: context
                                      .localization
                                      .sendFeedbackOrSuggestion,
                                  onTap: () async {
                                    final success =
                                        await LauncherUtils.openEmailApp(
                                          toEmail:
                                              StringsConstants.supportEmail,
                                          subject: context
                                              .localization
                                              .feedbackEmailSubject,
                                        );
                                    if (!success && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            context.localization.errorOpenEmail,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                SettingsTile(
                                  icon: Icons.info_rounded,
                                  title: context.localization.aboutUs,
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const AboutUsPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({
    required this.state,
    required this.languageLabel,
    required this.themeLabel,
  });

  final SettingsState state;
  final String languageLabel;
  final String themeLabel;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: context.localization.appearance,
      icon: Icons.palette_outlined,
      children: [
        SettingsTile(
          icon: Icons.language_rounded,
          title: context.localization.language,
          subtitle: languageLabel,
          trailing: CustomDropdown(
            value: state.currentLocale.languageCode,
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text('English (en)'),
              ),
              DropdownMenuItem(
                value: 'fa',
                child: Text('فارسی (fa)'),
              ),
            ],
            onChanged: (value) {
              context.read<SettingsBloc>().add(
                ChangeLanguageEvent(value!),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SettingsTile(
          icon: Icons.palette_rounded,
          title: context.localization.theme,
          subtitle: themeLabel,
          trailing: CustomDropdown(
            value: state.themeMode,
            items: [
              DropdownMenuItem(
                value: 'system',
                child: Text(context.localization.system),
              ),
              DropdownMenuItem(
                value: 'dark',
                child: Text(context.localization.dark),
              ),
              DropdownMenuItem(
                value: 'light',
                child: Text(context.localization.light),
              ),
            ],
            onChanged: (value) {
              context.read<SettingsBloc>().add(
                ChangeThemeEvent(value!),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlaybackSection extends StatelessWidget {
  const _PlaybackSection({
    required this.duration,
    required this.sleepEndTime,
    required this.settingsBloc,
  });

  final Duration duration;
  final DateTime? sleepEndTime;
  final SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: context.localization.playback,
      icon: Icons.play_circle_outline_rounded,
      children: [
        SettingsTile(
          icon: Icons.timer_rounded,
          title: context.localization.sleepTimer,
          subtitle: duration <= Duration.zero
              ? context.localization.off
              : context.localization.sleepTimerActive,
          trailing: duration <= Duration.zero
              ? CustomDropdown(
                  value: '0',
                  items: [
                    DropdownMenuItem(
                      value: '0',
                      child: Text(context.localization.off),
                    ),
                    DropdownMenuItem(
                      value: '15',
                      child: Text(context.localization.min15),
                    ),
                    DropdownMenuItem(
                      value: '30',
                      child: Text(context.localization.min30),
                    ),
                    DropdownMenuItem(
                      value: '60',
                      child: Text(context.localization.hour1),
                    ),
                    DropdownMenuItem(
                      value: 'custom',
                      child: Text(context.localization.custom),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == 'custom') {
                      final selectedDuration =
                          await showModalBottomSheet<Duration>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const DurationPickerSheet(),
                          );
                      if (!context.mounted) return;
                      if (selectedDuration != null &&
                          selectedDuration > Duration.zero) {
                        final sleepEndTime = DateTime.now().add(
                          selectedDuration,
                        );
                        settingsBloc.add(
                          ChangeSleepTimerEvent(sleepEndTime),
                        );
                      }
                      return;
                    }

                    final minutes = int.tryParse(value ?? '0') ?? 0;
                    final nextSleepEndTime = DateTime.now().add(
                      Duration(minutes: minutes),
                    );
                    context.read<SettingsBloc>().add(
                      ChangeSleepTimerEvent(nextSleepEndTime),
                    );
                  },
                )
              : _ActiveSleepTimerChip(
                  duration: duration,
                  onTap: () async {
                    final remainedDuration =
                        sleepEndTime?.difference(DateTime.now()) ??
                        Duration.zero;
                    if (remainedDuration <= Duration.zero) {
                      return;
                    }
                    await CountDownSheet.show(
                      context: context,
                      initialDuration: remainedDuration,
                      onCancel: () {
                        settingsBloc.add(
                          const ChangeSleepTimerEvent(null),
                        );
                      },
                    );
                  },
                  onEnd: () {
                    settingsBloc.add(ClearSleepTimerEvent());
                  },
                ),
        ),
      ],
    );
  }
}

class _ActiveSleepTimerChip extends StatelessWidget {
  const _ActiveSleepTimerChip({
    required this.duration,
    required this.onTap,
    required this.onEnd,
  });

  final Duration duration;
  final VoidCallback onTap;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              CountDownTimer(
                duration: duration,
                onEnd: onEnd,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
