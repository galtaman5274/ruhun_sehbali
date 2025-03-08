import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage_controller/storage_controller.dart';

part 'event.dart';
part 'states.dart';

const _storedDataKey = "stored_files_data";

/// --- Bloc Implementation ---
class ScreenSaverBloc extends Bloc<ScreenSaverEvent, ScreenSaverState> {
  Timer? _inactivityTimer;
  Timer? _imageChangeTimer;

  final StorageController _secureStorage = StorageController();
  ScreenSaverBloc()
      : super(ScreenSaverInitial(ScreenSaverStateData.initial())) {
    on<ResetInactivityTimer>(_onResetInactivityTimer);
    on<InactivityTimeout>(_onInactivityTimeout);
    on<ShowScreenSaver>(_onShowScreenSaver);
    on<LoadStorage>(_onLoadFromStorage);
    on<Init>(_onInit);
    on<SetAnimationDurationEvent>(_onSetAnimationDuration);
    on<SetImagesUrlEvent>(_onUsePersonalImagesFull);
    on<ScreenSaverFullEvent>(_onScreenSaverFull);
    on<LoadImagesFolder>(_loadImagesFromFolder);
    on<PickFolderEvent>(_pickFolder);
    on<TurnOffDisplayEvent>(_onTurnOffDisplay);
    add(Init());
  }
  void _onInit(Init event, Emitter<ScreenSaverState> emit) async {
    final storedAnimationDuration =
        await _secureStorage.getValue('animationDuration');
    final folderPath = await _secureStorage.getValue('folderPath');
    final txt = await _secureStorage.getValue('full') ?? 'true';
    final bool isFull = txt == 'true';
    final display = await _secureStorage.getValue('displayOff') ?? 'true';
    final bool displayOff = display == 'true';
    final newAnimationDuration =
        int.tryParse(storedAnimationDuration ?? '30') ??
            state.saverStateData.animationDuration;
    final imgUrl = await _secureStorage.getValue('imgUrl');
    //emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(state.saverStateData.copyWith(
        animationDuration: newAnimationDuration,
        personalImagePath: folderPath,
        screenSaverFull: isFull,
        turnOffDisplay: displayOff,
        imgUrl: imgUrl)));
  }

  void _onScreenSaverFull(
      ScreenSaverFullEvent event, Emitter<ScreenSaverState> emit) async {
    final txt = event.screenSaverFull ? 'true' : 'false';
    await _secureStorage.saveValue('full', txt);

    //emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(screenSaverFull: event.screenSaverFull)));
  }

  void _onTurnOffDisplay(
      TurnOffDisplayEvent event, Emitter<ScreenSaverState> emit) async {
    final txt = event.turnOffdisplay ? 'true' : 'false';
    await _secureStorage.saveValue('displayOff', txt);

    //emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(turnOffDisplay: event.turnOffdisplay)));
  }

  void _onUsePersonalImagesFull(
      SetImagesUrlEvent event, Emitter<ScreenSaverState> emit) async {
    //emit(ScreenSaverInitial(state.saverStateData));
    await _secureStorage.saveValue('imgUrl', event.imgUrl);
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(imgUrl: event.imgUrl)));
  }

  void _onSetAnimationDuration(
      SetAnimationDurationEvent event, Emitter<ScreenSaverState> emit) async {
    await _secureStorage.saveValue(
        'animationDuration', event.animationDuration.toString());
    //emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(state.saverStateData
        .copyWith(animationDuration: event.animationDuration)));

    _restartImageChangeTimer();
    // Re-emit the current state with updated data:
  }

  void _onLoadFromStorage(
      LoadStorage event, Emitter<ScreenSaverState> emit) async {
    if (state.saverStateData.imgUrl == 'own') {
      add(LoadImagesFolder());
    } else {
      final storedJson = await _secureStorage.getValue(_storedDataKey);

      final Map<String, dynamic> storedData = storedJson != null
          ? Map<String, dynamic>.from(jsonDecode(storedJson))
          : <String, dynamic>{}; // Initialize as empty Map<String, dynamic>

      if (storedData['ScreenSaver']
              [state.saverStateData.imgUrl] != null)
              {final List<Widget> imageWidgets = storedData['ScreenSaver']
              [state.saverStateData.imgUrl]
          .map<Widget>((item) {
        return Image.file(
          File(item['local']),
          fit: BoxFit.cover,
        );
      }).toList();
      emit(ScreenSaverUpdated(
          state.saverStateData.copyWith(images: imageWidgets)));}
    }
  }

  void _onResetInactivityTimer(
      ResetInactivityTimer event, Emitter<ScreenSaverState> emit) {
    // Cancel any existing timer.
    _inactivityTimer?.cancel();
    _imageChangeTimer?.cancel();
    //emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(showScreenSaver: false)));
    // Restart the timer.
    _inactivityTimer =
        Timer(Duration(seconds: state.saverStateData.animationDuration), () {
      add(InactivityTimeout());
    });
  }

  void _onInactivityTimeout(
      InactivityTimeout event, Emitter<ScreenSaverState> emit) {
    _restartImageChangeTimer();
  }

  void _onShowScreenSaver(
      ShowScreenSaver event, Emitter<ScreenSaverState> emit) {
    final nextIndex = state.saverStateData.currentIndex <
            state.saverStateData.images.length - 1
        ? state.saverStateData.currentIndex + 1
        : 0;
    //emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(state.saverStateData
        .copyWith(currentIndex: nextIndex, showScreenSaver: true)));
  }

  /// This timer periodically triggers a new image if the screen saver is active.
  void _startImageChangeTimer() {
    _imageChangeTimer?.cancel();
    add(LoadStorage());

    _imageChangeTimer = Timer.periodic(
      Duration(seconds: state.saverStateData.animationDuration + 2),
      (timer) {
        add(ShowScreenSaver());
      },
    );
  }

  void _restartImageChangeTimer() {
    _imageChangeTimer?.cancel();
    _startImageChangeTimer();
  }

  Future<void> _pickFolder(
      PickFolderEvent event, Emitter<ScreenSaverState> emit) async {
    String? folderPath = await FilePicker.platform.getDirectoryPath();
    _secureStorage.saveValue('folderPath', folderPath as String);
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(personalImagePath: folderPath)));
  }

  /// Load images from the selected folder
  Future<void> _loadImagesFromFolder(
      LoadImagesFolder event, Emitter<ScreenSaverState> emit) async {
    final folder = Directory(state.saverStateData.personalImagePath);
    if (folder.existsSync()) {
      final images = folder
          .listSync()
          .where((file) =>
              file.path.endsWith('.jpg') || file.path.endsWith('.png'))
          .map((file) => Image.file(File(file.path)))
          .toList();
      //emit(ScreenSaverInitial(state.saverStateData));
      emit(ScreenSaverUpdated(state.saverStateData.copyWith(images: images)));
    } else {
      //emit(ScreenSaverInitial(state.saverStateData));
      emit(ScreenSaverUpdated(state.saverStateData));
    }
  }

  @override
  Future<void> close() {
    _inactivityTimer?.cancel();
    _imageChangeTimer?.cancel();
    return super.close();
  }
}
