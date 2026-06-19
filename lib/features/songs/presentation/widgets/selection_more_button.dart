import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class SelectionMoreButton extends StatelessWidget {
  const SelectionMoreButton({
    required this.onAddToPlaylist,
    required this.onDelete,
    required this.onShare,
    required this.selectedCount,
    super.key,
  });

  final VoidCallback onAddToPlaylist;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return AppPopupMenuButton<_SelectionAction>(
      compact: true,
      enabled: selectedCount > 0,
      tooltip: context.localization.moreOptions,
      items: [
        AppPopupMenuEntry(
          value: _SelectionAction.addToPlaylist,
          label: context.localization.addToPlaylist,
          icon: Icons.playlist_add_rounded,
          iconColor: Colors.green,
        ),
        AppPopupMenuEntry(
          value: _SelectionAction.share,
          label: context.localization.share,
          icon: Icons.share_rounded,
          iconColor: Colors.blue,
        ),
        AppPopupMenuEntry(
          value: _SelectionAction.delete,
          label: context.localization.delete,
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case _SelectionAction.addToPlaylist:
            onAddToPlaylist();
            return;
          case _SelectionAction.share:
            onShare();
            return;
          case _SelectionAction.delete:
            onDelete();
            return;
        }
      },
    );
  }
}

class SelectionActionDock extends StatelessWidget {
  const SelectionActionDock({
    required this.onAddToPlaylist,
    required this.onDelete,
    required this.onShare,
    required this.selectedCount,
    super.key,
  });

  final VoidCallback onAddToPlaylist;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: GlassCard(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        padding: const EdgeInsets.all(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.98),
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.66),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _SelectionDockButton(
                icon: Icons.playlist_add_rounded,
                label: context.localization.addToPlaylist,
                color: Colors.green,
                onTap: onAddToPlaylist,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _SelectionDockButton(
                icon: Icons.share_rounded,
                label: context.localization.share,
                color: Colors.blue,
                onTap: onShare,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _SelectionDockButton(
                icon: Icons.delete_outline_rounded,
                label: context.localization.delete,
                color: theme.colorScheme.error,
                onTap: onDelete,
                destructive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionDockButton extends StatelessWidget {
  const _SelectionDockButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withValues(alpha: destructive ? 0.14 : 0.1),
            border: Border.all(
              color: color.withValues(alpha: destructive ? 0.22 : 0.14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: destructive ? color : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SelectionAction {
  addToPlaylist,
  share,
  delete,
}
