import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/features/playlist/data/datasources/playlist_datasource.dart';
import 'package:music_player/features/playlist/data/models/pin_playlist_model.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOnAudioQuery extends Mock implements OnAudioQuery {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late PlaylistDatasourceImpl datasource;
  late MockOnAudioQuery mockAudioQuery;
  late MockSharedPreferences mockPreferences;

  setUp(() {
    mockAudioQuery = MockOnAudioQuery();
    mockPreferences = MockSharedPreferences();
    datasource = PlaylistDatasourceImpl(mockAudioQuery, mockPreferences);
  });

  group('PlaylistDatasource', () {
    const tPlaylistId = 1;
    final tPlaylistModel = PlaylistModel({
      '_id': tPlaylistId,
      'name': 'Test Playlist',
      'date_added': 123456789,
      'date_modified': 123456789,
      'number_of_tracks': 10,
    });
    final tSongModel = SongModel({
      '_id': 100,
      '_display_name': 'Test Song',
      'artist': 'Test Artist',
      'album': 'Test Album',
      'duration': 1000,
      '_data': '/path/to/song',
    });

    group('getAllPlaylists', () {
      test('should return list of PlaylistModel', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryPlaylists(),
        ).thenAnswer((_) async => [tPlaylistModel]);

        // Act
        final result = await datasource.getAllPlaylists();

        // Assert
        expect(result, [tPlaylistModel]);
        verify(() => mockAudioQuery.queryPlaylists()).called(1);
      });
    });

    group('getPlaylistById', () {
      test('should return playlist with matching id', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryPlaylists(),
        ).thenAnswer((_) async => [tPlaylistModel]);

        // Act
        final result = await datasource.getPlaylistById(tPlaylistId);

        // Assert
        expect(result, tPlaylistModel);
      });
    });

    group('createPlaylist', () {
      test('should call createPlaylist on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.createPlaylist(any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.createPlaylist('New Playlist');

        // Assert
        verify(() => mockAudioQuery.createPlaylist('New Playlist')).called(1);
      });
    });

    group('deletePlaylist', () {
      test('should call removePlaylist on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.removePlaylist(any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.deletePlaylist(tPlaylistId);

        // Assert
        verify(() => mockAudioQuery.removePlaylist(tPlaylistId)).called(1);
      });
    });

    group('getPlaylistSongs', () {
      test('should call queryAudiosFrom on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryAudiosFrom(
            AudiosFromType.PLAYLIST,
            any(),
          ),
        ).thenAnswer((_) async => [tSongModel]);

        // Act
        final result = await datasource.getPlaylistSongs(tPlaylistId);

        // Assert
        expect(result, [tSongModel]);
        verify(
          () => mockAudioQuery.queryAudiosFrom(
            AudiosFromType.PLAYLIST,
            tPlaylistId,
          ),
        ).called(1);
      });
    });

    group('addSongsToPlaylist', () {
      test('should call addToPlaylist for each song id', () async {
        // Arrange
        when(
          () => mockAudioQuery.addToPlaylist(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.addSongsToPlaylist(tPlaylistId, [1, 2]);

        // Assert
        verify(() => mockAudioQuery.addToPlaylist(tPlaylistId, 1)).called(1);
        verify(() => mockAudioQuery.addToPlaylist(tPlaylistId, 2)).called(1);
      });
    });

    group('removeSongsFromPlaylist', () {
      test('should call removeFromPlaylist for each song id', () async {
        // Arrange
        when(
          () => mockAudioQuery.removeFromPlaylist(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.removeSongsFromPlaylist(tPlaylistId, [1, 2]);

        // Assert
        verify(
          () => mockAudioQuery.removeFromPlaylist(tPlaylistId, 1),
        ).called(1);
        verify(
          () => mockAudioQuery.removeFromPlaylist(tPlaylistId, 2),
        ).called(1);
      });
    });

    group('renamePlaylist', () {
      test('should call renamePlaylist on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.renamePlaylist(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.renamePlaylist(tPlaylistId, 'New Name');

        // Assert
        verify(
          () => mockAudioQuery.renamePlaylist(tPlaylistId, 'New Name'),
        ).called(1);
      });
    });

    group('getLatestSongIdFromPlaylist', () {
      test('should return last song id if playlist is not empty', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryAudiosFrom(
            AudiosFromType.PLAYLIST,
            any(),
          ),
        ).thenAnswer((_) async => [tSongModel]);

        // Act
        final result = await datasource.getLatestSongIdFromPlaylist(
          tPlaylistId,
        );

        // Assert
        expect(result, tSongModel.id);
      });

      test('should return null if playlist is empty', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryAudiosFrom(
            AudiosFromType.PLAYLIST,
            any(),
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await datasource.getLatestSongIdFromPlaylist(
          tPlaylistId,
        );

        // Assert
        expect(result, null);
      });
    });

    group('Initialization and Covers', () {
      test('getPlaylistCoverSongId should return id from prefs', () async {
        // Arrange
        when(
          () => mockPreferences.getString(PreferencesKeys.playlistCoverSongsId),
        ).thenReturn(jsonEncode({tPlaylistId.toString(): 100}));

        // Act
        final result = await datasource.getPlaylistCoverSongId(tPlaylistId);

        // Assert
        expect(result, 100);
      });

      test('setPlaylistCoverSongId should save id to prefs', () async {
        // Arrange
        when(
          () => mockPreferences.getString(PreferencesKeys.playlistCoverSongsId),
        ).thenReturn(null);
        when(
          () => mockPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.setPlaylistCoverSongId(tPlaylistId, 100);

        // Assert
        verify(
          () => mockPreferences.setString(
            PreferencesKeys.playlistCoverSongsId,
            jsonEncode({tPlaylistId.toString(): 100}),
          ),
        ).called(1);
      });

      test(
        'initializePlaylistCoversForExistingPlaylists should set cover '
        'if missing',
        () async {
          // Arrange
          when(
            () => mockAudioQuery.queryPlaylists(),
          ).thenAnswer((_) async => [tPlaylistModel]);
          when(
            () =>
                mockPreferences.getString(PreferencesKeys.playlistCoverSongsId),
          ).thenReturn(null);
          // Mock getLatestSongIdFromPlaylist internals
          when(
            () => mockAudioQuery.queryAudiosFrom(
              AudiosFromType.PLAYLIST,
              tPlaylistId,
            ),
          ).thenAnswer((_) async => [tSongModel]);
          when(
            () => mockPreferences.setString(any(), any()),
          ).thenAnswer((_) async => true);

          // Act
          await datasource.initializePlaylistCoversForExistingPlaylists();

          // Assert
          verify(
            () => mockPreferences.setString(
              PreferencesKeys.playlistCoverSongsId,
              any(),
            ),
          ).called(1);
        },
      );
    });

    group('Pinned Playlists', () {
      const tPinPlaylistModel = PinPlaylistModel(
        playlistId: tPlaylistId,
        order: 1,
      );

      test('getPinnedPlaylists should return list from prefs', () async {
        // Arrange
        when(
          () => mockPreferences.getStringList(PreferencesKeys.pinnedPlaylists),
        ).thenReturn([jsonEncode(tPinPlaylistModel.toJson())]);

        // Act
        final result = await datasource.getPinnedPlaylists();

        // Assert
        expect(result.length, 1);
        expect(result.first.playlistId, tPlaylistId);
      });

      test('savePinnedPlaylists should save list to prefs', () async {
        // Arrange
        when(
          () => mockPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.savePinnedPlaylists([tPinPlaylistModel]);

        // Assert
        verify(
          () => mockPreferences.setStringList(
            PreferencesKeys.pinnedPlaylists,
            any(),
          ),
        ).called(1);
      });
    });

    group('getRecentPlayedSongs', () {
      test(
        'should return songs filtered and sorted by recent history',
        () async {
          // Arrange
          when(
            () => mockPreferences.getStringList(
              PreferencesKeys.recentlyPlayedSongIds,
            ),
          ).thenReturn(['100', '101']);

          final song1 = tSongModel;
          final song2 = SongModel({
            '_id': 101,
            '_display_name': 'Song 2',
            'artist': 'Artist 2',
            'album': 'Album 2',
            'duration': 2000,
            '_data': '/path/2',
          });

          when(
            () => mockAudioQuery.querySongs(),
          ).thenAnswer((_) async => [song2, song1]);

          // Act
          final result = await datasource.getRecentPlayedSongs();

          // Assert
          expect(result.length, 2);
          expect(result[0].id, 100); // First in recent list
          expect(result[1].id, 101); // Second in recent list
        },
      );
    });
  });
}
