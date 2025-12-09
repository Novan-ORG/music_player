import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';

part 'albums_event.dart';
part 'albums_state.dart';

class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  AlbumsBloc(
    this.queryAlbums,
  ) : super(const AlbumsState()) {
    on<LoadAlbumsEvent>(onLoadAlbums);
  }

  final QueryAlbums queryAlbums;

  Future<void> onLoadAlbums(
    LoadAlbumsEvent event,
    Emitter<AlbumsState> emit,
  ) async {
    emit(const AlbumsState(status: AlbumsStatus.loading));
    final queryResult = await queryAlbums(sortType: event.sortType);
    if (queryResult.isSuccess) {
      emit(
        AlbumsState(allAlbums: queryResult.value!, status: AlbumsStatus.loaded),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          status: AlbumsStatus.error,
        ),
      );
    }
  }
}
