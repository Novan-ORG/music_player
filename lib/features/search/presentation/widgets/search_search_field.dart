import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/widgets/search_action_button.dart';

class SearchSearchField extends StatelessWidget {
  const SearchSearchField({
    required this.controller,
    required this.isListening,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onVoiceTap,
    super.key,
  });

  final TextEditingController controller;
  final bool isListening;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onVoiceTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final hasQuery = controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => onSubmitted(controller.text),
            tooltip: MaterialLocalizations.of(context).searchFieldLabel,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
              size: 22,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: context.localization.searchHint,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          if (hasQuery) ...[
            const SizedBox(width: 8),
            SearchActionButton(
              icon: Icons.close_rounded,
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: onClear,
              compact: true,
            ),
          ],
          const SizedBox(width: 8),
          SearchActionButton(
            icon: isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
            tooltip: isListening
                ? context.localization.searchStopVoiceSearch
                : context.localization.searchStartVoiceSearch,
            onPressed: onVoiceTap,
            compact: true,
            isAccent: isListening,
          ),
        ],
      ),
    );
  }
}
