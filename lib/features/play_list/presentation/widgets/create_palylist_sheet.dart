import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/features/play_list/presentation/bloc/play_list_bloc.dart';

class CreatePalylistSheet extends StatelessWidget {
  const CreatePalylistSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: const CreatePalylistSheet._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text(
            'Create New Playlist',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Playlist Name',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) return;
              context.read<PlayListBloc>().add(
                AddPlayListEvent(PlaylistModel(name: textController.text)),
              );
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            child: Text('Create Playlist'),
          ),
        ],
      ),
    );
  }
}
