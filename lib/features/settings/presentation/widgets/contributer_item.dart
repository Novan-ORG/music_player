import 'package:flutter/material.dart';
import 'package:music_player/core/utils/launcher_utils.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:see_more_text/see_more_text.dart';

/// Contributor card showing info and contact options.
class ContributerItem extends StatelessWidget {
  const ContributerItem({
    required this.imagePath,
    required this.aboutContributer,
    required this.email,
    required this.linkTreeUrl,
    this.accentColor = const Color(0xFF3559E6),
    super.key,
  });

  final String imagePath;
  final String aboutContributer;
  final String email;
  final String linkTreeUrl;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            accentColor.withValues(alpha: 0.14),
            theme.colorScheme.surface.withValues(alpha: 0.98),
            theme.colorScheme.surface.withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            PositionedDirectional(
              top: -18,
              end: -14,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 92,
                color: accentColor.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 320;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ContributorAvatar(
                              imagePath: imagePath,
                              accentColor: accentColor,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _ContributorBody(
                                aboutContributer: aboutContributer,
                                accentColor: accentColor,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _ContributorAvatar(
                          imagePath: imagePath,
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 14),
                        _ContributorBody(
                          aboutContributer: aboutContributer,
                          accentColor: accentColor,
                        ),
                      ],
                      const SizedBox(height: 18),
                      Text(
                        context.localization.connectWithMe,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _ContactButton(
                            icon: Icons.email_outlined,
                            label: context.localization.gmail,
                            accentColor: accentColor,
                            onTap: () => LauncherUtils.openEmailApp(
                              toEmail: email,
                            ),
                          ),
                          _ContactButton(
                            icon: Icons.link_rounded,
                            label: context.localization.linktree,
                            accentColor: accentColor,
                            onTap: () => LauncherUtils.launchUrlExternally(
                              linkTreeUrl,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContributorAvatar extends StatelessWidget {
  const _ContributorAvatar({
    required this.imagePath,
    required this.accentColor,
  });

  final String imagePath;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.85),
            accentColor.withValues(alpha: 0.35),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 42,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}

class _ContributorBody extends StatelessWidget {
  const _ContributorBody({
    required this.aboutContributer,
    required this.accentColor,
  });

  final String aboutContributer;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 16,
                color: accentColor,
              ),
              const SizedBox(width: 6),
              Text(
                context.localization.createdBy,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SeeMoreText(
          text: aboutContributer,
          seeMoreText: context.localization.seeMore,
          seeLessText: context.localization.seeLess,
          textStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
            height: 1.65,
          ),
          seeMoreLessTextStyle: theme.textTheme.bodyLarge?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: accentColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
