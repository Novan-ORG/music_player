import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to set a song/audio file as the device ringtone.
///
/// Uses platform channel to invoke native Android code for setting
/// the ringtone. Returns true if successful, false otherwise.
class RingtoneSet {
  RingtoneSet._();

  static const MethodChannel _channel = MethodChannel(
    'com.taleb.music_player/ringtone_set',
  );

  static Future<bool> setRingtone(String path) async {
    try {
      final result = await _channel.invokeMethod<bool>('set_ringtone', {
        'filePath': path,
      });
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('Error setting ringtone: $e');
      return false;
    }
  }

  static Future<bool> canWriteSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>('can_write_settings');
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('Error checking write settings permission: $e');
      return false;
    }
  }

  static Future<bool> openWriteSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>('open_write_settings');
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('Error opening write settings permission screen: $e');
      return false;
    }
  }
}
