import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:music_player/features/music_plyer/data/datasources/audio_handler_datasource.dart';
import 'package:music_player/features/music_plyer/data/mapppers/mappers.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockMAudioHandler extends Mock implements MAudioHandler {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AudioHandlerDatasourceImpl datasource;
  late MockMAudioHandler mockAudioHandler;
  late MockSharedPreferences mockPreferences;

  setUp(() {
    registerFallbackValue(LoopMode.off);
    mockAudioHandler = MockMAudioHandler();
    mockPreferences = MockSharedPreferences();
    datasource = AudioHandlerDatasourceImpl(
      audioHandler: mockAudioHandler,
      preferences: mockPreferences,
    );
  });

  group('AudioHandlerDatasource', () {
    const tIndex = 0;
    const tPosition = Duration(seconds: 10);
    final tSongModel = SongModel({
      '_id': 1,
      '_display_name': 'Test Song',
      'artist': 'Test Artist',
      'album': 'Test Album',
      'duration': 1000,
      '_data': '/path/to/song',
    });

    group('play', () {
      test(
        'should call addAudioSources, seek and play on audioHandler',
        () async {
          // Arrange
          when(
            () => mockAudioHandler.addAudioSources(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockAudioHandler.seek(
              Duration.zero,
              index: any(named: 'index'),
            ),
          ).thenAnswer((_) async {});
          when(() => mockAudioHandler.play()).thenAnswer((_) async {});

          // Act
          await datasource.play([tSongModel], tIndex);

          // Assert
          verify(
            () => mockAudioHandler.addAudioSources([tSongModel]),
          ).called(1);
          verify(
            () => mockAudioHandler.seek(Duration.zero, index: tIndex),
          ).called(1);
          verify(() => mockAudioHandler.play()).called(1);
        },
      );

      test('should prepare queue without auto playing when disabled', () async {
        // Arrange
        when(
          () => mockAudioHandler.addAudioSources(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockAudioHandler.seek(
            Duration.zero,
            index: any(named: 'index'),
          ),
        ).thenAnswer((_) async {});

        // Act
        await datasource.play([tSongModel], tIndex, autoPlay: false);

        // Assert
        verify(() => mockAudioHandler.addAudioSources([tSongModel])).called(1);
        verify(
          () => mockAudioHandler.seek(Duration.zero, index: tIndex),
        ).called(1);
        verifyNever(() => mockAudioHandler.play());
      });
    });

    group('pause', () {
      test('should call pause on audioHandler', () async {
        // Arrange
        when(() => mockAudioHandler.pause()).thenAnswer((_) async {});

        // Act
        await datasource.pause();

        // Assert
        verify(() => mockAudioHandler.pause()).called(1);
      });
    });

    group('resume', () {
      test('should call play on audioHandler', () async {
        // Arrange
        when(() => mockAudioHandler.play()).thenAnswer((_) async {});

        // Act
        await datasource.resume();

        // Assert
        verify(() => mockAudioHandler.play()).called(1);
      });
    });

    group('seek', () {
      test('should call seek on audioHandler', () async {
        // Arrange
        when(
          () => mockAudioHandler.seek(tPosition, index: any(named: 'index')),
        ).thenAnswer((_) async {});

        // Act
        await datasource.seek(tPosition, index: tIndex);

        // Assert
        verify(() => mockAudioHandler.seek(tPosition, index: tIndex)).called(1);
      });
    });

    group('stop', () {
      test('should call stop on audioHandler', () async {
        // Arrange
        when(() => mockAudioHandler.stop()).thenAnswer((_) async {});

        // Act
        await datasource.stop();

        // Assert
        verify(() => mockAudioHandler.stop()).called(1);
      });
    });

    group('setShuffleMode', () {
      test('should call setShuffleModeEnabled on audioHandler', () async {
        // Arrange
        when(
          () => mockAudioHandler.setShuffleModeEnabled(
            enabled: any(named: 'enabled'),
          ),
        ).thenAnswer((_) async {});

        // Act
        await datasource.setShuffleMode(isEnabled: true);

        // Assert
        verify(
          () => mockAudioHandler.setShuffleModeEnabled(enabled: true),
        ).called(1);
      });
    });

    group('hasNext / hasPrevious', () {
      test('should return hasNext from audioHandler', () {
        // Arrange
        when(() => mockAudioHandler.hasNext).thenReturn(true);

        // Act
        final result = datasource.hasNext();

        // Assert
        expect(result, true);
        verify(() => mockAudioHandler.hasNext).called(1);
      });

      test('should return hasPrevious from audioHandler', () {
        // Arrange
        when(() => mockAudioHandler.hasPrevious).thenReturn(true);

        // Act
        final result = datasource.hasPrevious();

        // Assert
        expect(result, true);
        verify(() => mockAudioHandler.hasPrevious).called(1);
      });
    });

    group('streams', () {
      test('should return current index stream', () {
        // Arrange
        when(
          () => mockAudioHandler.currentIndexStream,
        ).thenAnswer((_) => Stream.value(1));

        // Act
        final result = datasource.currentIndexStream();

        // Assert
        expect(result, emits(1));
      });

      test('should return duration stream', () {
        // Arrange
        const duration = Duration(seconds: 100);
        when(
          () => mockAudioHandler.durationStream,
        ).thenAnswer((_) => Stream.value(duration));

        // Act
        final result = datasource.durationStream();

        // Assert
        expect(result, emits(duration));
      });

      test('should return position stream', () {
        // Arrange
        const position = Duration(seconds: 10);
        when(
          () => mockAudioHandler.positionStream,
        ).thenAnswer((_) => Stream.value(position));

        // Act
        final result = datasource.positionStream();

        // Assert
        expect(result, emits(position));
      });
    });

    group('setPlayerLoopMode', () {
      test('should set loop mode on audioHandler', () {
        // Arrange
        when(() => mockAudioHandler.setLoopMode(any())).thenReturn(null);

        // Act
        final result = datasource.setPlayerLoopMode(PlayerLoopMode.all);

        // Assert
        expect(result, PlayerLoopMode.all);
        verify(
          () => mockAudioHandler.setLoopMode(
            PlayerLoopModeMapper.mapToLoopMode(PlayerLoopMode.all),
          ),
        ).called(1);
      });
    });

    group('addToRecentlyPlayed', () {
      test('should add song id to recently played list', () async {
        // Arrange
        when(
          () => mockPreferences.getStringList(
            PreferencesKeys.recentlyPlayedSongIds,
          ),
        ).thenReturn([]);
        when(
          () => mockPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.addToRecentlyPlayed(1);

        // Assert
        verify(
          () => mockPreferences.getStringList(
            PreferencesKeys.recentlyPlayedSongIds,
          ),
        ).called(1);
        verify(
          () => mockPreferences.setStringList(
            PreferencesKeys.recentlyPlayedSongIds,
            ['1'],
          ),
        ).called(1);
      });

      test('should limit recently played list to 50', () async {
        // Arrange
        final list = List.generate(50, (index) => index.toString());
        when(
          () => mockPreferences.getStringList(
            PreferencesKeys.recentlyPlayedSongIds,
          ),
        ).thenReturn(list);
        when(
          () => mockPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.addToRecentlyPlayed(100);

        // Assert
        verify(
          () => mockPreferences.getStringList(
            PreferencesKeys.recentlyPlayedSongIds,
          ),
        ).called(1);
        final captured = verify(
          () => mockPreferences.setStringList(
            PreferencesKeys.recentlyPlayedSongIds,
            captureAny(),
          ),
        ).captured.first as List<String>;
        expect(captured.length, 50);
        expect(captured.first, '100');
      });
    });

    group('playback session', () {
      test('should save playback queue metadata', () async {
        // Arrange
        when(
          () => mockPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockPreferences.setInt(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockPreferences.setBool(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await datasource.savePlaybackSession(
          [tSongModel],
          tIndex,
          wasPlaying: false,
        );

        // Assert
        expect(result, isTrue);
        verify(
          () => mockPreferences.setStringList(
            PreferencesKeys.playbackQueueSongIds,
            ['1'],
          ),
        ).called(1);
        verify(
          () => mockPreferences.setInt(
            PreferencesKeys.playbackCurrentIndex,
            tIndex,
          ),
        ).called(1);
        verify(
          () => mockPreferences.setBool(
            PreferencesKeys.playbackWasPlaying,
            false,
          ),
        ).called(1);
      });

      test('should return saved playback session when data is valid', () {
        // Arrange
        when(
          () => mockPreferences.getStringList(
            PreferencesKeys.playbackQueueSongIds,
          ),
        ).thenReturn(['1', '2']);
        when(
          () => mockPreferences.getInt(PreferencesKeys.playbackCurrentIndex),
        ).thenReturn(1);
        when(
          () => mockPreferences.getBool(PreferencesKeys.playbackWasPlaying),
        ).thenReturn(true);

        // Act
        final result = datasource.getSavedPlaybackSession();

        // Assert
        expect(
          result,
          const PlaybackSession(
            playlistSongIds: [1, 2],
            currentSongIndex: 1,
            wasPlaying: true,
          ),
        );
      });

      test('should return null when saved playback session is invalid', () {
        // Arrange
        when(
          () => mockPreferences.getStringList(
            PreferencesKeys.playbackQueueSongIds,
          ),
        ).thenReturn(['1']);
        when(
          () => mockPreferences.getInt(PreferencesKeys.playbackCurrentIndex),
        ).thenReturn(5);

        // Act
        final result = datasource.getSavedPlaybackSession();

        // Assert
        expect(result, isNull);
      });

      test('should clear saved playback session keys', () async {
        // Arrange
        when(() => mockPreferences.remove(any())).thenAnswer((_) async => true);

        // Act
        final result = await datasource.clearSavedPlaybackSession();

        // Assert
        expect(result, isTrue);
        verify(
          () => mockPreferences.remove(PreferencesKeys.playbackQueueSongIds),
        ).called(1);
        verify(
          () => mockPreferences.remove(PreferencesKeys.playbackCurrentIndex),
        ).called(1);
        verify(
          () => mockPreferences.remove(PreferencesKeys.playbackWasPlaying),
        ).called(1);
      });
    });
  });
}
