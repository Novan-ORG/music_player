import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/widgets/search_metric_card.dart';

class SearchInsightPanel extends StatelessWidget {
  const SearchInsightPanel({
    required this.allSongs,
    required this.filteredSongs,
    required this.query,
    required this.suggestions,
    required this.onSuggestionSelected,
    this.compact = false,
    super.key,
  });

  final List<Song> allSongs;
  final List<Song> filteredSongs;
  final String query;
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final artistCount = allSongs.map((song) => song.artist).toSet().length;
    final albumCount = allSongs.map((song) => song.album).toSet().length;
    final hasQuery = query.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(compact ? 20 : 24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: compact ? 12 : 14,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hasQuery
                      ? context.localization.searchInMotionTitle
                      : context.localization.searchLibraryGlanceTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (hasQuery)
                Text(
                  '${filteredSongs.length}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SearchMetricCard(
                icon: Icons.music_note_rounded,
                value: '${allSongs.length}',
                label: context.localization.songs,
                compact: compact,
              ),
              SearchMetricCard(
                icon: Icons.album_rounded,
                value: '$albumCount',
                label: context.localization.albums,
                compact: compact,
              ),
              SearchMetricCard(
                icon: Icons.person_rounded,
                value: '$artistCount',
                label: context.localization.artists,
                compact: compact,
              ),
              SearchMetricCard(
                icon: Icons.search_rounded,
                value: '${filteredSongs.length}',
                label: hasQuery
                    ? context.localization.searchMatchesLabel
                    : context.localization.searchVisibleNow,
                compact: compact,
                isAccent: hasQuery,
              ),
            ],
          ),
          if (suggestions.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions
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
          ],
        ],
      ),
    );
  }
}
