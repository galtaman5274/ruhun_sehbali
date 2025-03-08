import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';
import 'package:ruhun_sehbali/features/settings/providers/model.dart';
import 'package:video_player/video_player.dart';

class AdhanPage extends StatefulWidget {
  const AdhanPage({super.key});

  @override
  State<AdhanPage> createState() => _AdhanPageState();
}

class _AdhanPageState extends State<AdhanPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late VideoPlayerController _controller;
  late final FileData fileData;
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
    context.read<AyineJsonCubit>().getFileData().then((onValue) {
      if (!mounted) return; // Check if widget is still mounted

      fileData = onValue;
      print(fileData.azanFiles);
      // _controller = VideoPlayerController.file(
      //     File(fileData.azanFiles['Arabic']['01-Fajr'][0]['local']))
      //   ..initialize().then((_) {
      //     if (!mounted) return; // Check if widget is still mounted
      //     setState(() {
      //       _controller.play();
      //     });
      //   });
    });
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

  // Future<void> _playAdhan() async {
  //   final url = 'https://app.ayine.tv/Ayine/AzanFiles/Turkish/01-Fajr/001.mp4';
  //   final encodedUrl = Uri.encodeFull(url);
  //   try {
  //     await _audioPlayer.play(
  //       AssetSource('audio/Azan.mp3'),
  //     ); // Ensure the path is correct
  //   } catch (e) {
  //     log('audioplayer error : ${e.toString()}');
  //   }
  // }

  // Future<void> _playAdhanVideo(){
  //   try {
  //   final controller = VideoPlayerController.network('https://app.ayine.tv/Ayine/AzanFiles/Turkish/01-Fajr/001.mp4');
  //   await controller.initialize();
  //   await controller.play();

  //   } catch (e) {
  //     log('videoplayer error : ${e.toString()}');

  //   }
  // }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop the audio when the page is closed
    _audioPlayer.dispose(); // Release resources
    _timer.cancel();
    _controller.dispose();
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
        child:
            // _controller.value.isInitialized
            //     ? SizedBox(
            //         width: MediaQuery.sizeOf(context).width,
            //         height: MediaQuery.sizeOf(context).height,
            //         child: Stack(
            //           children: [
            //             VideoPlayer(_controller),
            //             VideoProgressIndicator(
            //               _controller,
            //               allowScrubbing: true,
            //               colors: VideoProgressColors(
            //                 playedColor: Colors.blue,
            //                 bufferedColor: const Color.fromRGBO(50, 50, 200, 0.2),
            //                 backgroundColor:
            //                     const Color.fromRGBO(200, 200, 200, 0.5),
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     :
            Container(
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
          // child: Center(
          //   child: Container(
          //     color: Colors.black54, // Optional: Semi-transparent overlay
          //     padding: const EdgeInsets.all(16.0),
          //     child: const Text(
          //       'Adhan is Playing...',
          //       style: TextStyle(
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
