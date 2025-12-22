import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to set a song/audio file as the device ringtone.
///
/// Uses platform channel to invoke native Android code for setting
/// the ringtone. Returns true if successful, false otherwise.
class RingtoneSet {
  RingtoneSet._();

  static Future<bool> setRingtone(String path) async {
    try {
      const channel = MethodChannel(
        'com.taleb.music_player/ringtone_set',
      );
      final result = await channel.invokeMethod('set_ringtone', {
        'filePath': path,
      });
      return result == true;
    } on Exception catch (e) {
      debugPrint('Error setting ringtone: $e');
      return false;
    }
  }
}
