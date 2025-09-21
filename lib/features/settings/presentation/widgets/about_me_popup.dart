import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/core/constants/strings_constants.dart';
import 'package:music_player/core/utils/launcher_utils.dart';
import 'package:music_player/extensions/context_ex.dart';

class AboutMePopup extends StatelessWidget {
  const AboutMePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        context.localization.aboutDeveloper,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/developer_avatar.jpg'),
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.developerStroy,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.appPurpose,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.connectWithMe,
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
                  tooltip: context.localization.linkedin,
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerLinkedIn,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.code),
                  tooltip: context.localization.github,
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerGithub,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email),
                  tooltip: context.localization.gmail,
                  onPressed: () => LauncherUtils.openEmailApp(
                    toEmail: StringsConstants.developerEmail,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.telegram),
                  tooltip: context.localization.telegram,
                  onPressed: () => LauncherUtils.launchUrlExternally(
                    StringsConstants.developerTelegram,
                  ),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.twitter),
                  tooltip: context.localization.twitter,
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
          child: Text(context.localization.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
