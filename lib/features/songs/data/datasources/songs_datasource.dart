import 'dart:io';

import 'package:music_player/core/data/mappers/mappers.dart';
import 'package:music_player/core/data/models/models.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' as aq;
import 'package:permission_handler/permission_handler.dart';

abstract interface class SongsDatasource {
  Future<List<SongModel>> querySongs();
  Future<bool> deleteSong(String songUri);
}

class SongsDatasourceImpl implements SongsDatasource {
  const SongsDatasourceImpl({required aq.OnAudioQuery onAudioQuery})
    : _onAudioQuery = onAudioQuery;

  final aq.OnAudioQuery _onAudioQuery;

  @override
  Future<bool> deleteSong(String songUri) async {
    final file = File(songUri);
    if (file.existsSync()) {
      if (await Permission.manageExternalStorage.isGranted) {
        await file.delete();
        return true;
      } else {
        final isGranted = await Permission.manageExternalStorage.request();
        if (isGranted == PermissionStatus.granted ||
            isGranted == PermissionStatus.limited) {
          await file.delete();
          return true;
        } else {
          return false;
        }
      }
    } else {
      throw FileSystemException('File not exist in the system', file.path);
    }
  }

  @override
  Future<List<SongModel>> querySongs() async {
    final permissionsGranted = await _onAudioQuery.checkAndRequest();
    if (!permissionsGranted) {
      throw Exception('Permission not granted!');
    }
    final result = await _onAudioQuery.querySongs();
    return result.map(SongModelMapper.fromAudioQueryModel).toList();
  }
}
