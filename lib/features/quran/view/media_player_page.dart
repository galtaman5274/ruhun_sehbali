// media_player_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

import '../bloc/playlist/bloc.dart';

class MediaPlayerPage extends StatefulWidget {
  const MediaPlayerPage({super.key});

  @override
  State<MediaPlayerPage> createState() => _MediaPlayerPageState();
}

class _MediaPlayerPageState extends State<MediaPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<PlaylistItem> _playlist = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Listen for when a track finishes, then play the next one.
    _audioPlayer.onPlayerComplete.listen((event) {
      if (_currentIndex < _playlist.length - 1) {
        setState(() {
          _currentIndex++;
        });
        _playTrack(_playlist[_currentIndex].url);
      }
    });
  }

  Future<void> _playTrack(String url) async {
    final encodedUrl = Uri.encodeFull(url);
    await _audioPlayer.play(UrlSource(encodedUrl));
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        _playlist = state.playlist;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Media Player'),
          ),
          floatingActionButton:
              FloatingActionButton(onPressed: () => Navigator.pop(context)),
          body: Center(
              child: _playlist.isEmpty
                  ? const Text("Playlist is empty")
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _playTrack(_playlist[_currentIndex].url);
                              },
                              child: const Text('Play'),
                            ),
                            const SizedBox(width: 30),
                            ElevatedButton(
                              onPressed: () async {
                                await _audioPlayer.pause();
                              },
                              child: const Text('Pause'),
                            ),
                            const SizedBox(width: 30),
                            ElevatedButton(
                              onPressed: () async {
                                await _audioPlayer.stop();
                              },
                              child: const Text('Stop'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _playlist.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Row(
                                    children: [
                                      Text('${index + 1}'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(_playlist[index].name)
                                    ],
                                  ),
                                  trailing: MaterialButton(
                                    onPressed: () {
                                      // Add the media URL to the playlist
                                      // final playerState = context.read<PlaylistBloc>();
                                      // playerState.add(AddMedia(
                                      //     playerState.state.playlist..add(quranList[index])));
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(content: Text('media added to playlist')),
                                      // );
                                      _playTrack(_playlist[index].url);
                                    },
                                    child: Icon(Icons.play_arrow),
                                  ));
                            },
                          ),
                        ),
                      ],
                    )),
        );
      },
    );
  }
}
