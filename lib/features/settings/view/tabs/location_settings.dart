import 'package:adhan/adhan.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../prayer/bloc/prayer_bloc.dart';

class SetupLocation extends StatelessWidget {
  SetupLocation({super.key});

  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final _decoratorProps = DropDownDecoratorProps(
    decoration: InputDecoration(border: InputBorder.none),
  );

  final _popupProps = PopupProps<String>.dialog(
    searchDelay: Duration(milliseconds: 500),
    showSearchBox: true, // Enable search bar
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: "Search...",
        prefixIcon: Icon(Icons.search),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PrayerBloc>();
    bloc.add(LoadCountriesEvent());
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, state) {
        final prayerData = state.prayerData;
        return SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Dropdown
                    const Text('Select Country:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    DropdownSearch<String>(
                      decoratorProps: _decoratorProps,
                      popupProps: _popupProps,
                      dropdownBuilder: (context, selectedItem) => Text(
                        selectedItem ?? "Select country",
                        style: TextStyle(fontSize: 16),
                      ),
                      selectedItem: prayerData.countries.isNotEmpty &&
                              prayerData.countries.any((country) =>
                                  country.isoCode == prayerData.country)
                          ? prayerData.countries
                              .firstWhere(
                                  (e) => e.isoCode == prayerData.country)
                              .name
                          : null,
                      items: (filter, loadProps) {
                        return prayerData.countries
                            .map(
                              (country) => country.name,
                            )
                            .toList();
                      },
                      onChanged: (value) {
                        if (value != null) {
                          final countryIsoCode = prayerData.countries
                              .firstWhere((e) => e.name == value)
                              .isoCode;
                          bloc.add(UpdateCountryEvent(countryIsoCode));
                          bloc.add(LoadStatesEvent(countryIsoCode));
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    // State Dropdown
                    const Text('Select State:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownSearch(
                      decoratorProps: _decoratorProps,
                      popupProps: _popupProps,
                      dropdownBuilder: (context, selectedItem) => Text(
                        selectedItem ?? "Select state",
                        style: TextStyle(fontSize: 16),
                      ),
                      selectedItem: prayerData.states
                              .any((state) => state.isoCode == prayerData.state)
                          ? prayerData.states
                              .firstWhere((e) => e.isoCode == prayerData.state)
                              .name
                          : null,
                      items: (filter, loadProps) {
                        return prayerData.states
                            .map(
                              (state) => state.name,
                            )
                            .toList();
                      },
                      onChanged: (value) {
                        if (value != null) {
                          final stateIsocode = prayerData.states
                              .firstWhere((e) => e.name == value)
                              .isoCode;
                          bloc.add(UpdateStateEvent(stateIsocode));
                          bloc.add(LoadCitiesEvent(
                              prayerData.country, stateIsocode));
                        }
                      },
                    ),

                    // DropdownButton<String>(
                    //   isExpanded: true,
                    //   hint: const Text("Select State"),
                    //   value: prayerData.states.any(
                    //           (stateItem) => stateItem.isoCode == prayerData.state)
                    //       ? prayerData.state
                    //       : null, // Ensures a valid selected state
                    // items: prayerData.states
                    //     .map((stateItem) => DropdownMenuItem(
                    //           value: stateItem.isoCode,
                    //           child: Text(stateItem.name),
                    //         ))
                    //     .toList(),
                    //   onChanged: (value) {
                    //     if (value != null) {
                    // bloc.add(UpdateStateEvent(value));
                    // bloc.add(LoadCitiesEvent(prayerData.country, value));
                    //     }
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    // City Dropdown
                    const Text('Select City:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownSearch(
                      decoratorProps: _decoratorProps,
                      popupProps: _popupProps,
                      dropdownBuilder: (context, selectedItem) => Text(
                        selectedItem ?? "Select city",
                        style: TextStyle(fontSize: 16),
                      ),
                      selectedItem: prayerData.cities.isNotEmpty &&
                              prayerData.cities
                                  .any((city) => city.name == prayerData.city)
                          ? prayerData.city
                          : null, // Ensure the selected city exists,
                      items: (filter, loadProps) {
                        return prayerData.cities
                            .map(
                              (city) => city.name,
                            )
                            .toList();
                      },
                      onChanged: (value) {
                        if (value != null) {
                          bloc.add(UpdateCityEvent(value));
                        }
                      },
                    ),

                    // DropdownButton<String>(
                    //   isExpanded: true,
                    //   hint: const Text("Select City"),
                    //   value: prayerData.cities.isNotEmpty &&
                    //           prayerData.cities
                    //               .any((city) => city.name == prayerData.city)
                    //       ? prayerData.city
                    //       : null, // Ensure the selected city exists
                    //   items: prayerData.cities
                    //       .map((city) => DropdownMenuItem(
                    //             value: city.name,
                    //             child: Text(city.name),
                    //           ))
                    //       .toList(),
                    //   onChanged: (value) {
                    //     if (value != null) {
                    //       bloc.add(UpdateCityEvent(value));
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
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
                                child: method.name == 'turkey'
                                    ? Text('Turkiye')
                                    : Text(method.name),
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
                                child: Text(
                                    index == 0 ? 'Asri-Sani' : 'Asri-Evvel'),
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
                        'Latitude: ${prayerData.latitude.toStringAsFixed(2)}, Longitude: ${prayerData.longitude.toStringAsFixed(2)}'),
                    const SizedBox(height: 30),
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       bloc.add(const SavePrayerSettingsEvent());
                    //       Navigator.pushReplacement(context,
                    //           MaterialPageRoute(builder: (_) => HomeScreen()));
                    //     },
                    //     child: const Text('Save and Continue'),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
