part of 'prayer_bloc.dart';

abstract class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends PrayerEvent {}

class StartTimerEvent extends PrayerEvent {}

class LoadNextPrayerEvent extends PrayerEvent {}

class UpdateCountryEvent extends PrayerEvent {
  final String country;
  const UpdateCountryEvent(this.country);

  @override
  List<Object> get props => [country];
}

// Existing events
class UpdateRemainingTimeEvent extends PrayerEvent {
  const UpdateRemainingTimeEvent();

  @override
  List<Object> get props => [];
}

class UpdateStateEvent extends PrayerEvent {
  final String state;
  const UpdateStateEvent(this.state);

  @override
  List<Object> get props => [state];
}

class UpdateCityEvent extends PrayerEvent {
  final String city;
  const UpdateCityEvent(this.city);

  @override
  List<Object> get props => [city];
}

class UpdateCoordinatesEvent extends PrayerEvent {
  final double latitude;
  final double longitude;
  const UpdateCoordinatesEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class UpdateCalculationMethodEvent extends PrayerEvent {
  final CalculationMethod calculationMethod;
  const UpdateCalculationMethodEvent(this.calculationMethod);

  @override
  List<Object> get props => [calculationMethod];
}

class UpdateAsrMethodEvent extends PrayerEvent {
  final int asrMethodIndex;
  const UpdateAsrMethodEvent(this.asrMethodIndex);

  @override
  List<Object> get props => [asrMethodIndex];
}

class SavePrayerSettingsEvent extends PrayerEvent {
  const SavePrayerSettingsEvent();
}

// New events for loading location lists
class LoadCountriesEvent extends PrayerEvent {}

class PrayerTimeAdjustedEvent extends PrayerEvent {
  final int adjustment;
  final String prayerName;
  const PrayerTimeAdjustedEvent(this.adjustment,this.prayerName);
}

class PrayerWeekDaysEvent extends PrayerEvent {
  final String prayer;
  final Map<String, bool> weekDayAdjustment;
  const PrayerWeekDaysEvent(this.weekDayAdjustment, this.prayer);
}

class LoadStatesEvent extends PrayerEvent {
  final String countryCode;
  const LoadStatesEvent(this.countryCode);

  @override
  List<Object> get props => [countryCode];
}

class LoadCitiesEvent extends PrayerEvent {
  final String countryCode;
  final String stateCode;
  const LoadCitiesEvent(this.countryCode, this.stateCode);

  @override
  List<Object> get props => [countryCode, stateCode];
}
