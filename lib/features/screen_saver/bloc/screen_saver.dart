import 'dart:async';
import 'dart:io';
import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../storage_controller/storage_controller.dart';

part 'event.dart';
part 'states.dart';

/// --- Bloc Implementation ---
class ScreenSaverBloc extends Bloc<ScreenSaverEvent, ScreenSaverState> {
  Timer? _inactivityTimer;
  Timer? _imageChangeTimer;
  final Duration inactivityDuration;
  final StorageController _secureStorage = StorageController();
  ScreenSaverBloc({this.inactivityDuration = const Duration(seconds: 15)})
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

    add(Init());
  }
  void _onInit(Init event, Emitter<ScreenSaverState> emit) async {
    final storedAnimationDuration =
        await _secureStorage.getValue('animationDuration');
    final folderPath = await _secureStorage.getValue('folderPath');
    final txt = await _secureStorage.getValue('full');
    final bool isFull = txt == 'true' ;
    final newAnimationDuration = int.tryParse(storedAnimationDuration ?? '') ??
        state.saverStateData.animationDuration;
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(state.saverStateData.copyWith(
        animationDuration: newAnimationDuration,
        personalImagePath: folderPath,screenSaverFull: isFull)));
  }

  void _onScreenSaverFull(
      ScreenSaverFullEvent event, Emitter<ScreenSaverState> emit) async {
    final txt = event.screenSaverFull ? 'true' : 'false';
    await _secureStorage.saveValue(
      'full',txt
    );
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(screenSaverFull: event.screenSaverFull)));
  }

  void _onUsePersonalImagesFull(
      SetImagesUrlEvent event, Emitter<ScreenSaverState> emit) async {
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(imgUrl: event.imgUrl)));
  }

  void _onSetAnimationDuration(
      SetAnimationDurationEvent event, Emitter<ScreenSaverState> emit) async {
    await _secureStorage.saveValue(
        'animationDuration', event.animationDuration.toString());
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(state.saverStateData
        .copyWith(animationDuration: event.animationDuration)));

    _restartImageChangeTimer();
    // Re-emit the current state with updated data:
  }

  void _onLoadFromStorage(LoadStorage event, Emitter<ScreenSaverState> emit) {
    // Map each local storage image path to an Image widget
    final List<Widget> imageWidgets = event.storageImages.map((item) {
      return Image.file(
        File(item),
        fit: BoxFit.cover,
      );
    }).toList();
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(images: imageWidgets)));
  }

  void _onResetInactivityTimer(
      ResetInactivityTimer event, Emitter<ScreenSaverState> emit) {
    // Cancel any existing timer.
    _inactivityTimer?.cancel();
    _imageChangeTimer?.cancel();
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(
        state.saverStateData.copyWith(showScreenSaver: false)));

    // Restart the timer.
    _inactivityTimer = Timer(inactivityDuration, () {
      add(InactivityTimeout(event.imagesType));
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
    emit(ScreenSaverInitial(state.saverStateData));
    emit(ScreenSaverUpdated(state.saverStateData
        .copyWith(currentIndex: nextIndex, showScreenSaver: true)));
  }

  /// This timer periodically triggers a new image if the screen saver is active.
  void _startImageChangeTimer() {
    _imageChangeTimer?.cancel();
    // We'll run this every (animationDuration + some offset) seconds
    // so that the UI can perform the transition in between.
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
    final folder = Directory(event.folderPath);
    if (folder.existsSync()) {
      final images = folder
          .listSync()
          .where((file) =>
              file.path.endsWith('.jpg') || file.path.endsWith('.png'))
          .map((file) => Image.file(File(file.path)))
          .toList();
      emit(ScreenSaverInitial(state.saverStateData));
      emit(ScreenSaverUpdated(state.saverStateData.copyWith(images: images)));
    } else {
      emit(ScreenSaverInitial(state.saverStateData));
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
