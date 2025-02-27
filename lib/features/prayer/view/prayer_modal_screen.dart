import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';

class PrayerTimeModal extends StatefulWidget {
  final int prayerAdjustment;
  final String prayerName;
  final String prayerNameLocalized;
  final Map<String, bool> prayerTimes;

  const PrayerTimeModal(
      {super.key,
      required this.prayerName,
      required this.prayerNameLocalized,
      required this.prayerAdjustment,
      required this.prayerTimes});

  @override
  PrayerTimeModalState createState() => PrayerTimeModalState();
}

class PrayerTimeModalState extends State<PrayerTimeModal> {
  int prayerAdjustment = 0;
  @override
  void initState() {
    prayerAdjustment = widget.prayerAdjustment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  'Select Days',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 500,
                  width: 300,
                  child: Column(
                    children: [
                      Text(widget.prayerName),
                      ...widget.prayerTimes.entries.map((dayEntry) {
                        final day = dayEntry.key;
                        final isChecked = dayEntry.value;
                        return CheckboxListTile(
                          title: Text(day),
                          value: isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              widget.prayerTimes[day] = newValue ?? false;
                            });
                          },
                        );
                      })
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Return the updated data when saved
                    Navigator.pop(context);
                    context.read<PrayerBloc>().add(PrayerWeekDaysEvent(
                        widget.prayerTimes, widget.prayerName));
                    context.read<PrayerBloc>().add(PrayerTimeAdjustedEvent(
                        prayerAdjustment, widget.prayerName));
                  },
                  child: Text('Save'),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adjust Prayer Times (in minutes):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.prayerNameLocalized.toUpperCase(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                prayerAdjustment--;
                              });
                            },
                            child: const Text('-'),
                          ),
                          Expanded(
                              child: Center(
                                  child: Text(prayerAdjustment.toString()))),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                prayerAdjustment++;
                              });
                            },
                            child: const Text('+'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
