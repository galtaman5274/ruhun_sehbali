// Bloc Classes
part of 'bloc.dart';

abstract class QariEvent {}

class LoadQariList extends QariEvent {
  final Quran quranFiles;
  LoadQariList(this.quranFiles);
}

class SaveQariList extends QariEvent {
  final List<Qari> qariList;
  SaveQariList(this.qariList);
}
