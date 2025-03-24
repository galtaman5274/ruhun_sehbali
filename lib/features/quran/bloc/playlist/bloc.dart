import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../storage_controller/storage_controller.dart';

part 'events.dart';
part 'states.dart';

// Playlist Item Model
class PlaylistItem {
  final String localPath;
  final String url;
  final String name;

  PlaylistItem(
      {required this.localPath, required this.url, required this.name});

  // // Convert object to Map for storage
  // Map<String, dynamic> toJson() => {
  //       "localPath": localPath,
  //       "url": url,
  //       "name":name
  //     };

  // // Convert Map to object
  // factory PlaylistItem.fromJson(Map<String, dynamic> json) {
  //   return PlaylistItem(
  //     localPath: json["localPath"],
  //     url: json["url"],
  //     name: json['name']
  //   );
  // }
}

// BLOC
class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(const PlaylistState([])) {
    on<AddMedia>(_onAddMedia);
    on<ClearPlaylist>(_onClearPlaylist);
    on<InitPlaylist>(_onInitPlaylist);
  }
  void _onInitPlaylist(InitPlaylist event, Emitter<PlaylistState> emit) async {
    final List<PlaylistItem> playlist = [];
    final quranFiles = event.quranFiles;
    final keys = quranFiles.keys.toList();
    for (var i = 0; i < keys.length; i++) {
      final innerKeys = quranFiles[keys[i]].keys.toList();
      for (var j = 0; j < innerKeys.length; j++) {
        quranFiles[keys[i]][innerKeys[j]].forEach((item) {
          if (item['onPlayList'] == true) {
            playlist.add(PlaylistItem(
                localPath: item['local'],
                url: item['url'],
                name: item['name']));
          }
        });
        
      }
    }
    emit(PlaylistState(playlist));
  }
  // /// Load stored playlist on app start
  // Future<void> _loadFromStorage() async {
  //   final storedJson = await _secureStorage.getValue(_storedDataKey);
  //   if (storedJson != null && storedJson.isNotEmpty) {
  //     final List<dynamic> decodedData = jsonDecode(storedJson);
  //     final playlist =
  //         decodedData.map((item) => PlaylistItem.fromJson(item)).toList();
  //     emit(PlaylistState(playlist)); // Emit loaded playlist
  //   }
  // }

  void _onAddMedia(AddMedia event, Emitter<PlaylistState> emit) async {
    final updatedPlaylist = [...state.playlist, ...event.url];
    emit(PlaylistState(updatedPlaylist));
  }

  

  void _onClearPlaylist(
      ClearPlaylist event, Emitter<PlaylistState> emit) async {
    //await _secureStorage.deleteValue(_storedDataKey); // Clear from storage
    emit(PlaylistState([]));
  }
}
