import 'package:flutter/material.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';
import 'image_animation.dart';

class ScreenSaverFull extends StatelessWidget {
  final ScreenSaverStateData saverStateData;
  const ScreenSaverFull({super.key,required this.saverStateData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child:  ImageAnimation(image: saverStateData.images[saverStateData.currentIndex],),
          ),
        ),
       //const ScreenSaverPrayerTimesFull(),
      ],
    );
  }
}

class ScreenSaverMini extends StatelessWidget {
    final ScreenSaverStateData saverStateData;

  const ScreenSaverMini({super.key,required this.saverStateData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  child:  ImageAnimation(image: saverStateData.images[saverStateData.currentIndex],),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 2, 60, 107),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    width: 174,
                    child: const Column(
                      //children: [CurrentTimeWidget(), TimeLeftWidget()],
                    ),
                  ),
                ],
              )
            ],
          ),
          //const ScreenSaverPrayerTimes(),
        ],
      ),
    );
  }
}

// class CurrentTimeWidget extends StatelessWidget {
//   const CurrentTimeWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final time = Provider.of<PrayerTimesNotifier>(context).currentTime;
//     return Text(
//       time,
//       style: const TextStyle(
//           color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//     );
//   }
// }

// // Widget to Display Time Left for Next Prayer
// class TimeLeftWidget extends StatelessWidget {
//   const TimeLeftWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final timeLeft =
//         Provider.of<PrayerTimesNotifier>(context).timeLeftForNextPrayer;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           context.l10n.timeLeftText,
//           style: const TextStyle(fontSize: 8, color: Colors.white),
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         Text(
//           timeLeft,
//           style: const TextStyle(fontSize: 10, color: Colors.white),
//         ),
//       ],
//     );
//   }
// }

// class CurrentDateWidget extends StatelessWidget {
//   const CurrentDateWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final date = Provider.of<PrayerTimesNotifier>(context).currentDate;
//     return Text(
//       date,
//       style: const TextStyle(fontSize: 20),
//     );
//   }
// }
