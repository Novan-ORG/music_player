import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/features/songs/data/datasources/songs_datasource.dart';
import 'package:music_player/features/songs/data/repositories/songs_repo_impl.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/entities/sort_config.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class MockSongsDatasource extends Mock implements SongsDatasource {}

void main() {
  late SongsRepoImpl repository;
  late MockSongsDatasource mockSongsDatasource;

  SongModel createSongModel({
    required int id,
    required String title,
    required String path,
  }) {
    return SongModel({
      '_id': id,
      'title': title,
      '_display_name': '$title.mp3',
      '_display_name_wo_ext': title,
      'artist': 'Artist $id',
      'album': 'Album $id',
      '_data': path,
      'duration': 1000,
      'date_added': 1710000000 + id,
      '_size': 2048,
    });
  }

  setUpAll(() {
    registerFallbackValue(SongSortType.DATE_ADDED);
    registerFallbackValue(OrderType.DESC_OR_GREATER);
    registerFallbackValue(AlbumSortType.NUM_OF_SONGS);
    registerFallbackValue(ArtistSortType.NUM_OF_TRACKS);
    registerFallbackValue(AudiosFromType.ALBUM_ID);
  });

  setUp(() {
    mockSongsDatasource = MockSongsDatasource();
    repository = SongsRepoImpl(songsDatasource: mockSongsDatasource);
  });

  group('SongsRepoImpl.queryFolders', () {
    test(
      'groups songs by folder path and counts songs in each folder',
      () async {
        when(
          () => mockSongsDatasource.querySongs(
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
          ),
        ).thenAnswer(
          (_) async => [
            createSongModel(
              id: 1,
              title: 'One',
              path: '/storage/music/Rock/one.mp3',
            ),
            createSongModel(
              id: 2,
              title: 'Two',
              path: '/storage/music/Jazz/two.mp3',
            ),
            createSongModel(
              id: 3,
              title: 'Three',
              path: '/storage/music/Rock/three.mp3',
            ),
            createSongModel(
              id: 4,
              title: 'Four',
              path: '/storage/downloads/Rock/four.mp3',
            ),
          ],
        );

        final result = await repository.queryFolders();

        expect(result.isSuccess, isTrue);
        expect(result.value, hasLength(3));

        final folders = result.value!;
        expect(folders[0].name, 'Jazz');
        expect(folders[0].path, '/storage/music/Jazz');
        expect(folders[0].songCount, 1);

        expect(folders[1].name, 'Rock');
        expect(folders[1].path, '/storage/downloads/Rock');
        expect(folders[1].songCount, 1);

        expect(folders[2].name, 'Rock');
        expect(folders[2].path, '/storage/music/Rock');
        expect(folders[2].songCount, 2);

        verify(
          () => mockSongsDatasource.querySongs(
            sortType: SongSortType.TITLE,
            orderType: OrderType.ASC_OR_SMALLER,
          ),
        ).called(1);
      },
    );

    test('returns failure when datasource throws', () async {
      when(
        () => mockSongsDatasource.querySongs(
          sortType: any(named: 'sortType'),
          orderType: any(named: 'orderType'),
        ),
      ).thenThrow(Exception('boom'));

      final result = await repository.queryFolders();

      expect(result.isFailure, isTrue);
      expect(result.error, contains('Failed to load folders'));
    });
  });

  group('SongsRepoImpl.querySongsFrom', () {
    test('filters songs by exact folder path for folderPath queries', () async {
      when(
        () => mockSongsDatasource.querySongs(
          sortType: any(named: 'sortType'),
          orderType: any(named: 'orderType'),
        ),
      ).thenAnswer(
        (_) async => [
          createSongModel(
            id: 1,
            title: 'Alpha',
            path: '/storage/music/Rock/alpha.mp3',
          ),
          createSongModel(
            id: 2,
            title: 'Beta',
            path: '/storage/music/Rock/beta.mp3',
          ),
          createSongModel(
            id: 3,
            title: 'Gamma',
            path: '/storage/music/Jazz/gamma.mp3',
          ),
        ],
      );

      final result = await repository.querySongsFrom(
        fromType: SongsFromType.folderPath,
        where: '/storage/music/Rock',
        sortConfig: const SortConfig(
          sortType: SongsSortType.title,
          orderType: SortOrderType.ascOrSmaller,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(2));
      expect(
        result.value!.map((song) => song.title).toList(),
        ['Alpha', 'Beta'],
      );

      verify(
        () => mockSongsDatasource.querySongs(
          sortType: SongSortType.TITLE,
          orderType: OrderType.ASC_OR_SMALLER,
        ),
      ).called(1);
      verifyNever(
        () => mockSongsDatasource.querySongsFrom(
          audiosFromType: any(named: 'audiosFromType'),
          where: any(named: 'where'),
          sortType: any(named: 'sortType'),
          orderType: any(named: 'orderType'),
        ),
      );
    });
  });
}
