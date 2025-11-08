import 'dart:async';
import 'package:flutter/material.dart';
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
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _initSpeech();

    _controller.addListener(() => setState(() {}));
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) return;

    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _controller.text = _lastWords;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      widget.searchStream.add(_lastWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        height: kToolbarHeight * 0.6,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search songs...',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      widget.searchStream.add('');
                    },
                  )
                : _buildMicButton(),
          ),
          onChanged: widget.searchStream.add,
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return IconButton(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: _speechToText.isListening
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.6),
                    spreadRadius: 4,
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Icon(
          _speechToText.isListening ? Icons.mic : Icons.mic,
          color: _speechToText.isListening ? Colors.red : Colors.black,
        ),
      ),
      onPressed: _speechToText.isListening ? _stopListening : _startListening,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _speechToText.stop();
    super.dispose();
  }
}
