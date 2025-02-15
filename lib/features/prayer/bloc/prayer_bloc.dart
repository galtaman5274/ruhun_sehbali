// import 'dart:async';
// import 'package:adhan/adhan.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:country_state_city/country_state_city.dart';
// import 'package:intl/intl.dart';

// import '../../storage_controller/storage_controller.dart';

// part 'event.dart';
// part 'states.dart';

// class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
//   final StorageController _secureStorage = StorageController();
//   Timer? _remainingTimeTimer;

//   String _timeLeftForNextPrayer = '';

//   String get timeLeftForNextPrayer => _timeLeftForNextPrayer;
//   PrayerBloc() : super(PrayerDataInitial(PrayerData.initial())) {
//     on<UpdateCountryEvent>(_onUpdateCountry);
//     on<UpdateStateEvent>(_onUpdateState);
//     on<UpdateCityEvent>(_onUpdateCity);
//     on<UpdateCoordinatesEvent>(_onUpdateCoordinates);
//     on<UpdateCalculationMethodEvent>(_onUpdateCalculationMethod);
//     on<UpdateAsrMethodEvent>(_onUpdateAsrMethod);
//     on<LoadCountriesEvent>(_onLoadCountries);
//     on<LoadStatesEvent>(_onLoadStates);
//     on<LoadCitiesEvent>(_onLoadCities);
//     on<InitEvent>(_onInitPrayerSettings);
//     on<SavePrayerSettingsEvent>(_onSavePrayerSettings);
//     on<StartTimerEvent>(_onStartTimer);
//    // on<UpdateRemainingTimeEvent>(_onUpdateRemainingTime);
//   }

//   void _onInitPrayerSettings(InitEvent event, Emitter<PrayerState> emit) async {
//     final country = await _secureStorage.getValue('country');
//     if (country != null) {
//       final currentState = await _secureStorage.getValue('state');
//       final city = await _secureStorage.getValue('city');
//       final longitude =
//           double.parse(await _secureStorage.getValue('longitude') ?? '0');
//       final latitude =
//           double.parse(await _secureStorage.getValue('latitude') ?? '0');
//       final calcMethod =
//           int.parse(await _secureStorage.getValue('calcMethod') ?? '0');
//       final asrIndex =
//           int.parse(await _secureStorage.getValue('asrIndex') ?? '0');

//       final prayerTimes = PrayerTimes.today(
//           Coordinates(latitude, longitude),
//           CalculationMethod.values[calcMethod].getParameters()
//             ..madhab = Madhab.values[asrIndex]);

//       final updatedData = state.prayerData.copyWith(
//         country: country,
//         state: currentState,
//         city: city,
//         latitude: latitude,
//         longitude: longitude,
//         prayerTimes: prayerTimes,
//       );

//       emit(PrayerDataUpdated(updatedData));

//       // Start updating the remaining time
//       add(StartTimerEvent());
//     }
//   }

//   DateTime? getNextPrayerTime(DateTime now, List<DateTime> prayerTimesList) {
//     for (var prayerTime in prayerTimesList) {
//       if (prayerTime.isAfter(now)) {
//         return prayerTime;
//       }
//     }
//     return null; // Return null when all prayer times for the day have passed
//   }

//   void _onStartTimer(StartTimerEvent event, Emitter<PrayerState> emit) {
//     final prayerTimesList = [
//       state.prayerData.prayerTimes.fajr,
//       state.prayerData.prayerTimes.sunrise,
//       state.prayerData.prayerTimes.dhuhr,
//       state.prayerData.prayerTimes.asr,
//       state.prayerData.prayerTimes.maghrib,
//       state.prayerData.prayerTimes.isha
//     ];
//      _remainingTimeTimer?.cancel;
//     _remainingTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       final now = DateTime.now();
//       final currentTime = DateFormat('HH:mm').format(now);
//       final currentDate = DateFormat('MMMM d, yyyy').format(now);

//       final upcomingPrayerTime = getNextPrayerTime(now, prayerTimesList);

//       if (upcomingPrayerTime != null) {
//         // Calculate remaining time for the next prayer
//         final remainingDuration = upcomingPrayerTime.difference(now);
//         _timeLeftForNextPrayer = _formatDuration(remainingDuration);
//       } else {
//         // Handle case where all prayers for the day have passed
//         _timeLeftForNextPrayer = _calculateTimeToNextFajr(now);
//       }
//       updatePrayerStatus(now,prayerTimesList);
//       // Emit the updated remaining time
//       final updatedData =
//         state.prayerData.copyWith(remainingTime: _timeLeftForNextPrayer,prayerPassed: state.prayerData.prayerPassed,currentDate: currentDate,currentTime: currentTime);
//     emit(PrayerDataUpdated(updatedData));
//     });
//   }

//   String _calculateTimeToNextFajr(DateTime now) {
//     final tomorrow = now.add(const Duration(days: 1));
//     final nextDayPrayerTimes = PrayerTimes(
//       state.prayerData.prayerTimes.coordinates,
//       DateComponents(tomorrow.year, tomorrow.month, tomorrow.day),
//       state.prayerData.prayerTimes.calculationParameters,
//     );

//     final nextFajrTime = nextDayPrayerTimes.fajr;
//     final remainingDuration = nextFajrTime.difference(now);

//     return _formatDuration(remainingDuration);
//   }

//   String _formatDuration(Duration duration) {
//     return duration.toString().split('.').first.padLeft(8, "0");
//   }

//   // void _onUpdateRemainingTime(
//   //     UpdateRemainingTimeEvent event, Emitter<PrayerState> emit) {
//   //   final updatedData =
//   //       state.prayerData.copyWith(remainingTime: event.duration);
//   //   emit(PrayerDataUpdated(updatedData));
//   // }

//   void _onSavePrayerSettings(
//       SavePrayerSettingsEvent event, Emitter<PrayerState> emit) async {
//     final country = state.prayerData.country;
//     final currentState = state.prayerData.state;
//     final city = state.prayerData.city;
//     final longitude = state.prayerData.longitude;
//     final latitude = state.prayerData.latitude;
//     final calcMethod = state.prayerData.calculationMethod.index;
//     final asrIndex = state.prayerData.asrMethodIndex;

//     await _secureStorage.saveValue('country', country);
//     await _secureStorage.saveValue('state', currentState);
//     await _secureStorage.saveValue('city', city);
//     await _secureStorage.saveValue('longitude', longitude.toString());
//     await _secureStorage.saveValue('latitude', latitude.toString());
//     await _secureStorage.saveValue('calcMethod', calcMethod.toString());
//     await _secureStorage.saveValue('asrIndex', asrIndex.toString());

//     final prayerTimes = PrayerTimes.today(
//         Coordinates(latitude, longitude),
//         CalculationMethod.values[calcMethod].getParameters()
//           ..madhab = Madhab.values[asrIndex]);
//     final updatedData = state.prayerData.copyWith(
//       prayerTimes: prayerTimes,
//     );
//     emit(PrayerDataUpdated(updatedData));
//   }

//   void _onUpdateCountry(UpdateCountryEvent event, Emitter<PrayerState> emit) {
//     final updatedData = state.prayerData.copyWith(country: event.country);
//     emit(PrayerDataUpdated(updatedData));
//   }

//   void _onUpdateState(UpdateStateEvent event, Emitter<PrayerState> emit) {
//     final updatedData = state.prayerData.copyWith(state: event.state);
//     emit(PrayerDataUpdated(updatedData));
//   }

//   void _onUpdateCity(UpdateCityEvent event, Emitter<PrayerState> emit) async {
//     final city = event.city;
//     final currentState = state.prayerData.state;
//     final currentCountry = state.prayerData.country;
//     final updatedData = state.prayerData.copyWith(city: event.city);
//     emit(PrayerDataUpdated(updatedData));

//     try {
//       final address = '$city, $currentState, $currentCountry';
//       final locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         add(UpdateCoordinatesEvent(
//           locations.first.latitude,
//           locations.first.longitude,
//         ));
//       }
//     } catch (e) {
//       print('Error fetching coordinates: $e');
//     }
//   }

//   void _onUpdateCoordinates(
//       UpdateCoordinatesEvent event, Emitter<PrayerState> emit) {
//     final updatedData = state.prayerData.copyWith(
//       latitude: event.latitude,
//       longitude: event.longitude,
//     );
//     emit(PrayerDataUpdated(updatedData));
//   }

//   void _onUpdateCalculationMethod(
//       UpdateCalculationMethodEvent event, Emitter<PrayerState> emit) {
//     final updatedData = state.prayerData.copyWith(
//       calculationMethod: event.calculationMethod,
//     );
//     emit(PrayerDataUpdated(updatedData));
//   }

//   void _onUpdateAsrMethod(
//       UpdateAsrMethodEvent event, Emitter<PrayerState> emit) {
//     final updatedData = state.prayerData.copyWith(
//       asrMethodIndex: event.asrMethodIndex,
//     );
//     emit(PrayerDataUpdated(updatedData));
//   }

//   Future<void> _onLoadCountries(
//       LoadCountriesEvent event, Emitter<PrayerState> emit) async {
//     final countries = await getAllCountries();
//     final uniqueCountries = countries.toSet().toList();
//     final updatedData = state.prayerData.copyWith(countries: uniqueCountries);
//     add(LoadStatesEvent(state.prayerData.country));
//     emit(PrayerDataUpdated(updatedData));
//   }

//   Future<void> _onLoadStates(
//       LoadStatesEvent event, Emitter<PrayerState> emit) async {
//     final states = await getStatesOfCountry(event.countryCode);
//     final uniqueStates = states.toSet().toList();
//     final updatedData = state.prayerData.copyWith(states: uniqueStates);
//     add(LoadCitiesEvent(event.countryCode, uniqueStates.first.isoCode));
//     emit(PrayerDataUpdated(
//         updatedData.copyWith(state: uniqueStates.first.isoCode)));
//   }

//   Future<void> _onLoadCities(
//       LoadCitiesEvent event, Emitter<PrayerState> emit) async {
//     final cities = await getStateCities(event.countryCode, event.stateCode);
//     final uniqueCities = cities.toSet().toList();
//     final updatedData = state.prayerData.copyWith(cities: uniqueCities);
//     add(UpdateCityEvent(uniqueCities.first.name));
//     emit(
//         PrayerDataUpdated(updatedData.copyWith(city: uniqueCities.first.name)));
//   }

//   void updatePrayerStatus(DateTime now, List<DateTime> prayerTimesList) {
//     for (int i = 0; i < prayerTimesList.length; i++) {
//       // Check if current time matches a prayer time exactly
//       // if (now.isAtSameMomentAs(prayerTimesList[i])) {
//       if (now.hour > prayerTimesList[i].hour) {
//         state.prayerData.prayerPassed[i] = true;
//       }
//       if (now.hour == prayerTimesList[i].hour &&
//           now.minute > prayerTimesList[i].minute) {
//         state.prayerData.prayerPassed[i] = true;
//       }
//       if (now.hour == prayerTimesList[i].hour &&
//           now.minute == prayerTimesList[i].minute) {
//         if (!state.prayerData.prayerPassed[i]) {
//           // Play Adhan only if it's the first time reaching this prayer
//           //_playAdhan();
//           state.prayerData.prayerPassed[i] = true;
//         }
//       }
//       // Reset the status for prayers yet to come
//       //   if (prayerTimesList[i].isAfter(now)) {
//       if (prayerTimesList[i].year < now.year ||
//           prayerTimesList[i].month < now.month ||
//           prayerTimesList[i].day < now.day) {
//         state.prayerData.prayerPassed[i] = false;
//       }
//     }
//   }

//   // // Start a timer to check for a new day and reset prayer times if needed
//   // void _startDayChangeTimer() {
//   //   _dayChangeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
//   //     _checkForNewDay();
//   //   });
//   // }

//   // // Check if a new day has started and reset prayer data if true
//   // void _checkForNewDay() {
//   //   final now = DateTime.now();
//   //   final newDate = DateFormat('MMMM d, yyyy').format(now);
//   //   if (newDate != currentDate) {
//   //     setCurrentTime = newDate;
//   //     //_updatePrayerTimes();
//   //     prayerPassed = [false, false, false, false, false, false];
//   //   }
//   // }
// }
import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:country_state_city/country_state_city.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

import '../../storage_controller/storage_controller.dart';

part 'event.dart';
part 'states.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final StorageController _secureStorage = StorageController();
  Timer? _remainingTimeTimer;

  PrayerBloc() : super(PrayerDataInitial(PrayerData.initial())) {
    on<InitEvent>(_onInitPrayerSettings);
    on<UpdateRemainingTimeEvent>(_onUpdateRemainingTime);
    on<StartTimerEvent>(_onStartTimer);
    on<UpdateCountryEvent>(_onUpdateCountry);
    on<UpdateStateEvent>(_onUpdateState);
    on<UpdateCityEvent>(_onUpdateCity);
    on<UpdateCoordinatesEvent>(_onUpdateCoordinates);
    on<UpdateCalculationMethodEvent>(_onUpdateCalculationMethod);
    on<UpdateAsrMethodEvent>(_onUpdateAsrMethod);
    on<SavePrayerSettingsEvent>(_onSavePrayerSettings);
    on<LoadCountriesEvent>(_onLoadCountries);
    on<LoadStatesEvent>(_onLoadStates);
    on<LoadCitiesEvent>(_onLoadCities);
  }

  /// **Load stored prayer settings and initialize prayer times**
  Future<void> _onInitPrayerSettings(
      InitEvent event, Emitter<PrayerState> emit) async {
    try {
      final results = await Future.wait([
        _secureStorage.getValue('country'),
        _secureStorage.getValue('state'),
        _secureStorage.getValue('city'),
        _secureStorage.getValue('longitude'),
        _secureStorage.getValue('latitude'),
        _secureStorage.getValue('calcMethod'),
        _secureStorage.getValue('asrIndex'),
      ]);

      final country = results[0];
      if (country != null) {
        final currentState = results[1];
        final city = results[2];
        final longitude = double.parse(results[3] ?? '0');
        final latitude = double.parse(results[4] ?? '0');
        final calcMethod = int.parse(results[5] ?? '0');
        final asrIndex = int.parse(results[6] ?? '0');

        final prayerTimes = PrayerTimes.today(
          Coordinates(latitude, longitude),
          CalculationMethod.values[calcMethod].getParameters()..adjustments.fajr = 4
            ..madhab = Madhab.values[asrIndex],
        );
        final updatedData = state.prayerData.copyWith(
          country: country,
          state: currentState,
          city: city,
          latitude: latitude,
          longitude: longitude,
          prayerTimes: prayerTimes,
        );

        emit(PrayerDataUpdated(updatedData));
        
        add(StartTimerEvent());
        
      }
    } catch (e) {
      print("Error initializing prayer settings: $e");
    }
  }

  /// **Start a periodic timer that triggers `UpdateRemainingTimeEvent` every second**
  void _onStartTimer(StartTimerEvent event, Emitter<PrayerState> emit) {
    _remainingTimeTimer?.cancel(); // Cancel any existing timer
    _remainingTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateRemainingTimeEvent());
    });
  }

  /// **Calculate and update remaining time for the next prayer**
  void _onUpdateRemainingTime(
      UpdateRemainingTimeEvent event, Emitter<PrayerState> emit) {
    final now = DateTime.now();
    final prayerTimesList = [
      state.prayerData.prayerTimes.fajr,
      state.prayerData.prayerTimes.sunrise,
      state.prayerData.prayerTimes.dhuhr,
      state.prayerData.prayerTimes.asr,
      state.prayerData.prayerTimes.maghrib,
      state.prayerData.prayerTimes.isha
    ];

    final nextPrayerTime = getNextPrayerTime(now, prayerTimesList);
    final remainingTime = nextPrayerTime != null
        ? _formatDuration(nextPrayerTime.difference(now))
        : _calculateTimeToNextFajr(now);

    final updatedData = state.prayerData.copyWith(
      remainingTime: remainingTime,
      currentTime: DateFormat('HH:mm').format(now),
      currentDate: DateFormat('MMMM d, yyyy').format(now),
    );
    updatePrayerStatus(now, prayerTimesList);
    emit(PrayerDataUpdated(updatedData));
  }

  /// **Get the next prayer time**
  DateTime? getNextPrayerTime(DateTime now, List<DateTime> prayerTimesList) {
    for (var prayerTime in prayerTimesList) {
      if (prayerTime.isAfter(now)) {
        return prayerTime;
      }
    }
    return null;
  }

  /// **Calculate time until the next Fajr prayer**
  String _calculateTimeToNextFajr(DateTime now) {
    final tomorrow = now.add(const Duration(days: 1));
    final nextDayPrayerTimes = PrayerTimes(
      state.prayerData.prayerTimes.coordinates,
      DateComponents(tomorrow.year, tomorrow.month, tomorrow.day),
      state.prayerData.prayerTimes.calculationParameters,
    );

    final nextFajrTime = nextDayPrayerTimes.fajr;
    return _formatDuration(nextFajrTime.difference(now));
  }

  /// **Format duration to `HH:mm:ss`**
  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  /// **Save prayer settings to local storage**
  Future<void> _onSavePrayerSettings(
      SavePrayerSettingsEvent event, Emitter<PrayerState> emit) async {
    final data = state.prayerData;
    await _secureStorage.saveValue('country', data.country);
    await _secureStorage.saveValue('state', data.state);
    await _secureStorage.saveValue('city', data.city);
    await _secureStorage.saveValue('longitude', data.longitude.toString());
    await _secureStorage.saveValue('latitude', data.latitude.toString());
    await _secureStorage.saveValue(
        'calcMethod', data.calculationMethod.index.toString());
    await _secureStorage.saveValue('asrIndex', data.asrMethodIndex.toString());

    final updatedData = state.prayerData.copyWith(
      prayerTimes: PrayerTimes.today(
        Coordinates(data.latitude, data.longitude),
        CalculationMethod.values[data.calculationMethod.index].getParameters()
          ..madhab = Madhab.values[data.asrMethodIndex],
      ),
    );

    emit(PrayerDataUpdated(updatedData));
  }

  /// **Event handlers for country, state, and city selection**
  void _onUpdateCountry(UpdateCountryEvent event, Emitter<PrayerState> emit) {
    emit(PrayerDataUpdated(state.prayerData.copyWith(country: event.country)));
  }

  void _onUpdateState(UpdateStateEvent event, Emitter<PrayerState> emit) {
    emit(PrayerDataUpdated(state.prayerData.copyWith(state: event.state)));
  }

  void _onUpdateCity(UpdateCityEvent event, Emitter<PrayerState> emit) async {
    final updatedData = state.prayerData.copyWith(city: event.city);
    emit(PrayerDataUpdated(updatedData));

    try {
      final address =
          '${event.city}, ${state.prayerData.state}, ${state.prayerData.country}';
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        add(UpdateCoordinatesEvent(
          locations.first.latitude,
          locations.first.longitude,
        ));
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
  }

  void _onUpdateCalculationMethod(
      UpdateCalculationMethodEvent event, Emitter<PrayerState> emit) {
    final updatedData = state.prayerData.copyWith(
      calculationMethod: event.calculationMethod,
    );
    emit(PrayerDataUpdated(updatedData));
  }

  void _onUpdateAsrMethod(
      UpdateAsrMethodEvent event, Emitter<PrayerState> emit) {
    final updatedData = state.prayerData.copyWith(
      asrMethodIndex: event.asrMethodIndex,
    );
    emit(PrayerDataUpdated(updatedData));
  }

  Future<void> _onLoadCountries(
      LoadCountriesEvent event, Emitter<PrayerState> emit) async {
    final countries = await getAllCountries();
    final uniqueCountries = countries.toSet().toList();
    final updatedData = state.prayerData.copyWith(countries: uniqueCountries);
    add(LoadStatesEvent(state.prayerData.country));
    emit(PrayerDataUpdated(updatedData));
  }

  Future<void> _onLoadStates(
      LoadStatesEvent event, Emitter<PrayerState> emit) async {
    final states = await getStatesOfCountry(event.countryCode);
    final uniqueStates = states.toSet().toList();
    final updatedData = state.prayerData.copyWith(states: uniqueStates,state: state.prayerData.state);
    add(LoadCitiesEvent(event.countryCode, uniqueStates.first.isoCode));
    emit(PrayerDataUpdated(
        updatedData));
  }

  Future<void> _onLoadCities(
      LoadCitiesEvent event, Emitter<PrayerState> emit) async {
    final cities = await getStateCities(event.countryCode, event.stateCode);
    final uniqueCities = cities.toSet().toList();
    final updatedData = state.prayerData.copyWith(cities: uniqueCities,city: state.prayerData.city);
    add(UpdateCityEvent(uniqueCities.first.name));
    emit(
        PrayerDataUpdated(updatedData));
  }

  void updatePrayerStatus(DateTime now, List<DateTime> prayerTimesList) {
    for (int i = 0; i < prayerTimesList.length; i++) {
      // Check if current time matches a prayer time exactly
      // if (now.isAtSameMomentAs(prayerTimesList[i])) {
      if (now.hour > prayerTimesList[i].hour) {
        state.prayerData.prayerPassed[i] = true;
      }
      if (now.hour == prayerTimesList[i].hour &&
          now.minute > prayerTimesList[i].minute) {
        state.prayerData.prayerPassed[i] = true;
      }
      if (now.hour == prayerTimesList[i].hour &&
          now.minute == prayerTimesList[i].minute) {
        if (!state.prayerData.prayerPassed[i]) {
          // Play Adhan only if it's the first time reaching this prayer
          //_playAdhan();
          state.prayerData.prayerPassed[i] = true;
        }
      }
      // Reset the status for prayers yet to come
      //   if (prayerTimesList[i].isAfter(now)) {
      if (prayerTimesList[i].year < now.year ||
          prayerTimesList[i].month < now.month ||
          prayerTimesList[i].day < now.day) {
        state.prayerData.prayerPassed[i] = false;
      }
    }
  }
  // // Start a timer to check for a new day and reset prayer times if needed
  // void _startDayChangeTimer() {
  //   _dayChangeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
  //     _checkForNewDay();
  //   });
  // }

  // // Check if a new day has started and reset prayer data if true
  // void _checkForNewDay() {
  //   final now = DateTime.now();
  //   final newDate = DateFormat('MMMM d, yyyy').format(now);
  //   if (newDate != currentDate) {
  //     setCurrentTime = newDate;
  //     //_updatePrayerTimes();
  //     prayerPassed = [false, false, false, false, false, false];
  //   }
  // }
  void _onUpdateCoordinates(
      UpdateCoordinatesEvent event, Emitter<PrayerState> emit) {
    emit(PrayerDataUpdated(state.prayerData.copyWith(
      latitude: event.latitude,
      longitude: event.longitude,
    )));
  }
}
