import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../settings/providers/data_models.dart';
part 'events.dart';
part 'states.dart';

class QariBloc extends Bloc<QariEvent, QariState> {
  QariBloc() : super(QariInitial()) {
    on<LoadQariList>(_onLoadQariList);
  }

  Future<void> _onLoadQariList(
      LoadQariList event, Emitter<QariState> emit) async {
    emit(QariLoading());
    emit(QariLoaded(event.quranFiles));
  }
}
