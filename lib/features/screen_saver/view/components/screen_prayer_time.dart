import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Prayer Time Item Widget
class ScreenPrayerTime extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final bool hasPassed;

  const ScreenPrayerTime({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.hasPassed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 80,
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
            const SizedBox(height: 5),
            Text(
              prayerName.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: hasPassed
                    ? const Color.fromARGB(255, 80, 237, 23)
                    : Colors.white, // Optional: Change text color
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              DateFormat.Hm().format(prayerTime),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white, // Text color for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenPrayerTimeFull extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final bool hasPassed;

  const ScreenPrayerTimeFull({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.hasPassed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 10),
          Text(
            '${prayerName.toUpperCase()}: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: hasPassed
                  // ? const Color.fromARGB(255, 80, 237, 23)
                  ? const Color.fromARGB(50, 240, 236, 236)
                  : const Color.fromARGB(
                      255, 240, 236, 236), // Optional: Change text color
            ),
          ),
          const SizedBox(width: 4.0),
          Text(
            DateFormat.Hm().format(prayerTime),
            style: TextStyle(
              fontSize: 16,
              color: hasPassed
                  ? const Color.fromARGB(50, 240, 236, 236)
                  : const Color.fromARGB(
                      255, 244, 243, 243), // Text color for better visibility
            ),
          ),
        ],
      ),
    );
  }
}
