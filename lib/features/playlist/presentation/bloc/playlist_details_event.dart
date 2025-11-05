part of 'playlist_details_bloc.dart';

abstract class PlayListDetailsEvent extends Equatable {
  const PlayListDetailsEvent();
}

class GetPlaylistSongsEvent extends PlayListDetailsEvent {
  const GetPlaylistSongsEvent();

  @override
  List<Object> get props => [];
}
