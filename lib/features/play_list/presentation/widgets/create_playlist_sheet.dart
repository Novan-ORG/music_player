import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/database/database.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/play_list/presentation/bloc/bloc.dart';

class CreatePlaylistSheet extends StatefulWidget {
  const CreatePlaylistSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatePlaylistSheet._(),
    );
  }

  @override
  State<CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<CreatePlaylistSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _isValid = value.trim().isNotEmpty;
    });
  }

  void _createPlaylist() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final bloc = context.read<PlayListBloc>();
    bloc.add(
      AddPlayListEvent(
        PlaylistModel(id: bloc.state.playLists.length + 1, name: name),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.35,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  context.localization.createNewPlaylist,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.localization.playlistName,
                    prefixIcon: const Icon(Icons.playlist_add),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedOpacity(
                  opacity: _isValid ? 1 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton.icon(
                    onPressed: _isValid ? _createPlaylist : null,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(context.localization.createPlaylist),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
