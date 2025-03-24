import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/settings/providers/model.dart';
import 'package:video_player/video_player.dart';

class AdhanPage extends StatefulWidget {
  const AdhanPage({super.key, required this.path});
  final String path;
  @override
  State<AdhanPage> createState() => _AdhanPageState();
}

class _AdhanPageState extends State<AdhanPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerController? _controller;
  late final Map<String, dynamic> azanFiles;
  int _currentImageIndex = 0;

  final _adhanImages = [
    'assets/images/azan_images/1.jpg',
    'assets/images/azan_images/2.jpg',
    'assets/images/azan_images/3.jpg',
  ];

  final Duration _imageChangeInterval = Duration(seconds: 7);

  late final Timer _timer;

  @override
  void initState() {
    super.initState();
   if(widget.path != '')  _initializeVideo(widget.path);
    _timer = Timer.periodic(_imageChangeInterval, (time) {
      setState(() {
        if (_currentImageIndex == _adhanImages.length - 1) {
          _currentImageIndex = 0;
        } else {
          _currentImageIndex++;
        }
      });
    });
  }

  Future<void> _playAdhan() async {
    final encodedUrl = Uri.encodeFull('assets/audio/Azan.mp3');
    await _audioPlayer
        .play(AssetSource(encodedUrl)); // Ensure the path is correct
  }

  Future<void> _initializeVideo(String path) async {
    try {
      _controller = VideoPlayerController.file(File(path));

      await _controller?.initialize();
      if (!mounted) return;

      setState(() {
        _controller?.play();
      });
    } catch (e) {
      debugPrint('Video initialization error: $e');
    }
  }

  Future<FileData?> getFileData() async {
    return await FileData.loadFromStorage();
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop the audio when the page is closed
    _audioPlayer.dispose(); // Release resources
    _timer.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        context.read<NavigationProvider>().setPage('home');
        _audioPlayer.stop(); // Stop the audio when the page is closed
        _timer.cancel();
      },
      child: _controller != null
          ? SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Stack(
                children: [
                  VideoPlayer(_controller as VideoPlayerController),
                  VideoProgressIndicator(
                    _controller as VideoPlayerController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: const Color.fromRGBO(50, 50, 200, 0.2),
                      backgroundColor: const Color.fromRGBO(200, 200, 200, 0.5),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    _adhanImages[_currentImageIndex],
                  ), // Path to your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      getFileData().then((value) {
                        print(value?.screenSaver['de']);
                      });
                    },
                    child: Text('get data')),
              ),
            ),
    ));
  }
}
