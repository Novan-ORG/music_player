import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/strings_constants.dart';
import 'package:music_player/core/utils/launcher_utils.dart';
import 'package:music_player/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:music_player/features/settings/presentation/widgets/about_me_popup.dart';
import 'package:music_player/features/settings/presentation/widgets/count_down_sheet.dart';
import 'package:music_player/features/settings/presentation/widgets/count_down_timer.dart';
import 'package:music_player/features/settings/presentation/widgets/custom_drop_down.dart';
import 'package:music_player/features/settings/presentation/widgets/duration_picker_sheet.dart';
import 'package:music_player/features/settings/presentation/widgets/section_tile.dart';
import 'package:music_player/features/settings/presentation/widgets/settings_card.dart';
import 'package:music_player/features/settings/presentation/widgets/setttings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsBloc = context.read<SettingsBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (context, state) {
          final mDuration =
              state.sleepEndTime?.difference(DateTime.now()) ?? Duration.zero;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(title: 'Appearance'),
                SettingsCard(
                  child: SettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Theme',
                    trailing: CustomDropdown(
                      value: state.themeMode,
                      items: const [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System'),
                        ),
                        DropdownMenuItem(value: 'dark', child: Text('Dark')),
                        DropdownMenuItem(value: 'light', child: Text('Light')),
                      ],
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          ChangeThemeEvent(value!),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SectionTitle(title: 'Playback'),
                SettingsCard(
                  child: SettingsTile(
                    icon: Icons.timer_rounded,
                    title: 'Sleep Timer',
                    trailing: mDuration <= Duration.zero
                        ? CustomDropdown(
                            value: '0',
                            items: const [
                              DropdownMenuItem(value: '0', child: Text('Off')),
                              DropdownMenuItem(
                                value: '15',
                                child: Text('15 min'),
                              ),
                              DropdownMenuItem(
                                value: '30',
                                child: Text('30 min'),
                              ),
                              DropdownMenuItem(
                                value: '60',
                                child: Text('1 hour'),
                              ),
                              DropdownMenuItem(
                                value: 'custom',
                                child: Text('Custom'),
                              ),
                            ],
                            onChanged: (value) async {
                              if (value == 'custom') {
                                final duration =
                                    await showModalBottomSheet<Duration>(
                                      context: context,
                                      builder: (context) => DurationPickerSheet(
                                        initialDuration: const Duration(
                                          minutes: 15,
                                        ),
                                      ),
                                    );
                                if (!mounted) return;
                                if (duration != null &&
                                    duration > Duration.zero) {
                                  final now = DateTime.now();
                                  final sleepEndTime = now.add(duration);
                                  settingsBloc.add(
                                    ChangeSleepTimerEvent(sleepEndTime),
                                  );
                                }
                                return;
                              } else {
                                final now = DateTime.now();
                                final duration = Duration(
                                  minutes: int.tryParse(value!) ?? 0,
                                );
                                final sleepEndTime = now.add(duration);
                                context.read<SettingsBloc>().add(
                                  ChangeSleepTimerEvent(sleepEndTime),
                                );
                              }
                            },
                          )
                        : InkWell(
                            onTap: () {
                              final remainedDuration =
                                  state.sleepEndTime?.difference(
                                    DateTime.now(),
                                  ) ??
                                  Duration.zero;
                              if (remainedDuration <= Duration.zero) {
                                return;
                              }
                              CountDownSheet.show(
                                context: context,
                                initialDuration: remainedDuration,
                                onCancel: () {
                                  settingsBloc.add(ChangeSleepTimerEvent(null));
                                },
                              );
                            },
                            child: CountDownTimer(
                              duration:
                                  state.sleepEndTime?.difference(
                                    DateTime.now(),
                                  ) ??
                                  Duration.zero,
                              onEnd: () {
                                settingsBloc.add(ClearSleepTimerEvent());
                              },
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                SectionTitle(title: 'Support'),
                SettingsCard(
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.feedback_rounded,
                        title: 'Send Feedback or Suggestions',
                        trailing: const Icon(
                          Icons.email_rounded,
                          color: Colors.blueAccent,
                        ),
                        onTap: () async {
                          final success = await LauncherUtils.openEmailApp(
                            toEmail: StringsConstants.supportEmail,
                            subject: StringsConstants.supportEmailSubject,
                          );
                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not open email app.'),
                              ),
                            );
                          }
                        },
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.info_rounded,
                        title: 'About Me',
                        trailing: const Icon(
                          Icons.telegram_rounded,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const AboutMePopup(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
