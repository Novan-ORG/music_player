import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/widgets/widgets.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Search page for finding songs by query.
class SearchSongsPage extends StatefulWidget {
  const SearchSongsPage({super.key});

  @override
  State<SearchSongsPage> createState() => _SearchSongsPageState();
}

class _SearchSongsPageState extends State<SearchSongsPage> {
  static const int _maxSearchHistoryItems = 8;
  static const int _minSearchHistoryLength = 2;

  final TextEditingController _searchController = TextEditingController();
  late final SharedPreferences _preferences;
  String _query = '';
  List<String> _searchHistory = const [];

  @override
  void initState() {
    super.initState();
    _preferences = getIt.get<SharedPreferences>();
    _searchHistory = _sanitizeSearchHistory(
      _preferences.getStringList(PreferencesKeys.searchHistory) ?? const [],
    );
  }

  Future<void> _refreshSongs() async {
    final songsBloc = context.read<SongsBloc>();
    final refreshCompleted = songsBloc.stream.firstWhere(
      (state) => state.status != SongsStatus.loading,
    );

    songsBloc.add(
      LoadSongsEvent(sortConfig: songsBloc.state.sortConfig),
    );

    await refreshCompleted;
  }

  void _updateQuery(String value) {
    final normalized = value.trim();
    if (_query == normalized) {
      return;
    }

    setState(() {
      _query = normalized;
    });
  }

  void _applySuggestion(String value) {
    _searchController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _updateQuery(value);
    _storeSearchQuery(value);
  }

  void _submitSearch(String value) {
    final normalized = value.trim();
    _updateQuery(normalized);
    _storeSearchQuery(normalized);
  }

  List<String> _sanitizeSearchHistory(Iterable<String> values) {
    final history = <String>[];
    final seen = <String>{};

    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.length < _minSearchHistoryLength) {
        continue;
      }

      final normalized = trimmed.toLowerCase();
      if (!seen.add(normalized)) {
        continue;
      }

      history.add(trimmed);
      if (history.length >= _maxSearchHistoryItems) {
        break;
      }
    }

    return history;
  }

  List<String> _buildUpdatedSearchHistory(String query) {
    final normalized = query.trim();
    if (normalized.length < _minSearchHistoryLength) {
      return _searchHistory;
    }

    return _sanitizeSearchHistory([
      normalized,
      ..._searchHistory,
    ]);
  }

  bool _hasSameHistory(List<String> first, List<String> second) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }

  void _storeSearchQuery(String query, {bool notify = true}) {
    final updatedHistory = _buildUpdatedSearchHistory(query);
    if (_hasSameHistory(updatedHistory, _searchHistory)) {
      return;
    }

    if (notify && mounted) {
      setState(() {
        _searchHistory = updatedHistory;
      });
    } else {
      _searchHistory = updatedHistory;
    }

    unawaited(
      _preferences.setStringList(
        PreferencesKeys.searchHistory,
        updatedHistory,
      ),
    );
  }

  List<Song> _filterSongs(List<Song> songs) {
    final normalizedQuery = _query.toLowerCase();
    if (normalizedQuery.isEmpty) {
      return songs;
    }

    return songs
        .where((song) {
          return song.title.toLowerCase().contains(normalizedQuery) ||
              song.artist.toLowerCase().contains(normalizedQuery) ||
              song.album.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  List<String> _buildSuggestions(List<Song> songs) {
    final suggestions = <String>[];
    final seen = <String>{};

    void addSuggestion(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed.length > 28) {
        return;
      }

      final normalized = trimmed.toLowerCase();
      if (normalized == 'unknown' || normalized == '<unknown>') {
        return;
      }

      if (seen.add(normalized)) {
        suggestions.add(trimmed);
      }
    }

    for (final song in songs.take(16)) {
      addSuggestion(song.title);
      if (suggestions.length >= 3) {
        break;
      }
    }

    for (final song in songs.take(20)) {
      addSuggestion(song.artist);
      if (suggestions.length >= 6) {
        break;
      }
    }

    for (final song in songs.take(24)) {
      addSuggestion(song.album);
      if (suggestions.length >= 8) {
        break;
      }
    }

    return suggestions;
  }

  Widget _buildStateLayout({
    required Widget child,
    required int totalSongs,
    required List<String> suggestions,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        final header = SearchSongsAppbar(
          controller: _searchController,
          onQueryChanged: _updateQuery,
          onSearchSubmitted: _submitSearch,
          onSuggestionSelected: _applySuggestion,
          suggestions: suggestions.take(isWide ? 4 : 3).toList(),
          suggestionsLabel: context.localization.recent,
          resultCount: 0,
          totalSongs: totalSongs,
        );

        if (isWide) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                header,
                const SizedBox(height: 14),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: [
              header,
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideLayout({
    required SongsState state,
    required List<Song> filteredSongs,
    required List<String> suggestions,
    required bool showingSearchHistory,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideWidth = constraints.maxWidth >= 1280 ? 360.0 : 320.0;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: [
              SearchSongsAppbar(
                controller: _searchController,
                onQueryChanged: _updateQuery,
                onSearchSubmitted: _submitSearch,
                onSuggestionSelected: _applySuggestion,
                suggestions: suggestions.take(4).toList(),
                suggestionsLabel: showingSearchHistory
                    ? context.localization.recent
                    : context.localization.searchQuickPicks,
                resultCount: filteredSongs.length,
                totalSongs: state.allSongs.length,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: sideWidth,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SearchInsightPanel(
                          allSongs: state.allSongs,
                          filteredSongs: filteredSongs,
                          query: _query,
                          suggestions: suggestions.take(4).toList(),
                          onSuggestionSelected: _applySuggestion,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SearchResultsPanel(
                        songs: filteredSongs,
                        query: _query,
                        allSongsCount: state.allSongs.length,
                        onSuggestionSelected: _applySuggestion,
                        suggestions: suggestions,
                        onRefresh: _refreshSongs,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactLayout({
    required SongsState state,
    required List<Song> filteredSongs,
    required List<String> suggestions,
    required bool showingSearchHistory,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshSongs,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: SearchSongsAppbar(
                  controller: _searchController,
                  onQueryChanged: _updateQuery,
                  onSearchSubmitted: _submitSearch,
                  onSuggestionSelected: _applySuggestion,
                  suggestions: suggestions.take(3).toList(),
                  suggestionsLabel: showingSearchHistory
                      ? context.localization.recent
                      : context.localization.searchQuickPicks,
                  resultCount: filteredSongs.length,
                  totalSongs: state.allSongs.length,
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: SearchResultsPanel(
            songs: filteredSongs,
            query: _query,
            allSongsCount: state.allSongs.length,
            onSuggestionSelected: _applySuggestion,
            suggestions: suggestions,
            onRefresh: _refreshSongs,
            isNested: true,
            enableRefreshIndicator: false,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<SongsBloc, SongsState>(
        builder: (_, state) {
          final stateSuggestions = _query.isEmpty
              ? _searchHistory
              : const <String>[];

          if (state.status == SongsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SongsStatus.error) {
            return _buildStateLayout(
              totalSongs: state.allSongs.length,
              suggestions: stateSuggestions,
              child: SongsErrorLoading(
                eyebrow: context.localization.searchSongs,
                title: context.localization.searchLoadErrorTitle,
                message: context.localization.searchLoadErrorMessage,
                onRetry: () => context.read<SongsBloc>().add(
                  LoadSongsEvent(sortConfig: state.sortConfig),
                ),
              ),
            );
          }

          if (state.allSongs.isEmpty) {
            return _buildStateLayout(
              totalSongs: state.allSongs.length,
              suggestions: stateSuggestions,
              child: NoSongsWidget(
                eyebrow: context.localization.searchSongs,
                title: context.localization.searchEmptyLibraryTitle,
                message: context.localization.searchEmptyLibraryMessage,
                onRefresh: () {
                  context.read<SongsBloc>().add(const LoadSongsEvent());
                },
              ),
            );
          }

          final filteredSongs = _filterSongs(state.allSongs);
          final fallbackSuggestions = _buildSuggestions(state.allSongs);
          final showingSearchHistory =
              _query.isEmpty && _searchHistory.isNotEmpty;
          final suggestions = showingSearchHistory
              ? _searchHistory
              : fallbackSuggestions;

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.16),
                  const Color(0xFF00BFA6).withValues(alpha: 0.08),
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor,
                ],
                stops: const [0, 0.2, 0.46, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 960) {
                    return _buildWideLayout(
                      state: state,
                      filteredSongs: filteredSongs,
                      suggestions: suggestions,
                      showingSearchHistory: showingSearchHistory,
                    );
                  }

                  return _buildCompactLayout(
                    state: state,
                    filteredSongs: filteredSongs,
                    suggestions: suggestions,
                    showingSearchHistory: showingSearchHistory,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
