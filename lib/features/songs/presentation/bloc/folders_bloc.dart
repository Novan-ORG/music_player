import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';

part 'folders_event.dart';
part 'folders_state.dart';

class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  FoldersBloc(this.queryFolders) : super(const FoldersState()) {
    on<LoadFoldersEvent>(onLoadFolders);
  }

  final QueryFolders queryFolders;

  Future<void> onLoadFolders(
    LoadFoldersEvent event,
    Emitter<FoldersState> emit,
  ) async {
    emit(const FoldersState(status: FoldersStatus.loading));
    final queryResult = await queryFolders();
    if (queryResult.isSuccess) {
      emit(
        FoldersState(
          allFolders: queryResult.value!,
          status: FoldersStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          status: FoldersStatus.error,
        ),
      );
    }
  }
}
