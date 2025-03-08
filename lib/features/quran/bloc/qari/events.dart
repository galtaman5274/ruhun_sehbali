// Bloc Classes
part of 'bloc.dart';

abstract class QariEvent {}

class LoadQariList extends QariEvent {
  final Map<String, dynamic> quranFiles;
  LoadQariList(this.quranFiles);
}

class SaveQariList extends QariEvent {
  final List<Qari> qariList;
  SaveQariList(this.qariList);
}
