part of 'ayine_json_cubit.dart';


abstract class AyineJsonState {}

class AyineJsonInitial extends AyineJsonState {}

class AyineJsonLoaded extends AyineJsonState {
  final Alert alert;
  final AzanFiles azanFiles;
  final Quran quran;
  final ScreenSaver screenSaver;

  AyineJsonLoaded({
    required this.alert,
    required this.azanFiles,
    required this.quran,
    required this.screenSaver,
  });
}
class AyineJsonLoadedStorage extends AyineJsonState {
  final Alert alert;
  final AzanFiles azanFiles;
  final Quran quran;
  final ScreenSaver screenSaver;

  AyineJsonLoadedStorage({
    required this.alert,
    required this.azanFiles,
    required this.quran,
    required this.screenSaver,
  });
}
class AyineJsonError extends AyineJsonState {
  final String message;
  AyineJsonError({required this.message});
}
