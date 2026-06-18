import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    required this.query,
    required this.suggestions,
    required this.onSuggestionSelected,
    super.key,
  });

  final String query;
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AppStateView(
      framed: false,
      maxWidth: 460,
      eyebrow: context.localization.searchInstantSearch,
      accentColor: theme.colorScheme.primary,
      title: context.localization.searchNoMatchesTitle(query),
      message: context.localization.searchNoMatchesMessage,
      illustration: Icon(
        Icons.search_off_rounded,
        color: theme.colorScheme.primary,
        size: 42,
      ),
      footer: suggestions.isEmpty
          ? null
          : Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: suggestions
                  .take(6)
                  .map(
                    (suggestion) => ActionChip(
                      label: Text(suggestion),
                      onPressed: () => onSuggestionSelected(suggestion),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: theme.colorScheme.surface,
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
    );
  }
}
