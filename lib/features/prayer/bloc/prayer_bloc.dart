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
    on<PrayerTimeAdjustedEvent>(_onPrayerAdjustments);
    on<PrayerWeekDaysEvent>(_onPraterWeedDaysUpdatd);
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
        _secureStorage.getValue('fajr'),
        _secureStorage.getValue('tulu'),
        _secureStorage.getValue('dhuhr'),
        _secureStorage.getValue('asr'),
        _secureStorage.getValue('maghrib'),
        _secureStorage.getValue('isha'),
      ]);

      final country = results[0];
      if (country != null) {
        final currentState = results[1];
        final city = results[2];
        final longitude = double.parse(results[3] ?? '0');
        final latitude = double.parse(results[4] ?? '0');
        final calcMethod = int.parse(results[5] ?? '0');
        final asrIndex = int.parse(results[6] ?? '0');
        final fajr = int.parse(results[7] ?? '0');
        final tulu = int.parse(results[8] ?? '0');
        final dhuhr = int.parse(results[9] ?? '0');
        final asr = int.parse(results[10] ?? '0');
        final maghrib = int.parse(results[11] ?? '0');
        final isha = int.parse(results[12] ?? '0');
        final prayerTimes = PrayerTimes.today(
          Coordinates(latitude, longitude),
          CalculationMethod.values[calcMethod].getParameters()
            ..adjustments.fajr = fajr
            ..adjustments.sunrise = tulu
            ..adjustments.dhuhr = dhuhr
            ..adjustments.asr = asr
            ..adjustments.maghrib = maghrib
            ..adjustments.isha = isha
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

  Future<void> _onPrayerAdjustments(
      PrayerTimeAdjustedEvent event, Emitter<PrayerState> emit) async {
    final PrayerTimes prayerTimes = state.prayerData.prayerTimes
      ..calculationParameters.adjustments.fajr = event.adjustment;
    final updatedData = state.prayerData.copyWith(
      prayerTimes: prayerTimes,
    );

    emit(PrayerDataUpdated(updatedData));
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

    await _secureStorage.saveValue('fajr',
        data.prayerTimes.calculationParameters.adjustments.fajr.toString());
    await _secureStorage.saveValue('tulu',
        data.prayerTimes.calculationParameters.adjustments.sunrise.toString());
    await _secureStorage.saveValue('dhuhr',
        data.prayerTimes.calculationParameters.adjustments.dhuhr.toString());
    await _secureStorage.saveValue('asr',
        data.prayerTimes.calculationParameters.adjustments.asr.toString());
    await _secureStorage.saveValue('maghrib',
        data.prayerTimes.calculationParameters.adjustments.maghrib.toString());
    await _secureStorage.saveValue('isha',
        data.prayerTimes.calculationParameters.adjustments.isha.toString());

    final updatedData = state.prayerData.copyWith(
      prayerTimes: PrayerTimes.today(
        Coordinates(data.latitude, data.longitude),
        CalculationMethod.values[data.calculationMethod.index].getParameters()
          ..adjustments.fajr =
              data.prayerTimes.calculationParameters.adjustments.fajr
          ..adjustments.sunrise =
              data.prayerTimes.calculationParameters.adjustments.sunrise
          ..adjustments.dhuhr =
              data.prayerTimes.calculationParameters.adjustments.dhuhr
          ..adjustments.asr =
              data.prayerTimes.calculationParameters.adjustments.asr
          ..adjustments.maghrib =
              data.prayerTimes.calculationParameters.adjustments.maghrib
          ..adjustments.isha =
              data.prayerTimes.calculationParameters.adjustments.isha
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
      final countryName = state.prayerData.countries
          .firstWhere((e) => e.isoCode == state.prayerData.country)
          .name;
      final stateName = state.prayerData.states
          .firstWhere((e) => e.isoCode == state.prayerData.state)
          .name;
      // final address =
      //     '${event.city}, ${state.prayerData.state}, ${state.prayerData.country}';
      final address = '${event.city}, $stateName, $countryName';
      print('Adress -> $address');
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
    final updatedData = state.prayerData
        .copyWith(states: uniqueStates, state: state.prayerData.state);
    add(LoadCitiesEvent(event.countryCode, state.prayerData.state));
    emit(PrayerDataUpdated(updatedData));
  }

  Future<void> _onLoadCities(
      LoadCitiesEvent event, Emitter<PrayerState> emit) async {
    final cities = await getStateCities(event.countryCode, event.stateCode);
    final uniqueCities = cities.toSet().toList();
    final updatedData = state.prayerData
        .copyWith(cities: uniqueCities, city: state.prayerData.city);
    add(UpdateCityEvent(state.prayerData.city));
    emit(PrayerDataUpdated(updatedData));
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

  void _onPraterWeedDaysUpdatd(
      PrayerWeekDaysEvent event, Emitter<PrayerState> emit) {
    emit(PrayerDataUpdated(
        state.prayerData.copyWith(prayerWeekdays: event.adjustment)));
  }
}
