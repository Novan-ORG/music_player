import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/features/favorite/data/datasources/favorite_songs_datasource.dart';
import 'package:music_player/features/favorite/data/models/models.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockOnAudioQuery extends Mock implements OnAudioQuery {}

void main() {
  late FavoriteSongsDatasourceImpl datasource;
  late MockSharedPreferences mockPreferences;
  late MockOnAudioQuery mockAudioQuery;

  setUp(() {
    mockPreferences = MockSharedPreferences();
    mockAudioQuery = MockOnAudioQuery();
    datasource = FavoriteSongsDatasourceImpl(
      preferences: mockPreferences,
      audioQuery: mockAudioQuery,
    );
  });

  group('FavoriteSongsDatasource', () {
    const tSongId = 123;
    final tSongModel = SongModel(
      {
        '_id': tSongId,
        '_display_name': 'Test Song',
        'artist': 'Test Artist',
        'album': 'Test Album',
        'duration': 1000,
        '_data': '/path/to/song',
      },
    );
    final tFavoriteSongModel = FavoriteSongModel(
      id: 1,
      songId: tSongId,
      dateAdded: DateTime.now(),
    );

    group('getFavoriteSongs', () {
      test(
        'should return list of SongModel when songs exist in favorites',
        () async {
          // Arrange
          final jsonString = jsonEncode(tFavoriteSongModel.toJson());
          when(
            () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
          ).thenReturn([jsonString]);
          when(
            () => mockAudioQuery.querySongs(),
          ).thenAnswer((_) async => [tSongModel]);

          // Act
          final result = await datasource.getFavoriteSongs();

          // Assert
          expect(result, isA<List<SongModel>>());
          expect(result.length, 1);
          expect(result.first.id, tSongId);
          verify(
            () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
          ).called(1);
          verify(() => mockAudioQuery.querySongs()).called(1);
        },
      );

      test('should return empty list when no favorites exist', () async {
        // Arrange
        when(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).thenReturn([]);
        when(
          () => mockAudioQuery.querySongs(),
        ).thenAnswer((_) async => [tSongModel]);

        // Act
        final result = await datasource.getFavoriteSongs();

        // Assert
        expect(result, isEmpty);
        verify(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).called(1);
      });
    });

    group('addFavoriteSong', () {
      test('should add song to favorites when it does not exist', () async {
        // Arrange
        when(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).thenReturn([]);
        when(
          () => mockPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.addFavoriteSong(tSongId);

        // Assert
        verify(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).called(1);
        verify(
          () => mockPreferences.setStringList(
            PreferencesKeys.favoriteSongs,
            any(),
          ),
        ).called(1);
      });

      test('should not add song if already exists', () async {
        // Arrange
        final jsonString = jsonEncode(tFavoriteSongModel.toJson());
        when(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).thenReturn([jsonString]);

        // Act
        await datasource.addFavoriteSong(tSongId);

        // Assert
        verify(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).called(1);
        verifyNever(() => mockPreferences.setStringList(any(), any()));
      });
    });

    group('removeFavoriteSong', () {
      test('should remove song from favorites', () async {
        // Arrange
        final jsonString = jsonEncode(tFavoriteSongModel.toJson());
        when(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).thenReturn([jsonString]);
        when(
          () => mockPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.removeFavoriteSong(tSongId);

        // Assert
        verify(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).called(1);
        verify(
          () => mockPreferences.setStringList(
            PreferencesKeys.favoriteSongs,
            any(),
          ),
        ).called(1);
      });
    });

    group('isFavorite', () {
      test('should return true if song is in favorites', () {
        // Arrange
        final jsonString = jsonEncode(tFavoriteSongModel.toJson());
        when(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).thenReturn([jsonString]);

        // Act
        final result = datasource.isFavorite(tSongId);

        // Assert
        expect(result, true);
      });

      test('should return false if song is not in favorites', () {
        // Arrange
        when(
          () => mockPreferences.getStringList(PreferencesKeys.favoriteSongs),
        ).thenReturn([]);

        // Act
        final result = datasource.isFavorite(tSongId);

        // Assert
        expect(result, false);
      });
    });

    group('clearAllFavorites', () {
      test('should remove all favorites from storage', () async {
        // Arrange
        when(
          () => mockPreferences.remove(PreferencesKeys.favoriteSongs),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.clearAllFavorites();

        // Assert
        verify(
          () => mockPreferences.remove(PreferencesKeys.favoriteSongs),
        ).called(1);
      });
    });
  });
}
