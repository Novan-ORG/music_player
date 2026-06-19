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
  late final FocusNode _focusNode;
  bool _isValid = false;

  bool get _isEditing => widget.initialPlaylist != null;
  String get _trimmedName => _controller.text.trim();
  bool get _isChanged =>
      !_isEditing || _trimmedName != widget.initialPlaylist!.name.trim();
  bool get _canSubmit => _isValid && _isChanged;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialPlaylist?.name ?? '',
    );
    _focusNode = FocusNode();
    _isValid = _controller.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _isValid = value.trim().isNotEmpty;
    });
  }

  void _createOrUpdatePlaylist() {
    final name = _trimmedName;
    if (!_canSubmit || name.isEmpty) return;
    final bloc = context.read<PlayListBloc>();
    if (_isEditing) {
      final id = widget.initialPlaylist!.id;
      bloc.add(
        RenamePlayListEvent(id, name),
      );
    } else {
      bloc.add(
        CreatePlayListEvent(name),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    final title = _isEditing
        ? context.localization.renamePlaylist
        : context.localization.createNewPlaylist;
    final submitLabel = _isEditing
        ? context.localization.rename
        : context.localization.createPlaylist;
    final actionIcon = _isEditing
        ? Icons.edit_rounded
        : Icons.playlist_add_rounded;
    final previewName = _trimmedName.isEmpty
        ? context.localization.playlistName
        : _trimmedName;
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.14),
                    blurRadius: 34,
                    offset: const Offset(0, -12),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.22,
                                  ),
                                  const Color(
                                    0xFF00BFA6,
                                  ).withValues(alpha: 0.18),
                                ],
                              ),
                            ),
                            child: Icon(
                              actionIcon,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  previewName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(
                                          alpha: 0.6,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).closeButtonTooltip,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.04,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.06,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                autofocus: true,
                                maxLength: 40,
                                textInputAction: TextInputAction.done,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  labelText: context.localization.playlistName,
                                  hintText: context.localization.playlistName,
                                  counterText: '',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  prefixIcon: const Icon(
                                    Icons.queue_music_rounded,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.onSurface
                                          .withValues(
                                            alpha: 0.08,
                                          ),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primary,
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                                onChanged: _onChanged,
                                onSubmitted: (_) => _createOrUpdatePlaylist(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(context.localization.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              onPressed: _canSubmit
                                  ? _createOrUpdatePlaylist
                                  : null,
                              icon: Icon(
                                _isEditing
                                    ? Icons.check_rounded
                                    : Icons.playlist_add_rounded,
                                size: 20,
                              ),
                              label: Text(submitLabel),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                textStyle: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
