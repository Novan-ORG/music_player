import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';

part 'artists_event.dart';
part 'artists_state.dart';

class ArtistsBloc extends Bloc<ArtistsEvent, ArtistsState> {
  ArtistsBloc(
    this.queryArtists,
  ) : super(const ArtistsState()) {
    on<LoadArtistsEvent>(onLoadArtists);
  }

  final QueryArtists queryArtists;

  Future<void> onLoadArtists(
    LoadArtistsEvent event,
    Emitter<ArtistsState> emit,
  ) async {
    emit(const ArtistsState(status: ArtistsStatus.loading));
    final queryResult = await queryArtists(sortType: event.sortType);
    if (queryResult.isSuccess) {
      emit(
        ArtistsState(
          allArtists: queryResult.value!,
          status: ArtistsStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          status: ArtistsStatus.error,
        ),
      );
    }
  }
}
