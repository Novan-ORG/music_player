part of 'song_details_bloc.dart';

sealed class SongDetailsState extends Equatable {
  const SongDetailsState();
  
  @override
  List<Object> get props => [];
}

final class SongDetailsInitial extends SongDetailsState {}
