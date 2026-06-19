import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/settings/presentation/widgets/widgets.dart';

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    required this.languageLabel,
    required this.themeLabel,
    super.key,
  });

  final String languageLabel;
  final String themeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF1F2023);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;

        return Container(
          margin: const EdgeInsets.fromLTRB(14, 8, 14, 10),
          padding: EdgeInsets.all(isWide ? 18 : 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                theme.colorScheme.primary.withValues(
                  alpha: isDark ? 0.52 : 0.26,
                ),
                const Color(0xFF3559E6).withValues(alpha: isDark ? 0.44 : 0.26),
                theme.colorScheme.surface.withValues(
                  alpha: isDark ? 0.88 : 0.95,
                ),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.42),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.06),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderIcon(theme: theme, isDark: isDark),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _HeaderContent(
                        titleColor: titleColor,
                        languageLabel: languageLabel,
                        themeLabel: themeLabel,
                      ),
                    ),
                  ],
                )
              : _HeaderContent(
                  titleColor: titleColor,
                  languageLabel: languageLabel,
                  themeLabel: themeLabel,
                  leading: _HeaderIcon(theme: theme, isDark: isDark),
                ),
        );
      },
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({
    required this.titleColor,
    required this.languageLabel,
    required this.themeLabel,
    this.leading,
  });

  final Color titleColor;
  final String languageLabel;
  final String themeLabel;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final title = Text(
      context.localization.settings,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: titleColor,
        fontWeight: FontWeight.w800,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null)
          Row(
            children: [
              leading!,
              const SizedBox(width: 10),
              Expanded(child: title),
            ],
          )
        else
          title,
        const SizedBox(height: 4),
        Text(
          context.localization.brandSettingsMessage,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: titleColor.withValues(alpha: 0.72),
            height: 1.32,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _HeaderChip(
              icon: Icons.language_rounded,
              label: languageLabel,
            ),
            _HeaderChip(
              icon: Icons.palette_rounded,
              label: themeLabel,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTight = constraints.maxWidth < 280;
              final createdByStyle = theme.textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              );
              final versionStyle = theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              );

              return Wrap(
                spacing: 6,
                runSpacing: isTight ? 3 : 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTight ? constraints.maxWidth : 190,
                    ),
                    child: Text(
                      context.localization.createdBy,
                      maxLines: isTight ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: isTight,
                      style: createdByStyle,
                    ),
                  ),
                  VersionInfo(style: versionStyle),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.theme,
    required this.isDark,
  });

  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.78),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.34),
        ),
      ),
      child: Icon(
        Icons.settings_rounded,
        color: theme.colorScheme.primary,
        size: 24,
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.34),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
