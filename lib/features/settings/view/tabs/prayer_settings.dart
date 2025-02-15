import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';

class PrayerSettingsTab extends StatelessWidget {
  const PrayerSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> prayerAdjustmentsLocalization = {
      'fajr': context.l10n.prayerFajr,
      'tulu': context.l10n.prayerTulu,
      'dhuhr': context.l10n.prayerDhuhr,
      'asr': context.l10n.prayerAsr,
      'magrib': context.l10n.prayerMaghrib,
      'isha': context.l10n.prayerIsha,
    };
    return BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
      final adjustments =
          state.prayerData.prayerTimes.calculationParameters.adjustments;
      Map<String, int> prayerAdjustments = {
        'fajr': adjustments.fajr,
        'tulu': adjustments.sunrise,
        'dhuhr': adjustments.dhuhr,
        'asr': adjustments.asr,
        'magrib': adjustments.maghrib,
        'isha': adjustments.isha,
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adjust Prayer Times (in minutes):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Column(
            children: prayerAdjustments.keys.map((prayer) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prayerAdjustmentsLocalization[prayer]!.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 180,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            prayerAdjustments[prayer] =
                                (prayerAdjustments[prayer]! - 1);
                            adjustments.fajr += 1;
                          },
                          child: const Text('-'),
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: prayerAdjustments[prayer].toString(),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            prayerAdjustments[prayer] =
                                (prayerAdjustments[prayer]! + 1);
                          },
                          child: const Text('+'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final updatedAdjustments = prayerAdjustments.map(
                  (key, value) => MapEntry(key, value.toString()),
                );
                print(adjustments.fajr);
                //provider.saveAdjustments(updatedAdjustments);
              },
              child: const Text('Save Adjustments'),
            ),
          ),
        ],
      );
    });
  }
}
