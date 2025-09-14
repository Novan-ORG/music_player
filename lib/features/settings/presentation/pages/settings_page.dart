import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:music_player/features/settings/presentation/widgets/custom_drop_down.dart';
import 'package:music_player/features/settings/presentation/widgets/section_tile.dart';
import 'package:music_player/features/settings/presentation/widgets/settings_card.dart';
import 'package:music_player/features/settings/presentation/widgets/setttings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedSleepTimer = 'off';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
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
                    trailing: CustomDropdown(
                      value: _selectedSleepTimer,
                      items: const [
                        DropdownMenuItem(value: 'off', child: Text('Off')),
                        DropdownMenuItem(value: '15min', child: Text('15 min')),
                        DropdownMenuItem(value: '30min', child: Text('30 min')),
                        DropdownMenuItem(value: '1hr', child: Text('1 hour')),
                        DropdownMenuItem(
                          value: 'custom',
                          child: Text('Custom'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedSleepTimer = value!);
                      },
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
                        title: 'Send Feedback Or Recommendations',
                        trailing: const Icon(
                          Icons.email_rounded,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.info_rounded,
                        title: 'About Me',
                        trailing: const Icon(
                          Icons.telegram_rounded,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {},
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
