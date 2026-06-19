import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/usecases/query_folders.dart';
import 'package:music_player/features/songs/presentation/bloc/folders_bloc.dart';

class MockQueryFolders extends Mock implements QueryFolders {}

void main() {
  late FoldersBloc foldersBloc;
  late MockQueryFolders mockQueryFolders;

  const tFolders = [
    Folder(
      name: 'Rock',
      path: '/storage/music/Rock',
      songCount: 4,
    ),
    Folder(
      name: 'Jazz',
      path: '/storage/music/Jazz',
      songCount: 2,
    ),
  ];

  setUp(() {
    mockQueryFolders = MockQueryFolders();
    foldersBloc = FoldersBloc(mockQueryFolders);
  });

  tearDown(() async {
    await foldersBloc.close();
  });

  group('FoldersBloc', () {
    test('emits loading then loaded when folders are fetched', () async {
      when(() => mockQueryFolders()).thenAnswer(
        (_) async => Result.success(tFolders),
      );

      final expectedStates = <FoldersState>[
        const FoldersState(status: FoldersStatus.loading),
        const FoldersState(
          allFolders: tFolders,
          status: FoldersStatus.loaded,
        ),
      ];

      final expectation = expectLater(
        foldersBloc.stream,
        emitsInOrder(expectedStates),
      );

      foldersBloc.add(const LoadFoldersEvent());

      await expectation;
      verify(() => mockQueryFolders()).called(1);
    });

    test('emits loading then error when fetching folders fails', () async {
      when(() => mockQueryFolders()).thenAnswer(
        (_) async => Result.failure('failed to load folders'),
      );

      final expectation = expectLater(
        foldersBloc.stream,
        emitsInOrder([
          const FoldersState(status: FoldersStatus.loading),
          const FoldersState(
            status: FoldersStatus.error,
            errorMessage: 'failed to load folders',
          ),
        ]),
      );

      foldersBloc.add(const LoadFoldersEvent());

      await expectation;
      verify(() => mockQueryFolders()).called(1);
    });
  });
}
