import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/utils/launcher_utils.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final contributors = [
      _ContributorData(
        imagePath: ImageAssets.talebAvatar,
        aboutContributer: context.localization.talebStory,
        email: StringsConstants.talebEmail,
        linkTreeUrl: StringsConstants.talebLinktreeUrl,
        accentColor: const Color(0xFF4A7DFF),
      ),
      _ContributorData(
        imagePath: ImageAssets.caroAvatar,
        aboutContributer: context.localization.caroStory,
        email: StringsConstants.caroEmail,
        linkTreeUrl: StringsConstants.caroLinktreeUrl,
        accentColor: const Color(0xFF8B5CF6),
      ),
      _ContributorData(
        imagePath: ImageAssets.elhamAvatar,
        aboutContributer: context.localization.elhamStory,
        email: StringsConstants.elhamEmail,
        linkTreeUrl: StringsConstants.elhamLinktreeUrl,
        accentColor: const Color(0xFF14B8A6),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.12),
              const Color(0xFF3559E6).withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0, 0.16, 0.42, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth >= 1120
                  ? 1040.0
                  : constraints.maxWidth;

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AboutTopBar(
                          onBack: () => Navigator.of(context).pop(),
                          onSupport: () => LauncherUtils.openEmailApp(
                            toEmail: StringsConstants.supportEmail,
                            subject:
                                context.localization.sendFeedbackOrSuggestion,
                          ),
                        ),
                        const SizedBox(height: 14),
                        BrandShowcase(
                          eyebrow: context.localization.brandTagline,
                          title: context.localization.brandName,
                          description: context.localization.brandAboutMessage,
                          isProminent: true,
                          footer: _AboutHeroFooter(
                            contributerCount: contributors.length,
                          ),
                        ),
                        const SizedBox(height: 18),
                        LayoutBuilder(
                          builder: (context, contentConstraints) {
                            final isWide = contentConstraints.maxWidth >= 860;

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _AppPurposeCard(
                                      onSupport: () {
                                        LauncherUtils.openEmailApp(
                                          toEmail:
                                              StringsConstants.supportEmail,
                                          subject: context
                                              .localization
                                              .sendFeedbackOrSuggestion,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: _QuickContactCard(
                                      onSupport: () {
                                        LauncherUtils.openEmailApp(
                                          toEmail:
                                              StringsConstants.supportEmail,
                                          subject: context
                                              .localization
                                              .sendFeedbackOrSuggestion,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                _AppPurposeCard(
                                  onSupport: () {
                                    LauncherUtils.openEmailApp(
                                      toEmail: StringsConstants.supportEmail,
                                      subject: context
                                          .localization
                                          .sendFeedbackOrSuggestion,
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                _QuickContactCard(
                                  onSupport: () {
                                    LauncherUtils.openEmailApp(
                                      toEmail: StringsConstants.supportEmail,
                                      subject: context
                                          .localization
                                          .sendFeedbackOrSuggestion,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        _SectionHeading(
                          title: context.localization.aboutContributers,
                          count: contributors.length,
                        ),
                        const SizedBox(height: 14),
                        LayoutBuilder(
                          builder: (context, contentConstraints) {
                            final isWide = contentConstraints.maxWidth >= 860;
                            final cardWidth = isWide
                                ? (contentConstraints.maxWidth - 16) / 2
                                : contentConstraints.maxWidth;

                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                for (final contributor in contributors)
                                  SizedBox(
                                    width: cardWidth,
                                    child: ContributerItem(
                                      imagePath: contributor.imagePath,
                                      aboutContributer:
                                          contributor.aboutContributer,
                                      email: contributor.email,
                                      linkTreeUrl: contributor.linkTreeUrl,
                                      accentColor: contributor.accentColor,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              context.localization.close,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutTopBar extends StatelessWidget {
  const _AboutTopBar({
    required this.onBack,
    required this.onSupport,
  });

  final VoidCallback onBack;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        _TopBarButton(
          icon: Icons.mail_outline_rounded,
          tooltip: context.localization.sendFeedbackOrSuggestion,
          onTap: onSupport,
        ),
        Expanded(
          child: Text(
            context.localization.aboutUs,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _TopBarButton(
          icon: Icons.arrow_forward_rounded,
          tooltip: context.localization.close,
          onTap: onBack,
        ),
      ],
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9),
        minimumSize: const Size.square(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
      ),
      icon: Icon(
        icon,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _AboutHeroFooter extends StatelessWidget {
  const _AboutHeroFooter({
    required this.contributerCount,
  });

  final int contributerCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _HeroPill(
              icon: Icons.groups_rounded,
              label:
                  '$contributerCount ${context.localization.aboutContributers}',
            ),
            _HeroPill(
              icon: Icons.support_agent_rounded,
              label: context.localization.support,
            ),
          ],
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 8),
                Text(
                  context.localization.createdBy,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                VersionInfo(
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppPurposeCard extends StatelessWidget {
  const _AppPurposeCard({
    required this.onSupport,
  });

  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            children: List.generate(
              5,
              (index) => const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC857),
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.localization.appPurpose,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.brandAboutMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onSupport,
            icon: const Icon(Icons.mail_outline_rounded),
            label: Text(context.localization.sendFeedbackOrSuggestion),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickContactCard extends StatelessWidget {
  const _QuickContactCard({
    required this.onSupport,
  });

  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.16),
            theme.colorScheme.surface.withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.forum_rounded,
              color: theme.colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.support,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.localization.sendFeedbackOrSuggestion,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onSupport,
            icon: const Icon(Icons.alternate_email_rounded),
            label: const Text(StringsConstants.supportEmail),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 50),
              alignment: AlignmentDirectional.centerStart,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.groups_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ContributorData {
  const _ContributorData({
    required this.imagePath,
    required this.aboutContributer,
    required this.email,
    required this.linkTreeUrl,
    required this.accentColor,
  });

  final String imagePath;
  final String aboutContributer;
  final String email;
  final String linkTreeUrl;
  final Color accentColor;
}
