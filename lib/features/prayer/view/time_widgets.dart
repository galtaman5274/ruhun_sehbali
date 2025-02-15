import 'package:flutter/material.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';

class CurrentTimeWidget extends StatelessWidget {
  final String time;
  const CurrentTimeWidget({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: const TextStyle(
          color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
    );
  }
}

// Widget to Display Time Left for Next Prayer
class TimeLeftWidget extends StatelessWidget {
  final String timeLeft;
  const TimeLeftWidget({super.key, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.timeLeftText,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          timeLeft,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
      ],
    );
  }
}

class CurrentDateWidget extends StatelessWidget {
  final String date;
  const CurrentDateWidget({super.key,required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: const TextStyle(fontSize: 20),
    );
  }
}
