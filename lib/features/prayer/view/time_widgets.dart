import 'package:flutter/material.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';

class CurrentTimeWidget extends StatelessWidget {
  final String time;
  const CurrentTimeWidget({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = const Color.fromRGBO(205, 205, 205, 1),
            decoration: TextDecoration.none,
            height: 1,
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            decoration: TextDecoration.none,
            height: 1,
          ),
        )
      ],
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
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          timeLeft,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }
}

class CurrentDateWidget extends StatelessWidget {
  final String date;
  const CurrentDateWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: const TextStyle(fontSize: 20),
    );
  }
}
