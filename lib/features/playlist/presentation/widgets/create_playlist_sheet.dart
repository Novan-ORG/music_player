import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';

class CreatePlaylistSheet extends StatefulWidget {
  const CreatePlaylistSheet._({this.initialPlaylist});
  final Playlist? initialPlaylist;

  /// Show sheet for creating a new playlist
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatePlaylistSheet._(),
    );
  }

  /// Show sheet for editing an existing playlist
  static Future<void> showEdit(BuildContext context, Playlist playlist) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreatePlaylistSheet._(initialPlaylist: playlist),
    );
  }

  @override
  State<CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<CreatePlaylistSheet> {
  late final TextEditingController _controller;
  bool _isValid = false;

  bool get _isEditing => widget.initialPlaylist != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialPlaylist?.name ?? '',
    );
    _isValid = _controller.text.trim().isNotEmpty;
  }

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

  void _createOrUpdatePlaylist() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final bloc = context.read<PlayListBloc>();
    if (_isEditing) {
      // Update existing playlist (keep the same id)
      final id = widget.initialPlaylist!.id;
      bloc.add(
        RenamePlayListEvent(id, name),
      );
    } else {
      // Add new playlist
      bloc.add(
        CreatePlayListEvent(name),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final title = _isEditing
        ? context.localization.renamePlaylist
        : context.localization.createNewPlaylist;
    final actionIcon = _isEditing ? Icons.edit : Icons.add;

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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.white30 : Colors.white60,
                ),
                BoxShadow(
                  color: theme.colorScheme.surface,
                  spreadRadius: -3,
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: context.localization.playlistName,
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 16,
                            ),
                          ),
                          onChanged: _onChanged,
                          autofocus: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        if (_isValid) {
                          _createOrUpdatePlaylist();
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Icon(actionIcon, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
