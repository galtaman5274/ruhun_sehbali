// playlist_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// EVENTS
abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class AddMedia extends PlaylistEvent {
  final List<String> url;
  const AddMedia(this.url);

  @override
  List<Object?> get props => [url];
}

class ClearPlaylist extends PlaylistEvent {}

// STATES
class PlaylistState extends Equatable {
  final List<String> playlist;
  const PlaylistState(this.playlist);

  @override
  List<Object?> get props => [playlist];
}

// BLOC
class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(const PlaylistState([])) {
    on<AddMedia>((event, emit) {
      
      emit(PlaylistState([...state.playlist,...event.url]));
    });

    on<ClearPlaylist>((event, emit) {
      emit(const PlaylistState([]));
    });
  }
}
