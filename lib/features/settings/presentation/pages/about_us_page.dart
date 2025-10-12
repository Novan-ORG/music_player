import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localization.aboutUs,
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  ImageAssets.logo,
                ),
              ),
            ),
            Text(
              context.localization.appPurpose,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              '${context.localization.aboutContributers} :',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ContributerItem(
              imagePath: ImageAssets.talebAvatar,
              aboutContributer: context.localization.talebStory,
              email: StringsConstants.talebEmail,
              linkTreeUrl: StringsConstants.talebLinktreeUrl,
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
        ).padding(value: 12),
      ),
      bottomNavigationBar: SafeArea(
        child: ElevatedButton(
          child: Text(context.localization.close),
          onPressed: () => Navigator.of(context).pop(),
        ).padding(value: 12),
      ),
    );
  }
}
