import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/widgets/search_action_button.dart';
import 'package:music_player/features/search/presentation/widgets/search_info_badge.dart';
import 'package:music_player/features/search/presentation/widgets/search_search_field.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchSongsAppbar extends StatefulWidget {
  const SearchSongsAppbar({
    required this.controller,
    required this.onQueryChanged,
    required this.onSearchSubmitted,
    required this.onSuggestionSelected,
    required this.suggestions,
    required this.suggestionsLabel,
    required this.resultCount,
    required this.totalSongs,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onSearchSubmitted;
  final ValueChanged<String> onSuggestionSelected;
  final List<String> suggestions;
  final String suggestionsLabel;
  final int resultCount;
  final int totalSongs;

  @override
  State<SearchSongsAppbar> createState() => _SearchSongsAppbarState();
}

class _SearchSongsAppbarState extends State<SearchSongsAppbar> {
  late final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant SearchSongsAppbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initAndStartListening() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (_) {
        if (mounted) {
          setState(() {});
        }
      },
      onError: (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );

    if (!_speechEnabled) {
      return;
    }

    await _startListening();
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      return;
    }

    FocusScope.of(context).unfocus();

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    if (mounted) {
      setState(() {});
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) {
      return;
    }

    final recognizedWords = result.recognizedWords;
    widget.controller.value = TextEditingValue(
      text: recognizedWords,
      selection: TextSelection.collapsed(offset: recognizedWords.length),
    );
    widget.onQueryChanged(recognizedWords);
  }

  void _clearQuery() {
    widget.controller.clear();
    widget.onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final hasQuery = widget.controller.text.trim().isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 860;
        final titleStyle = isWide
            ? theme.textTheme.headlineSmall
            : theme.textTheme.titleLarge;

        return Container(
          padding: EdgeInsets.all(isWide ? 20 : 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(isWide ? 24 : 20),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                children: [
                  SearchActionButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          context.localization.searchSongs,
                          style: titleStyle?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          context.localization.searchHeroSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.58,
                            ),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 12),
                    SearchCountBadge(
                      label: hasQuery
                          ? context.localization.searchMatchesLabel
                          : context.localization.searchLibraryLabel,
                      value: hasQuery ? widget.resultCount : widget.totalSongs,
                    ),
                  ],
                ],
              ),
              SearchSearchField(
                controller: widget.controller,
                isListening: _speechToText.isListening,
                onChanged: widget.onQueryChanged,
                onSubmitted: widget.onSearchSubmitted,
                onClear: _clearQuery,
                onVoiceTap: _speechToText.isListening
                    ? _stopListening
                    : _initAndStartListening,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SearchInfoBadge(
                    icon: Icons.graphic_eq_rounded,
                    label: hasQuery
                        ? context.localization.searchResultsCount(
                            widget.resultCount,
                          )
                        : context.localization.searchSongsReadyCount(
                            widget.totalSongs,
                          ),
                  ),
                  SearchInfoBadge(
                    icon: hasQuery ? Icons.tune_rounded : Icons.search_rounded,
                    label: hasQuery
                        ? widget.controller.text.trim()
                        : context.localization.searchInstantSearch,
                    isAccent: hasQuery,
                  ),
                ],
              ),
              if (widget.suggestions.isNotEmpty) ...[
                Text(
                  widget.suggestionsLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.suggestions
                      .map(
                        (suggestion) => ActionChip(
                          label: Text(suggestion),
                          onPressed: () => widget.onSuggestionSelected(
                            suggestion,
                          ),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: theme.colorScheme.surface,
                          side: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.08,
                            ),
                          ),
                          labelStyle: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.78,
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
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _speechToText
      ..stop()
      ..cancel();
    super.dispose();
  }
}
