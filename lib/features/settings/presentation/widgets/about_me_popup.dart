import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/core/constants/strings_constants.dart';
import 'package:music_player/core/utils/launcher_utils.dart';

class AboutMePopup extends StatelessWidget {
  const AboutMePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('About the Developer', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/developer_avatar.jpg'),
          ),
          const SizedBox(height: 16),
          const Text(
            "Hi! I'm Taleb, a passionate mobile developer with years of experience building beautiful and reliable apps for Android and iOS. I love creating user-friendly, high-performance applications that make people's lives easier.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "This app is completely free. If you enjoy using it, please consider supporting me by rating it 5 stars and leaving a kind comment on the app store!",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "Connect with me:",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.linkedin),
                  tooltip: 'LinkedIn',
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerLinkedIn,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.code),
                  tooltip: 'GitHub',
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerGithub,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email),
                  tooltip: 'Email',
                  onPressed: () => LauncherUtils.openEmailApp(
                    toEmail: StringsConstants.developerEmail,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.telegram),
                  tooltip: 'Telegram',
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerTelegram,
                  ),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.twitter),
                  tooltip: 'Twitter/X',
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerTwitter,
                  ),
                ),
              ],
            ),
          ),

          /// uncomment to add rate button after publishing the app
          // const SizedBox(height: 16),
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.star_rate),
          //   label: const Text('Rate this app'),
          //   onPressed: () => LauncherUtils.launchUrlExternally(
          //     'https://play.google.com/store/apps/details?id=com.example.music_player',
          //   ),
          // ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
