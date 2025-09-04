import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:music_player/core/services/database/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void setup() {
  //
  getIt.registerSingletonAsync(() => ObjectBox.create());
  //
  getIt.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  getIt.registerSingletonAsync<MAudioHandler>(
    () => AudioService.init(
      builder: () => MAudioHandler(getIt.get<AudioPlayer>()),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.example.music_palyer.channel.audio',
        androidNotificationChannelName: 'Music Player',
        androidNotificationOngoing: true,
      ),
    ),
  );

  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
}
