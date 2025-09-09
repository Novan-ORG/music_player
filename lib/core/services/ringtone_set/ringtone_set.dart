import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RingtoneSet {
  RingtoneSet._();

  static Future<bool> setRingtone(String path) async {
    try {
      MethodChannel channel = const MethodChannel(
        'com.taleb.music_player/ringtone_set',
      );
      final result = await channel.invokeMethod('set_ringtone', {
        'filePath': path,
      });
      return result == true;
    } catch (e) {
      debugPrint('Error setting ringtone: $e');
      return false;
    }
  }
}
