// playlist_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'events.dart';
part 'states.dart';

// BLOC
class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(const PlaylistState([])) {
    on<AddMedia>(_onAddMedia);
    on<ClearPlaylist>(_onClearPlaylist);
  }

  void _onAddMedia(AddMedia event, Emitter<PlaylistState> emit) {
    emit(PlaylistState([...state.playlist, ...event.url]));
  }

  void _onClearPlaylist(ClearPlaylist event, Emitter<PlaylistState> emit) {
    emit(PlaylistState([]));
  }
}
