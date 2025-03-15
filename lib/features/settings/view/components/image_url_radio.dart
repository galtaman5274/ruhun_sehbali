import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';

import '../../../prayer/bloc/prayer_bloc.dart';

class ImagesUrlSelector extends StatefulWidget {
  const ImagesUrlSelector({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        return BlocListener<AyineJsonCubit, AyineJsonState>(
            listener: (context, state) => {},
            child: BlocBuilder<ScreenSaverBloc, ScreenSaverState>(
                builder: (context, state) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(option.toUpperCase()),
                  subtitle: Text(optionsName[options.indexOf(option)]),
                  value: option,
                  groupValue: state.saverStateData.imgUrl,
                  onChanged: (value) {
                    if (value?.toLowerCase() == 'own') {
                      state.saverStateData.personalImagePath == ''
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('select pictures folder')))
                          : context
                              .read<ScreenSaverBloc>()
                              .add(SetImagesUrlEvent(value!));
                    } else {
                      final prayerBloc = context.read<PrayerBloc>();
                      context
                          .read<AyineJsonCubit>()
                          .saveToStorage(value!.toLowerCase(),prayerBloc.state.prayerData.azanType);
                      context
                          .read<ScreenSaverBloc>()
                          .add(SetImagesUrlEvent(value.toLowerCase()));
                    }

                    // Dispatch the event with the selected value.
                  },
                ),
              );
            }));
      }).toList(),
    );
  }
}
