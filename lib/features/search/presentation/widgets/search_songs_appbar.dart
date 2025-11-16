import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchSongsAppbar extends StatefulWidget implements PreferredSizeWidget {
  const SearchSongsAppbar({required this.searchStream, super.key});

  final StreamController<String> searchStream;

  @override
  State<SearchSongsAppbar> createState() => _SearchSongsAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchSongsAppbarState extends State<SearchSongsAppbar> {
  final TextEditingController _controller = TextEditingController();

  late stt.SpeechToText _speechToText;
  bool _speechEnabled = false;
  String _recognizedWords = '';

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _initAndStartListening() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (val) {
        if (mounted) setState(() {});
      },
      onError: (val) {
        if (mounted) setState(() {});
      },
    );

    if (!_speechEnabled) return;

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

    if (mounted) setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    if (mounted) setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;

    setState(() {
      _recognizedWords = result.recognizedWords;
      _controller.text = _recognizedWords;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );

      widget.searchStream.add(_recognizedWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
              size: 28,
            ),
          ),
          Expanded(
            child: Container(
              height: 49,
              //  kToolbarHeight * 0.6,
              padding: EdgeInsets.only(
                left: _controller.text.isNotEmpty ? 12 : 0,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  prefixIcon: _controller.text.isNotEmpty
                      ? null
                      : _buildMicButton(isDark),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark ? Colors.white : Colors.black,
                            size: 24,
                          ),
                          onPressed: () {
                            _controller.clear();
                            widget.searchStream.add('');
                          },
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.clear();
                            widget.searchStream.add('');
                          },
                          child: Image.asset(
                            ImageAssets.search,
                            color: isDark ? Colors.white : Colors.black,
                            height: 24,
                            width: 24,
                          ),
                        ),
                ),
                onChanged: widget.searchStream.add,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton(bool isDark) {
    final listening = _speechToText.isListening;
    return IconButton(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: listening
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.6),
                    spreadRadius: 4,
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Icon(
          listening ? Icons.mic : Icons.mic,
          color: (listening
              ? Colors.red
              : isDark
              ? Colors.white
              : Colors.black),
          size: 24,
        ),
      ),
      onPressed: (listening ? _stopListening : _initAndStartListening),
      tooltip: (listening ? 'Stop listening' : 'Listen'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _speechToText
      ..stop()
      ..cancel();
    super.dispose();
  }
}
