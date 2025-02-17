part of 'prayer_bloc.dart';

abstract class PrayerState extends Equatable {
  final PrayerData prayerData;
  const PrayerState(this.prayerData);

  @override
  List<Object> get props => [prayerData];
}

class PrayerDataInitial extends PrayerState {
  const PrayerDataInitial(super.prayerData);
}
class PrayerDataUpdated extends PrayerState {
  const PrayerDataUpdated(super.prayerData);
}



class PrayerData extends Equatable {
  final String country;
  final String state;
  final String city;
  final double latitude;
  final double longitude;
  final CalculationMethod calculationMethod;
  final int asrMethodIndex;
  final List<Country> countries;
  final List<State> states;
  final List<City> cities;
  final Map<String, Map<String,bool>> prayerWeekdays;
  final PrayerTimes prayerTimes;
  final String remainingTime;
 final List<bool> prayerPassed; 
 final String currentTime;
  final String currentDate;

  const PrayerData({
    required this.country,
    required this.state,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.calculationMethod,
    required this.asrMethodIndex,
    required this.countries,
    required this.states,
    required this.cities,
    required this.prayerTimes,
    required this.prayerWeekdays,
    required this.remainingTime,
    required this.prayerPassed,
    required this.currentDate,
    required this.currentTime
  });

  factory PrayerData.initial() {
    final prayerTimes = PrayerTimes.today(Coordinates(40.7128, 74.0060), CalculationMethod.turkey.getParameters()..madhab = Madhab.hanafi);
    return PrayerData(
      country: 'US',
      state: '',
      city: '',
      latitude: 0.0,
      longitude: 0.0,
      calculationMethod: CalculationMethod.turkey,
      asrMethodIndex: 0,
      countries: const [],
      states: const [],
      cities: const [],
      prayerTimes: prayerTimes,
      prayerWeekdays: {
        'fajr': {'Monday':true,'Tuesday':true,'Wednesday':true,'Thursday':true,'Friday':true,'Saturday':true,'Sunday':true,},
        'tulu': {'Monday':true,'Tuesday':true,'Wednesday':true,'Thursday':true,'Friday':true,'Saturday':true,'Sunday':true,},
        'dhuhr':{'Monday':true,'Tuesday':true,'Wednesday':true,'Thursday':true,'Friday':true,'Saturday':true,'Sunday':true,},
        'asr': {'Monday':true,'Tuesday':true,'Wednesday':true,'Thursday':true,'Friday':true,'Saturday':true,'Sunday':true,},
        'magrib': {'Monday':true,'Tuesday':true,'Wednesday':true,'Thursday':true,'Friday':true,'Saturday':true,'Sunday':true,},
        'isha': {'Monday':true,'Tuesday':true,'Wednesday':true,'Thursday':true,'Friday':true,'Saturday':true,'Sunday':true,},},
      remainingTime: '',
      prayerPassed: [
    false,
    false,
    false,
    false,
    false,
    false
  ],
  currentDate: '',
  currentTime: ''
    );
  }

  PrayerData copyWith({
    String? country,
    String? state,
    String? city,
    double? latitude,
    double? longitude,
    CalculationMethod? calculationMethod,
    int? asrMethodIndex,
    List<Country>? countries,
    List<State>? states,
    List<City>? cities,
    PrayerTimes? prayerTimes,
    Map<String, Map<String,bool>>? prayerWeekdays,
    String? remainingTime,
    List<bool>? prayerPassed,
        String? currentDate,
    String? currentTime,

  }) {
    return PrayerData(
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      asrMethodIndex: asrMethodIndex ?? this.asrMethodIndex,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      prayerWeekdays: prayerWeekdays ?? this.prayerWeekdays,
      remainingTime: remainingTime ?? this.remainingTime,
      prayerPassed: prayerPassed ?? this.prayerPassed,
      currentDate: currentDate ?? this.currentDate,
      currentTime: currentTime ?? this.currentTime
    );
  }

  @override
  List<Object> get props => [
        country,
        state,
        city,
        latitude,
        longitude,
        calculationMethod,
        asrMethodIndex,
        countries,
        states,
        cities,
        prayerTimes,
        prayerWeekdays,
        remainingTime,
      ];
}
