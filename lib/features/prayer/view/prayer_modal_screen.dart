import 'package:flutter/material.dart';

class PrayerTimeModal extends StatefulWidget {
  final Map<String, Map<String, bool>> initialData;

  const PrayerTimeModal({super.key, required this.initialData});

  @override
  PrayerTimeModalState createState() => PrayerTimeModalState();
}

class PrayerTimeModalState extends State<PrayerTimeModal> {
  late Map<String, Map<String, bool>> _prayerTimes;

  @override
  void initState() {
    super.initState();
    // Initialize with the provided data
    _prayerTimes = Map.from(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Select Days',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView(
              children: _prayerTimes.entries.map((entry) {
                final prayerName = entry.key;
                final days = entry.value;
                return ExpansionTile(
                  title: Text(prayerName),
                  children: days.entries.map((dayEntry) {
                    final day = dayEntry.key;
                    final isChecked = dayEntry.value;
                    return CheckboxListTile(
                      title: Text(day),
                      value: isChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _prayerTimes[prayerName]![day] = newValue ?? false;
                        });
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Return the updated data when saved
              Navigator.pop(context, _prayerTimes);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}