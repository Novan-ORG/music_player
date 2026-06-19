import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.title,
    required this.message,
    super.key,
    this.illustration,
    this.eyebrow,
    this.actionLabel,
    this.onAction,
    this.actionIcon = Icons.refresh_rounded,
    this.accentColor,
    this.footer,
    this.framed = true,
    this.maxWidth = 520,
  });

  final String title;
  final String message;
  final Widget? illustration;
  final String? eyebrow;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final Color? accentColor;
  final Widget? footer;
  final bool framed;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final resolvedAccent = accentColor ?? colorScheme.primary;

    Widget buildTextContent({required bool centered}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (eyebrow != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: resolvedAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                eyebrow!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: resolvedAccent,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: centered ? TextAlign.center : TextAlign.start,
              ),
            ),
            const SizedBox(height: 18),
          ],
          Text(
            title,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.62),
              height: 1.45,
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon, size: 20),
              label: Text(actionLabel!),
              style: FilledButton.styleFrom(
                backgroundColor: resolvedAccent,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                minimumSize: Size(centered ? 0 : 220, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 18),
            footer!,
          ],
        ],
      );
    }

    Widget buildIllustration(double size) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              resolvedAccent.withValues(alpha: 0.16),
              resolvedAccent.withValues(alpha: 0.03),
            ],
          ),
          border: Border.all(
            color: resolvedAccent.withValues(alpha: 0.14),
          ),
        ),
        child: Center(
          child:
              illustration ??
              Icon(
                Icons.music_off_rounded,
                size: size * 0.42,
                color: resolvedAccent,
              ),
        ),
      );
    }

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final useWideLayout = constraints.maxWidth >= 720;

        if (useWideLayout) {
          return Row(
            children: [
              buildIllustration(104),
              const SizedBox(width: 24),
              Expanded(
                child: buildTextContent(centered: false),
              ),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildIllustration(112),
            const SizedBox(height: 24),
            buildTextContent(centered: true),
          ],
        );
      },
    );

    if (framed) {
      content = Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: content,
      );
    }

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: content,
        ),
      ),
    );
  }
}
