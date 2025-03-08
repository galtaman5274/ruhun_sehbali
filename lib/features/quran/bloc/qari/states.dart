part of 'bloc.dart';

abstract class QariState {}

class QariInitial extends QariState {}

class QariLoading extends QariState {}

class QariLoaded extends QariState {
  final Map<String, dynamic> quranFiles;
  QariLoaded(this.quranFiles);
}

class QariError extends QariState {
  final String message;
  QariError(this.message);
}
