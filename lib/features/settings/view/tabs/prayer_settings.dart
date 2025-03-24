import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';

import '../../../prayer/view/prayer_modal_screen.dart';

class PrayerSettingsTab extends StatefulWidget {
  const PrayerSettingsTab({super.key});

  @override
  State<PrayerSettingsTab> createState() => _PrayerSettingsTabState();
}

class _PrayerSettingsTabState extends State<PrayerSettingsTab> {
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
            children: prayerAdjustmentsLocalization.keys.map((prayer) {
              return ListTile(
                title: Text(
                  prayerAdjustmentsLocalization[prayer]?.toUpperCase() ??
                      'Prayer',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: this.context,
                    isScrollControlled:
                        true, // Allow the modal to take up most of the screen
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: PrayerTimeModal(
                          prayerAdjustment: prayerAdjustments[prayer] ?? 0,
                          prayerName: prayer,
                          prayerNameLocalized:
                              prayerAdjustmentsLocalization[prayer] ?? '',
                          prayerTimes:
                              state.prayerData.prayerWeekdays[prayer] ?? {},
                        ),
                      );
                    },
                  ),
                  icon: Icon(Icons.edit),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
