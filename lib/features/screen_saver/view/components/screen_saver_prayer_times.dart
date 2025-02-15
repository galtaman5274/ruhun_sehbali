// import 'package:adhan/adhan.dart';
// import 'package:azan/presentation/localization/localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../app/prayer/prayer_notifier.dart';
// import 'screen_prayer_time.dart';

// class ScreenSaverPrayerTimes extends StatelessWidget {
//   const ScreenSaverPrayerTimes({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PrayerTimesNotifier>(
//       builder: (context, provider, _) {
//         return Container(
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ScreenPrayerTime(
//                 prayerName: context.l10n.prayerFajr,
//                 prayerTime: provider.getPrayerTime(Prayer.fajr),
//                 hasPassed: provider.prayerPassed[0],
//               ),
//               ScreenPrayerTime(
//                 prayerName: context.l10n.prayerTulu,
//                 prayerTime: provider.getPrayerTime(Prayer.sunrise),
//                 hasPassed: provider.prayerPassed[1],
//               ),
//               ScreenPrayerTime(
//                 prayerName: context.l10n.prayerDhuhr,
//                 prayerTime: provider.getPrayerTime(Prayer.dhuhr),
//                 hasPassed: provider.prayerPassed[2],
//               ),
//               ScreenPrayerTime(
//                 prayerName: context.l10n.prayerAsr,
//                 prayerTime: provider.getPrayerTime(Prayer.asr),
//                 hasPassed: provider.prayerPassed[3],
//               ),
//               ScreenPrayerTime(
//                 prayerName: context.l10n.prayerMaghrib,
//                 prayerTime: provider.getPrayerTime(Prayer.maghrib),
//                 hasPassed: provider.prayerPassed[4],
//               ),
//               ScreenPrayerTime(
//                 prayerName: context.l10n.prayerIsha,
//                 prayerTime: provider.getPrayerTime(Prayer.isha),
//                 hasPassed: provider.prayerPassed[5],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class ScreenSaverPrayerTimesFull extends StatelessWidget {
//   const ScreenSaverPrayerTimesFull({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PrayerTimesNotifier>(
//       builder: (context, provider, _) {
//         return Container(
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ScreenPrayerTimeFull(
//                 prayerName: context.l10n.prayerFajr,
//                 prayerTime: provider.getPrayerTime(Prayer.fajr),
//                 hasPassed: provider.prayerPassed[0],
//                 screenSaver: true,
//               ),
//               ScreenPrayerTimeFull(
//                 prayerName: context.l10n.prayerTulu,
//                 prayerTime: provider.getPrayerTime(Prayer.sunrise),
//                 hasPassed: provider.prayerPassed[1],
//                 screenSaver: true,
//               ),
//               ScreenPrayerTimeFull(
//                 prayerName: context.l10n.prayerDhuhr,
//                 prayerTime: provider.getPrayerTime(Prayer.dhuhr),
//                 hasPassed: provider.prayerPassed[2],
//                 screenSaver: true,
//               ),
//               ScreenPrayerTimeFull(
//                 prayerName: context.l10n.prayerAsr,
//                 prayerTime: provider.getPrayerTime(Prayer.asr),
//                 hasPassed: provider.prayerPassed[3],
//                 screenSaver: true,
//               ),
//               ScreenPrayerTimeFull(
//                 prayerName: context.l10n.prayerMaghrib,
//                 prayerTime: provider.getPrayerTime(Prayer.maghrib),
//                 hasPassed: provider.prayerPassed[4],
//                 screenSaver: true,
//               ),
//               ScreenPrayerTimeFull(
//                 prayerName: context.l10n.prayerIsha,
//                 prayerTime: provider.getPrayerTime(Prayer.isha),
//                 hasPassed: provider.prayerPassed[5],
//                 screenSaver: true,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
