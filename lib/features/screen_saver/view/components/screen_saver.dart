import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    bool isMidnight() {
      DateTime now = DateTime.now();
      return now.hour == 0 && now.minute == 0;
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: ImageAnimation(
              image: saverStateData.turnOffDisplay && isMidnight()
                  ? Image(image: AssetImage('assets/images/sleep.jpg'))
                  : saverStateData.images[saverStateData.currentIndex],
            ),
          ),
        ),
        Container(
          color: Colors.black,
          child:
              BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
            final prayerData = state.prayerData;
            return Row(
              children: [
                Text(
                  prayerData.currentDate,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  prayerData.currentTime,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  context.l10n.timeLeftText,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  prayerData.remainingTime,
                  style: TextStyle(color: Colors.white),
                ),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerFajr,
                    prayerTime: prayerData.prayerTimes.fajr,
                    hasPassed: prayerData.prayerPassed[0]),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerTulu,
                    prayerTime: prayerData.prayerTimes.sunrise,
                    hasPassed: prayerData.prayerPassed[1]),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerDhuhr,
                    prayerTime: prayerData.prayerTimes.dhuhr,
                    hasPassed: prayerData.prayerPassed[2]),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerAsr,
                    prayerTime: prayerData.prayerTimes.asr,
                    hasPassed: prayerData.prayerPassed[3]),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerMaghrib,
                    prayerTime: prayerData.prayerTimes.maghrib,
                    hasPassed: prayerData.prayerPassed[4]),
                ScreenPrayerTimeFull(
                    prayerName: context.l10n.prayerIsha,
                    prayerTime: prayerData.prayerTimes.isha,
                    hasPassed: prayerData.prayerPassed[5]),
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
    return BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
      final prayerData = state.prayerData;
      return Stack(
        children: [
          Image.asset(
            'assets/images/levha_bg.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepOrange, // Border color
                  width: 5, // Border width
                ),
              ),
              height: 550,
              width: 1000,
              child: ImageAnimation(
                image: saverStateData.images[saverStateData.currentIndex],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 80,
            child: Image.asset(
              'assets/images/bg_octa.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/bg_octa_2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ),
          Positioned(
            right: 40,
            bottom: 60,
            child: SizedBox(
              width: 100,
              child: Text(
                prayerData.currentDate,
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
          ),
          Positioned(
            right: 60,
            top: 130,
            child: Text(
              prayerData.currentTime,
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
          ),
          Positioned(
            right: 58,
            top: 190,
            child: Text(
              context.l10n.timeLeftText,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Positioned(
            right: 70,
            top: 210,
            child: Text(
              prayerData.remainingTime,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Positioned(
            right: 20,
            top: 300,
            child: PrayerTimeItemWidget(
              prayerName: context.l10n.prayerFajr,
              prayerTime: prayerData.prayerTimes.fajr,
              hasPassed: prayerData.prayerPassed[0],
            ),
          ),
          Positioned(
            right: 20,
            top: 450,
            child: PrayerTimeItemWidget(
              prayerName: context.l10n.prayerTulu,
              prayerTime: prayerData.prayerTimes.sunrise,
              hasPassed: prayerData.prayerPassed[1],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 0,
            child: PrayerTimeItemWidget(
              prayerName: context.l10n.prayerDhuhr,
              prayerTime: prayerData.prayerTimes.dhuhr,
              hasPassed: prayerData.prayerPassed[2],
            ),
          ),
          Positioned(
            left: 300,
            bottom: 0,
            child: PrayerTimeItemWidget(
              prayerName: context.l10n.prayerAsr,
              prayerTime: prayerData.prayerTimes.asr,
              hasPassed: prayerData.prayerPassed[3],
            ),
          ),
          Positioned(
            right: 500,
            bottom: 0,
            child: PrayerTimeItemWidget(
              prayerName: context.l10n.prayerMaghrib,
              prayerTime: prayerData.prayerTimes.maghrib,
              hasPassed: prayerData.prayerPassed[4],
            ),
          ),
          Positioned(
            right: 200,
            bottom: 0,
            child: PrayerTimeItemWidget(
              prayerName: context.l10n.prayerIsha,
              prayerTime: prayerData.prayerTimes.isha,
              hasPassed: prayerData.prayerPassed[4],
            ),
          ),
        ],
      );
    });
  }
}

// Prayer Time Item Widget
class PrayerTimeItemWidget extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final bool hasPassed;

  const PrayerTimeItemWidget(
      {super.key,
      required this.prayerName,
      required this.prayerTime,
      required this.hasPassed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/time_frame.png',
          ), // Replace with your image path
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              prayerName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: hasPassed
                    ? Color.fromARGB(255, 101, 109, 98)
                    : const Color.fromARGB(
                        255, 3, 3, 3), // Optional: Change text color
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              DateFormat.Hm().format(prayerTime),
              style: TextStyle(
                fontSize: 22,
                color: hasPassed
                    ? Color.fromARGB(255, 101, 109, 98)
                    : const Color.fromARGB(
                        255, 3, 3, 3), // Text color for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
