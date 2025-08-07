import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'song_details_event.dart';
part 'song_details_state.dart';

class SongDetailsBloc extends Bloc<SongDetailsEvent, SongDetailsState> {
  SongDetailsBloc() : super(SongDetailsInitial()) {
    on<SongDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
