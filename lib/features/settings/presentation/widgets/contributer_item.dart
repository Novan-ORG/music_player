import 'package:flutter/material.dart';
import 'package:music_player/core/utils/launcher_utils.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:see_more_text/see_more_text.dart';

/// Contributor card showing info and contact options.
///
/// Displays:
/// - Contributor avatar
/// - Bio/about text with expand/collapse
/// - Email and social media links
class ContributerItem extends StatelessWidget {
  const ContributerItem({
    required this.imagePath,
    required this.aboutContributer,
    required this.email,
    required this.linkTreeUrl,
    super.key,
  });

  final String imagePath;
  final String aboutContributer;
  final String email;
  final String linkTreeUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SeeMoreText(
                  text: aboutContributer,
                  maxLines: 3,
                  seeMoreText: context.localization.seeMore,
                  seeLessText: context.localization.seeLess,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${context.localization.connectWithMe} : ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.email),
                      tooltip: context.localization.gmail,
                      onPressed: () => LauncherUtils.openEmailApp(
                        toEmail: email,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: context.localization.linktree,
                      onPressed: () => LauncherUtils.launchUrlExternally(
                        linkTreeUrl,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
