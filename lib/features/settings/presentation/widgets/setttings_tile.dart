import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final currentTrailing = trailing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                theme.colorScheme.surface.withValues(alpha: 0.98),
                theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.28,
                ),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 10,
            minLeadingWidth: 42,
            titleAlignment: ListTileTitleAlignment.center,
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: 0.08,
                  ),
                ),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            subtitle: subtitle == null
                ? null
                : Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.62,
                      ),
                      height: 1.2,
                    ),
                  ),
            trailing: currentTrailing,
          ),
        ),
      ),
    );
  }
}
