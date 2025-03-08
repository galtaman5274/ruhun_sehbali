import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';


class AzanSelector extends StatefulWidget {
  const AzanSelector({super.key});

  @override
  State<AzanSelector> createState() => _AzanSelectorState();
}

class _AzanSelectorState extends State<AzanSelector> {
  // Define the list of options.
  final List<String> optionsName = [
    'Arabic',
    'Egyptian',
    'Turkish',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: optionsName.map((option) {
        return BlocBuilder<PrayerBloc, PrayerState>(builder: (context, state) {
          return Expanded(
            child: RadioListTile<String>(
              title: Text(option.toUpperCase()),
              value: option,
              groupValue: state.prayerData.azanType,
              onChanged: (value) {
                context
                    .read<PrayerBloc>()
                    .add(PrayerAzanTypeEvent(value as String));
              },
            ),
          );
        });
      }).toList(),
    );
  }
}
