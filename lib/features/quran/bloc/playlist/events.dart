part of 'bloc.dart';

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
