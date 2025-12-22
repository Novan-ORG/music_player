import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/features/songs/data/datasources/songs_datasource.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOnAudioQuery extends Mock implements OnAudioQuery {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SongsDatasourceImpl datasource;
  late MockOnAudioQuery mockAudioQuery;
  late MockSharedPreferences mockPreferences;

  setUp(() {
    registerFallbackValue(AudiosFromType.ALBUM_ID);
    registerFallbackValue(SongSortType.DATE_ADDED);
    registerFallbackValue(OrderType.DESC_OR_GREATER);
    mockAudioQuery = MockOnAudioQuery();
    mockPreferences = MockSharedPreferences();

    datasource = SongsDatasourceImpl(
      onAudioQuery: mockAudioQuery,
      preferences: mockPreferences,
    );
  });

  group('SongsDatasource', () {
    final tSongModel = SongModel({
      '_id': 1,
      '_display_name': 'Test Song',
      'artist': 'Test Artist',
      'album': 'Test Album',
      'duration': 1000,
      '_data': '/path/to/song',
    });
    final tAlbumModel = AlbumModel({
      '_id': 1,
      'album': 'Test Album',
      'artist': 'Test Artist',
      'numsongs': 10,
    });
    final tArtistModel = ArtistModel({
      '_id': 1,
      'artist': 'Test Artist',
      'number_of_albums': 2,
      'number_of_tracks': 10,
    });

    group('querySongs', () {
      test('should call querySongs on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.querySongs(
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
            ignoreCase: any(named: 'ignoreCase'),
            uriType: any(named: 'uriType'),
          ),
        ).thenAnswer((_) async => [tSongModel]);

        // Act
        final result = await datasource.querySongs();

        // Assert
        expect(result, [tSongModel]);
        verify(
          () => mockAudioQuery.querySongs(
            sortType: SongSortType.DATE_ADDED,
            orderType: OrderType.DESC_OR_GREATER,
          ),
        ).called(1);
      });
    });

    group('queryAlbums', () {
      test('should call queryAlbums on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryAlbums(
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
            ignoreCase: any(named: 'ignoreCase'),
            uriType: any(named: 'uriType'),
          ),
        ).thenAnswer((_) async => [tAlbumModel]);

        // Act
        final result = await datasource.queryAlbums();

        // Assert
        expect(result, [tAlbumModel]);
        verify(
          () => mockAudioQuery.queryAlbums(
            sortType: AlbumSortType.NUM_OF_SONGS,
            orderType: OrderType.DESC_OR_GREATER,
          ),
        ).called(1);
      });
    });

    group('queryArtists', () {
      test('should call queryArtists on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryArtists(
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
            ignoreCase: any(named: 'ignoreCase'),
            uriType: any(named: 'uriType'),
          ),
        ).thenAnswer((_) async => [tArtistModel]);

        // Act
        final result = await datasource.queryArtists();

        // Assert
        expect(result, [tArtistModel]);
        verify(
          () => mockAudioQuery.queryArtists(
            sortType: ArtistSortType.NUM_OF_TRACKS,
            orderType: OrderType.DESC_OR_GREATER,
          ),
        ).called(1);
      });
    });

    group('querySongsFrom', () {
      test('should call queryAudiosFrom on audioQuery', () async {
        // Arrange
        when(
          () => mockAudioQuery.queryAudiosFrom(
            any(),
            any(),
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
            ignoreCase: any(named: 'ignoreCase'),
          ),
        ).thenAnswer((_) async => [tSongModel]);

        // Act
        final result = await datasource.querySongsFrom(
          audiosFromTye: AudiosFromType.ALBUM_ID,
          where: 1,
        );

        // Assert
        expect(result, [tSongModel]);
        verify(
          () => mockAudioQuery.queryAudiosFrom(
            AudiosFromType.ALBUM_ID,
            1,
            sortType: SongSortType.DATE_ADDED,
          ),
        ).called(1);
      });
    });

    group('saveSongSortType', () {
      test('should save sort type index to prefs', () async {
        // Arrange
        when(
          () => mockPreferences.setInt(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await datasource.saveSongSortType(sortType: SongSortType.TITLE);

        // Assert
        verify(
          () => mockPreferences.setInt(
            PreferencesKeys.songSortType,
            SongSortType.TITLE.index,
          ),
        ).called(1);
      });
    });

    group('getSongSortType', () {
      test('should return Saved Sort Type from prefs', () {
        // Arrange
        when(
          () => mockPreferences.getInt(PreferencesKeys.songSortType),
        ).thenReturn(SongSortType.ARTIST.index);

        // Act
        final result = datasource.getSongSortType();

        // Assert
        expect(result, SongSortType.ARTIST);
      });

      test(
        'should return default sort type (DATE_ADDED) if no simple saved',
        () {
          // Arrange
          when(
            () => mockPreferences.getInt(PreferencesKeys.songSortType),
          ).thenReturn(null);

          // Act
          final result = datasource.getSongSortType();

          // Assert
          // The default in impl is 4 which corresponds to DATE_ADDED
          expect(result, SongSortType.DATE_ADDED);
        },
      );
    });
  });
}
