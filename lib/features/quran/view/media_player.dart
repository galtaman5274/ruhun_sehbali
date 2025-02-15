import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaPlayerPage extends StatefulWidget {
  final String url;
  const MediaPlayerPage({super.key, required this.url});

  @override
  State<MediaPlayerPage> createState() => _MediaPlayerPageState();
}

class _MediaPlayerPageState extends State<MediaPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playAdhan(widget.url); // Start playing Adhan when the page opens
  }

  Future<void> _playAdhan(String urlSource) async {
    final encodedUrl = Uri.encodeFull(urlSource);
    
    await _audioPlayer
        .play(UrlSource(encodedUrl)); // Ensure the path is correct
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop the audio when the page is closed
    _audioPlayer.dispose(); // Release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()=> Navigator.pop(context)),
      body: Center(
        child: Container(
          color: const Color.fromARGB(137, 47, 20, 168), // Optional: Semi-transparent overlay
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Quran is Playing...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
