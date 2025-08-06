import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show immutable;

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc() : super(SongsInitial()) {
    on<SongsEvent>((event, emit) {});
  }
}
