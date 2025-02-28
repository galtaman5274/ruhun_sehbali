import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, state) {
        String? countryName = state.prayerData.countries
                .any((country) => country.isoCode == state.prayerData.country)
            ? state.prayerData.countries
                .firstWhere((e) => e.isoCode == state.prayerData.country)
                .name
            : null;
        return Text(
          '${countryName?.toUpperCase() ?? state.prayerData.country}/${state.prayerData.city}',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        );
      },
    );
  }
}
