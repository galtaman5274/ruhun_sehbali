part of 'screen_saver.dart';

/// --- Events ---
abstract class ScreenSaverEvent extends Equatable {
  const ScreenSaverEvent();

  @override
  List<Object> get props => [];
}

/// Call this event whenever there is user interaction.
class ResetInactivityTimer extends ScreenSaverEvent {
  final String imagesType;
  const ResetInactivityTimer(this.imagesType);
}

/// This event is triggered by the timer when there’s no activity.
class InactivityTimeout extends ScreenSaverEvent {
  final String imagesType;
  const InactivityTimeout(this.imagesType);
}

class ShowScreenSaver extends ScreenSaverEvent {}

class Init extends ScreenSaverEvent {}

class SetImagesUrlEvent extends ScreenSaverEvent {
  final String imgUrl;
  const SetImagesUrlEvent(this.imgUrl);
}

class SetAnimationDurationEvent extends ScreenSaverEvent {
  final int animationDuration;
  const SetAnimationDurationEvent(this.animationDuration);
}

class LoadStorage extends ScreenSaverEvent {
  final List<String> storageImages;
  const LoadStorage(this.storageImages);
}

class ScreenSaverFullEvent extends ScreenSaverEvent {
  final bool screenSaverFull;
  const ScreenSaverFullEvent(this.screenSaverFull);
}
class TurnOffDisplayEvent extends ScreenSaverEvent {
  final bool turnOffdisplay;
  const TurnOffDisplayEvent(this.turnOffdisplay);
}
class PickFolderEvent
    extends ScreenSaverEvent {} // New event for selecting a folder

class LoadImagesFolder extends ScreenSaverEvent {
  final String folderPath;
  const LoadImagesFolder(this.folderPath);
} // New event for selecting a folder
