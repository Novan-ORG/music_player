import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/widgets/widgets.dart';
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            BrandShowcase(
              eyebrow: context.localization.brandTagline,
              title: context.localization.brandName,
              description: context.localization.brandAboutMessage,
              footer: VersionInfo(
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
            ),
            GlassCard(
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.all(20),
              child: Text(
                context.localization.appPurpose,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
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
            ContributerItem(
              imagePath: ImageAssets.caroAvatar,
              aboutContributer: context.localization.caroStory,
              email: StringsConstants.caroEmail,
              linkTreeUrl: StringsConstants.caroLinktreeUrl,
            ),
            ContributerItem(
              imagePath: ImageAssets.elhamAvatar,
              aboutContributer: context.localization.elhamStory,
              email: StringsConstants.elhamEmail,
              linkTreeUrl: StringsConstants.elhamLinktreeUrl,
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
