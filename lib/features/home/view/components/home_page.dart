import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';

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
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/mecca.jpg',
          ), // Replace with your image path
          fit: BoxFit.fill,
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            iconSize: 30,
            color: Colors.white,
            onPressed: () => SystemNavigator.pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        Center(
          child: Container(
            width: 1000,
            height: 600,

            decoration: BoxDecoration(
              color: const Color.fromARGB(80, 211, 207, 207),
              borderRadius: BorderRadius.circular(20),
            ), // Rounded corners
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MainButton(
                      text: context.l10n.homeButtonQuran,
                      nav: 'quran',
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    MainButton(
                      text: context.l10n.homeButtonAdhan,
                      nav: 'adhan',
                    ),
                    IconButton(
                        color: Colors.white,
                        onPressed: () {
                          //context.read<MainBloc>().add(const NavigateToEvent('settings'));
                          context
                              .read<NavigationProvider>()
                              .setPage('settings');
                          // context
                          //     .read<MainBloc>()
                          //     .add(ResetInactivityTimerEvent());
                          // final provider = Provider.of<NavigationProvider>(
                          //     context,
                          //     listen: false);
                          // provider.navigateTo('settings');
                          // provider.resetInactivityTimer();
                        },
                        icon: const Icon(Icons.settings))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/images/Sultanahmet.jpg'),
                      height: 400,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    BlocBuilder<PrayerBloc, PrayerState>(
                      builder: (context, state) {
                        final remainingTime = state.prayerData.remainingTime;
                        
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 2, 60, 107),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              width: 300,
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
                              height: 20,
                            ),
                            Row(
                              children: [
                                PrayerTimeItemWidget(
                                  prayerName: context.l10n.prayerFajr,
                                  prayerTime: getPrayerTime(
                                      state.prayerData.prayerTimes.fajr),
                                  hasPassed: state.prayerData.prayerPassed[0],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                PrayerTimeItemWidget(
                                  prayerName: context.l10n.prayerTulu,
                                  prayerTime: getPrayerTime(
                                      state.prayerData.prayerTimes.sunrise),
                                  hasPassed: state.prayerData.prayerPassed[1],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                PrayerTimeItemWidget(
                                  prayerName: context.l10n.prayerDhuhr,
                                  prayerTime: getPrayerTime(
                                      state.prayerData.prayerTimes.dhuhr),
                                  hasPassed: state.prayerData.prayerPassed[2],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                PrayerTimeItemWidget(
                                  prayerName: context.l10n.prayerAsr,
                                  prayerTime: getPrayerTime(
                                      state.prayerData.prayerTimes.asr),
                                  hasPassed: state.prayerData.prayerPassed[3],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                PrayerTimeItemWidget(
                                  prayerName: context.l10n.prayerMaghrib,
                                  prayerTime: getPrayerTime(
                                      state.prayerData.prayerTimes.maghrib),
                                  hasPassed: state.prayerData.prayerPassed[4],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                PrayerTimeItemWidget(
                                  prayerName: context.l10n.prayerIsha,
                                  prayerTime: getPrayerTime(
                                      state.prayerData.prayerTimes.isha),
                                  hasPassed: state.prayerData.prayerPassed[5],
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
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
            ]),
          ),
        )
      ]),
    ));
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
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: hasPassed
            ? Colors.grey
            : const Color.fromARGB(
                255, 177, 146, 135), // Change color if prayer has passed
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              prayerName.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: hasPassed
                    ? const Color.fromARGB(255, 80, 237, 23)
                    : Colors.white, // Optional: Change text color
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              prayerTime,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white, // Text color for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
