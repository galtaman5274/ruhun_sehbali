part of 'bloc.dart';


// STATES
class PlaylistState extends Equatable {
  final List<PlaylistItem> playlist;
  const PlaylistState(this.playlist);

  @override
  List<Object?> get props => [playlist];
}
