import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/favorite/domain/domain.dart';

part 'favorite_songs_event.dart';
part 'favorite_songs_state.dart';

class FavoriteSongsBloc extends Bloc<FavoriteSongsEvent, FavoriteSongsState> {
  FavoriteSongsBloc({
    required this.getFavoriteSongs,
    required this.addFavoriteSong,
    required this.removeFavoriteSong,
    required this.toggleFavoriteSong,
    required this.clearAllFavorites,
  }) : super(const FavoriteSongsState()) {
    on<LoadFavoriteSongsEvent>(_onLoadFavoriteSongs);
    on<AddFavoriteSongEvent>(_onAddFavoriteSong);
    on<RemoveFavoriteSongEvent>(_onRemoveFavoriteSong);
    on<ToggleFavoriteSongEvent>(_onToggleFavoriteSong);
    on<ClearAllFavoritesEvent>(_onClearAllFavorites);
  }

  final GetFavoriteSongs getFavoriteSongs;
  final AddFavoriteSong addFavoriteSong;
  final RemoveFavoriteSong removeFavoriteSong;
  final ToggleFavoriteSong toggleFavoriteSong;
  final ClearAllFavorites clearAllFavorites;

  Future<void> _onLoadFavoriteSongs(
    LoadFavoriteSongsEvent event,
    Emitter<FavoriteSongsState> emit,
  ) async {
    emit(state.copyWith(status: FavoriteSongsStatus.loading));

    final result = await getFavoriteSongs();
    if (result.isSuccess) {
      emit(
        state.copyWith(
          favoriteSongs: result.value,
          status: FavoriteSongsStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FavoriteSongsStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  Future<void> _onAddFavoriteSong(
    AddFavoriteSongEvent event,
    Emitter<FavoriteSongsState> emit,
  ) async {
    final result = await addFavoriteSong(event.songId);
    if (result.isSuccess) {
      // Reload favorites to get updated list
      add(const LoadFavoriteSongsEvent());
    } else {
      emit(
        state.copyWith(
          status: FavoriteSongsStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  Future<void> _onRemoveFavoriteSong(
    RemoveFavoriteSongEvent event,
    Emitter<FavoriteSongsState> emit,
  ) async {
    final result = await removeFavoriteSong(event.songId);
    if (result.isSuccess) {
      // Reload favorites to get updated list
      add(const LoadFavoriteSongsEvent());
    } else {
      emit(
        state.copyWith(
          status: FavoriteSongsStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  Future<void> _onToggleFavoriteSong(
    ToggleFavoriteSongEvent event,
    Emitter<FavoriteSongsState> emit,
  ) async {
    final result = await toggleFavoriteSong(event.songId);
    if (result.isSuccess) {
      // Reload favorites to get updated list
      add(const LoadFavoriteSongsEvent());
    } else {
      emit(
        state.copyWith(
          status: FavoriteSongsStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  void _onClearAllFavorites(
    ClearAllFavoritesEvent event,
    Emitter<FavoriteSongsState> emit,
  ) {
    final result = clearAllFavorites();
    if (result.isSuccess) {
      emit(
        state.copyWith(
          favoriteSongs: [],
          status: FavoriteSongsStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FavoriteSongsStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }
}
