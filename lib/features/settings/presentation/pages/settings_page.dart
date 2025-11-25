import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/utils/utils.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/settings/presentation/bloc/bloc.dart';
import 'package:music_player/features/settings/presentation/pages/pages.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.settings),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (context, state) {
          final mDuration =
              state.sleepEndTime?.difference(DateTime.now()) ?? Duration.zero;
          return Container(
            padding: EdgeInsets.only(
              top: 16,
              bottom: context.read<MusicPlayerBloc>().state.playList.isEmpty
                  ? 16
                  : 80,
              left: 20,
              right: 20,
            ),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  SectionTitle(title: context.localization.appearance),
                  SettingsCard(
                    child: SettingsTile(
                      icon: Icons.language,
                      title: context.localization.language,
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
                  ),
                  SettingsCard(
                    child: SettingsTile(
                      icon: Icons.palette_rounded,
                      title: context.localization.theme,
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
                  ),
                  const SizedBox(height: 24),
                  SectionTitle(title: context.localization.playback),
                  SettingsCard(
                    child: SettingsTile(
                      icon: Icons.timer_rounded,
                      title: context.localization.sleepTimer,
                      trailing: mDuration <= Duration.zero
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
                                  final duration =
                                      await showModalBottomSheet<Duration>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) =>
                                            const DurationPickerSheet(),
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
                              onTap: () async {
                                final remainedDuration =
                                    state.sleepEndTime?.difference(
                                      DateTime.now(),
                                    ) ??
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
                  SectionTitle(title: context.localization.support),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.feedback_rounded,
                          title: context.localization.sendFeedbackOrSuggestion,
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
                                SnackBar(
                                  content: Text(
                                    context.localization.errorOpenEmail,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const Divider(height: 1),
                        SettingsTile(
                          icon: Icons.info_rounded,
                          title: context.localization.aboutUs,
                          trailing: const Icon(
                            Icons.telegram_rounded,
                            color: Colors.blueAccent,
                          ),
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const VersionInfo(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
