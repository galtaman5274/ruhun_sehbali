import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';
import 'package:ruhun_sehbali/features/screen_saver/view/components/screen_prayer_time.dart';
import 'image_animation.dart';

class ScreenSaverFull extends StatelessWidget {
  final ScreenSaverStateData saverStateData;
  const ScreenSaverFull({super.key, required this.saverStateData});

  @override
  Widget build(BuildContext context) {
    final greenTextStyle = TextStyle(
      color: const Color.fromARGB(255, 80, 237, 23),
      fontSize: 16,
    );
    bool isMidnight() {
      DateTime now = DateTime.now();
      return now.hour == 0 && now.minute == 0;
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            color: Colors.black,
            child: ImageAnimation(
              image: saverStateData.turnOffDisplay && isMidnight()
                  ? Image(image: AssetImage('assets/images/sleep.jpg'))
                  : saverStateData.images[saverStateData.currentIndex],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 20),
          height: 40,
          color: const Color.fromARGB(255, 42, 42, 42),
          child:
              BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
            final prayerData = state.prayerData;
            return Row(
              children: [
                Text(
                  prayerData.currentDate,
                  style: greenTextStyle,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  prayerData.currentTime,
                  style: greenTextStyle,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  context.l10n.timeLeftText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  prayerData.remainingTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerFajr,
                    prayerTime: prayerData.prayerTimes.fajr,
                    hasPassed: prayerData.prayerPassed[0]),
                Spacer(),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerTulu,
                    prayerTime: prayerData.prayerTimes.sunrise,
                    hasPassed: prayerData.prayerPassed[1]),
                Spacer(),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerDhuhr,
                    prayerTime: prayerData.prayerTimes.dhuhr,
                    hasPassed: prayerData.prayerPassed[2]),
                Spacer(),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerMaghrib,
                    prayerTime: prayerData.prayerTimes.maghrib,
                    hasPassed: prayerData.prayerPassed[3]),
                Spacer(),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerIsha,
                    prayerTime: prayerData.prayerTimes.isha,
                    hasPassed: prayerData.prayerPassed[4]),
              ],
            );
          }),
        )
        //const ScreenSaverPrayerTimesFull(),
      ],
    );
  }
}

class ScreenSaverMini extends StatelessWidget {
  final ScreenSaverStateData saverStateData;

  const ScreenSaverMini({super.key, required this.saverStateData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 246, 246, 245),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ImageAnimation(
                    image: saverStateData.images[saverStateData.currentIndex],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlocBuilder<PrayerBloc, PrayerState>(
                        builder: (context, state) {
                      final prayerData = state.prayerData;
                      return Column(
                        children: [
                          Text(
                            prayerData.currentDate,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            prayerData.currentTime,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            context.l10n.timeLeftText,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            prayerData.remainingTime,
                            style: TextStyle(color: Colors.black),
                          ),
                          ScreenPrayerTime(
                              prayerName: context.l10n.prayerFajr,
                              prayerTime: prayerData.prayerTimes.fajr,
                              hasPassed: prayerData.prayerPassed[0]),
                          ScreenPrayerTime(
                              prayerName: context.l10n.prayerTulu,
                              prayerTime: prayerData.prayerTimes.sunrise,
                              hasPassed: prayerData.prayerPassed[1]),
                        ],
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
          BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
            final prayerData = state.prayerData;
            return Row(
              children: [
                ScreenPrayerTime(
                    prayerName: context.l10n.prayerDhuhr,
                    prayerTime: prayerData.prayerTimes.dhuhr,
                    hasPassed: prayerData.prayerPassed[2]),
                ScreenPrayerTime(
                    prayerName: context.l10n.prayerMaghrib,
                    prayerTime: prayerData.prayerTimes.maghrib,
                    hasPassed: prayerData.prayerPassed[3]),
                ScreenPrayerTime(
                    prayerName: context.l10n.prayerIsha,
                    prayerTime: prayerData.prayerTimes.isha,
                    hasPassed: prayerData.prayerPassed[4]),
              ],
            );
          }),
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
