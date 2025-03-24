part of 'bloc.dart';

// EVENTS
abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class AddMedia extends PlaylistEvent {
  final List<PlaylistItem> url;
  const AddMedia(this.url);

  @override
  List<Object?> get props => [url];
}
class InitPlaylist extends PlaylistEvent {
  final Map<String,dynamic> quranFiles;
  const InitPlaylist(this.quranFiles);

  @override
  List<Object?> get props => [quranFiles];
}
class ClearPlaylist extends PlaylistEvent {}
