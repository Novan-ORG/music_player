import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/widgets/search_empty_state.dart';

class SearchResultsPanel extends StatelessWidget {
  const SearchResultsPanel({
    required this.songs,
    required this.query,
    required this.allSongsCount,
    required this.onSuggestionSelected,
    required this.suggestions,
    this.onRefresh,
    this.isNested = false,
    this.enableRefreshIndicator = true,
    super.key,
  });

  final List<Song> songs;
  final String query;
  final int allSongsCount;
  final ValueChanged<String> onSuggestionSelected;
  final List<String> suggestions;
  final Future<void> Function()? onRefresh;
  final bool isNested;
  final bool enableRefreshIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final hasQuery = query.isNotEmpty;
    final content = songs.isEmpty
        ? SearchEmptyState(
            query: query,
            suggestions: suggestions,
            onSuggestionSelected: onSuggestionSelected,
          )
        : ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: SongsView(
              songs: songs,
              onRefresh: onRefresh,
              bottomPadding: isNested ? 120 : 20,
              enableRefreshIndicator: enableRefreshIndicator,
            ),
          );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hideHeader = constraints.maxHeight < 96;
          final useCompactHeader = constraints.maxHeight < 168;
          final titleStyle = useCompactHeader
              ? theme.textTheme.titleSmall
              : theme.textTheme.titleMedium;
          final subtitleStyle =
              (useCompactHeader
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
                  );

          return Column(
            children: [
              if (!hideHeader)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    useCompactHeader ? 10 : 14,
                    16,
                    useCompactHeader ? 8 : 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasQuery
                                  ? context.localization.searchResultsFor(query)
                                  : context.localization.allSongs,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasQuery
                                  ? context.localization
                                        .searchMatchedSongsSummary(
                                          songs.length,
                                          allSongsCount,
                                        )
                                  : context.localization
                                        .searchTracksReadySummary(
                                          allSongsCount,
                                        ),
                              maxLines: useCompactHeader ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: useCompactHeader ? 9 : 10,
                          vertical: useCompactHeader ? 5 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${songs.length}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!hideHeader) const Divider(height: 1),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }
}
