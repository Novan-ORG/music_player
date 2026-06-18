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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        hasQuery
                            ? context.localization.searchResultsFor(query)
                            : context.localization.allSongs,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        hasQuery
                            ? context.localization.searchMatchedSongsSummary(
                                songs.length,
                                allSongsCount,
                              )
                            : context.localization.searchTracksReadySummary(
                                allSongsCount,
                              ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.56,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
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
          const Divider(height: 1),
          Expanded(
            child: songs.isEmpty
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
                  ),
          ),
        ],
      ),
    );
  }
}
