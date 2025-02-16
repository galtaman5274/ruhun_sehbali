import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';
import 'package:ruhun_sehbali/main.dart';

import '../../../prayer/bloc/prayer_bloc.dart';
import '../../../prayer/view/time_widgets.dart';
import 'main_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String getPrayerTime(DateTime prayer) {
    return DateFormat.Hm().format(prayer);
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background.jpg',
            ), // Replace with your image path
            fit: BoxFit.fill,
            colorFilter:
                ColorFilter.mode(Color.fromARGB(30, 0, 0, 0), BlendMode.darken),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Topside buttons
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Settings button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0D9BC).withOpacity(1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(1),
                      child: IconButton(
                        icon: const Icon(Icons.settings,
                            color: Color(0xff79493d), size: 50),
                        onPressed: () {
                          context
                              .read<NavigationProvider>()
                              .setPage('settings');
                        },
                      ),
                    ),
                    // Quit button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0D9BC).withOpacity(1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(1),
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Color(0xff79493d), size: 50),
                        onPressed: () => SystemNavigator.pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              width: screensize.width * 0.83,
              // height: 600,

              // decoration: BoxDecoration(
              //   color: const Color.fromARGB(80, 211, 207, 207),
              //   borderRadius: BorderRadius.circular(20),
              // ), // Rounded corners
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side image and buttons
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Container(
                          height: 500.h,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 6,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 6,
                              ),
                              borderRadius: BorderRadius.circular(1),
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/Sultanahmet.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: MainButton(
                                    text: context.l10n.homeButtonQuran,
                                    nav: 'quran',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: MainButton(
                                    text: context.l10n.homeButtonAdhan,
                                    nav: 'adhan',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  // Right side
                  BlocBuilder<PrayerBloc, PrayerState>(
                    builder: (context, state) {
                      final remainingTime = state.prayerData.remainingTime;
                      return Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF0D9BC),
                                    Color(0xFF7B4E3A),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              width: 400,
                              child: Column(
                                children: [
                                  CurrentTimeWidget(
                                    time: state.prayerData.currentTime,
                                  ),
                                  TimeLeftWidget(
                                    timeLeft: remainingTime,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: PrayerTimeItemWidget(
                                    prayerName: context.l10n.prayerFajr,
                                    prayerTime: getPrayerTime(
                                        state.prayerData.prayerTimes.fajr),
                                    hasPassed: state.prayerData.prayerPassed[0],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: PrayerTimeItemWidget(
                                    prayerName: context.l10n.prayerTulu,
                                    prayerTime: getPrayerTime(
                                        state.prayerData.prayerTimes.sunrise),
                                    hasPassed: state.prayerData.prayerPassed[1],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: PrayerTimeItemWidget(
                                    prayerName: context.l10n.prayerDhuhr,
                                    prayerTime: getPrayerTime(
                                        state.prayerData.prayerTimes.dhuhr),
                                    hasPassed: state.prayerData.prayerPassed[2],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: PrayerTimeItemWidget(
                                    prayerName: context.l10n.prayerAsr,
                                    prayerTime: getPrayerTime(
                                        state.prayerData.prayerTimes.asr),
                                    hasPassed: state.prayerData.prayerPassed[3],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: PrayerTimeItemWidget(
                                    prayerName: context.l10n.prayerMaghrib,
                                    prayerTime: getPrayerTime(
                                        state.prayerData.prayerTimes.maghrib),
                                    hasPassed: state.prayerData.prayerPassed[4],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: PrayerTimeItemWidget(
                                    prayerName: context.l10n.prayerIsha,
                                    prayerTime: getPrayerTime(
                                        state.prayerData.prayerTimes.isha),
                                    hasPassed: state.prayerData.prayerPassed[5],
                                  ),
                                ),
                              ],
                            ),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: Container(
                            //     width: 500,
                            //     color: Colors.amber,
                            //     child: const Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         LocationWidget(),
                            //         SizedBox(
                            //           width: 20,
                            //         ),
                            //         CurrentDateWidget(),
                            //         SizedBox(
                            //           width: 20,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Prayer Time Item Widget
class PrayerTimeItemWidget extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final bool hasPassed;

  const PrayerTimeItemWidget({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.hasPassed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // width: 150,
      height: 125,
      decoration: BoxDecoration(
        color: hasPassed
            ? Colors.grey
            : const Color(0xFFF0D9BC), // Change color if prayer has passed
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Stack(
              children: [
                Text(
                  prayerName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = const Color.fromRGBO(205, 205, 205, 1),
                    decoration: TextDecoration.none,
                    height: 1,
                  ),
                  // style: TextStyle(
                  //   fontSize: 20,
                  //   fontWeight: FontWeight.bold,
                  //   color: hasPassed
                  //       ? const Color.fromARGB(255, 80, 237, 23)
                  //       : Colors.white, // Optional: Change text color
                  // ),
                ),
                Text(
                  prayerName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              prayerTime,
              style: TextStyle(
                fontSize: 24,

                color: hasPassed
                    ? Colors.white
                    : Colors.black, // Text color for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
