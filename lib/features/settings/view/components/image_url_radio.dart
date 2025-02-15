import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';

class ImagesUrlSelector extends StatefulWidget {
  const ImagesUrlSelector({Key? key}) : super(key: key);

  @override
  State<ImagesUrlSelector> createState() => _ImagesUrlSelectorState();
}

class _ImagesUrlSelectorState extends State<ImagesUrlSelector> {
  // Define the list of options.
  final List<String> options = ['tr', 'ar', 'de', 'us', 'own'];
  final List<String> optionsName = [
  'Türkçe',
  'العربية',
  'Deutsch',
  'English',
  'Personal'
];


  // Set a default value.
  String selectedOption = 'tr';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        return Expanded(
          child: RadioListTile<String>(
            title: Text(option.toUpperCase()),
            subtitle: Text(optionsName[options.indexOf(option)]),
            value: option,
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
              // Dispatch the event with the selected value.
              context.read<ScreenSaverBloc>().add(SetImagesUrlEvent(value!));
            },
          ),
        );
      }).toList(),
    );
  }
}
