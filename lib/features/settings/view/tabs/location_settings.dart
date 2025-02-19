import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/view/home_screen.dart';
import '../../../prayer/bloc/prayer_bloc.dart';

class SetupLocation extends StatelessWidget {
  const SetupLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PrayerBloc>();
    bloc.add(LoadCountriesEvent());
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, state) {
        final prayerData = state.prayerData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Dropdown
            const Text('Select Country:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select Country"),
              value: prayerData.countries
                      .any((country) => country.isoCode == prayerData.country)
                  ? prayerData.country
                  : null, // Ensure only a valid value is selected
              items: prayerData.countries
                  .map((country) => DropdownMenuItem(
                        value: country.isoCode,
                        child: Text(country.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  bloc.add(UpdateCountryEvent(value));
                  bloc.add(LoadStatesEvent(value));
                }
              },
            ),

            const SizedBox(height: 20),
            // State Dropdown
            const Text('Select State:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select State"),
              value: prayerData.states
                      .any((stateItem) => stateItem.isoCode == prayerData.state)
                  ? prayerData.state
                  : null, // Ensures a valid selected state
              items: prayerData.states
                  .map((stateItem) => DropdownMenuItem(
                        value: stateItem.isoCode,
                        child: Text(stateItem.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  bloc.add(UpdateStateEvent(value));
                  bloc.add(LoadCitiesEvent(prayerData.country, value));
                }
              },
            ),

            const SizedBox(height: 20),
            // City Dropdown
            const Text('Select City:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select City"),
              value: prayerData.cities.isNotEmpty &&
                      prayerData.cities
                          .any((city) => city.name == prayerData.city)
                  ? prayerData.city
                  : null, // Ensure the selected city exists
              items: prayerData.cities
                  .map((city) => DropdownMenuItem(
                        value: city.name,
                        child: Text(city.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  bloc.add(UpdateCityEvent(value));
                }
              },
            ),

            const SizedBox(height: 20),
            // Calculation Method Dropdown
            const Text('Select Calculation Method:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<CalculationMethod>(
              isExpanded: true,
              value: prayerData.calculationMethod,
              items: CalculationMethod.values
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  bloc.add(UpdateCalculationMethodEvent(value));
                }
              },
            ),
            const SizedBox(height: 20),
            // Asr Calculation Method Dropdown
            const Text('Select Asr Method:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              isExpanded: true,
              value: prayerData.asrMethodIndex,
              items: [0, 1]
                  .map((index) => DropdownMenuItem(
                        value: index,
                        child: Text(index == 0 ? 'Asri-Sani' : 'Asri-Evvel'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  bloc.add(UpdateAsrMethodEvent(value));
                }
              },
            ),
            const SizedBox(height: 20),
            // Display Coordinates
            Text(
                'Latitude: ${prayerData.latitude}, Longitude: ${prayerData.longitude}'),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  bloc.add(const SavePrayerSettingsEvent());
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                child: const Text('Save and Continue'),
              ),
            ),
          ],
        );
      },
    );
  }
}
