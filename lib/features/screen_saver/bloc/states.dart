part of 'screen_saver.dart';

abstract class ScreenSaverState extends Equatable {
  final ScreenSaverStateData saverStateData;
  const ScreenSaverState(this.saverStateData);

  @override
  List<Object> get props => [saverStateData];
}

class ScreenSaverInitial extends ScreenSaverState {
  const ScreenSaverInitial(super.saverStateData);
}

class ScreenSaverUpdated extends ScreenSaverState {
  const ScreenSaverUpdated(super.saverStateData);
}

class ScreenSaverStateData extends Equatable {
  
  final String currentScreen;
  final bool showScreenSaver;
  final bool turnOffDisplay;
  final int
      animationDuration; // The time to show each image or run an animation
  final int inactivityTime; // Time before screensaver kicks in
  final List<Widget> images;
  final int currentIndex;
  final String currentAnimationType; // e.g., fade, scale, rotation
  final bool screenSaverFull;
  final String imgUrl;
  final String personalImagePath;

  const ScreenSaverStateData(
      {required this.currentScreen,
      required this.showScreenSaver,
      required this.animationDuration,
      required this.inactivityTime,
      required this.images,
      required this.currentIndex,
      required this.currentAnimationType,
      required this.screenSaverFull,
      required this.imgUrl,
      required this.personalImagePath,
      required this.turnOffDisplay
      });

  // Initial State
  factory ScreenSaverStateData.initial() {
    return const ScreenSaverStateData(
        currentScreen: 'home',
        turnOffDisplay: false,
        showScreenSaver: false,
        animationDuration: 30,
        inactivityTime: 30,
        images: [
          Image(
            image: AssetImage('assets/screen_savers/tr/1-allah.jpg'),
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          Image(
            image: AssetImage('assets/screen_savers/tr/2-rahman.jpg'),
            fit: BoxFit.fill,
            width: double.infinity,
          )
        ],
        currentIndex: 0,
        currentAnimationType: 'fade',
        screenSaverFull: true,
        imgUrl: 'tr',
        personalImagePath: '',
        );
  }

  ScreenSaverStateData copyWith(
      {String? currentScreen,
      bool? showScreenSaver,
      int? animationDuration,
      int? inactivityTime,
      List<Widget>? images,
      int? currentIndex,
      String? currentAnimationType,
      bool? screenSaverFull,
      String? imgUrl,
      String? personalImagePath,
      bool? turnOffDisplay
      }) {
    return ScreenSaverStateData(
        currentScreen: currentScreen ?? this.currentScreen,
        showScreenSaver: showScreenSaver ?? this.showScreenSaver,
        animationDuration: animationDuration ?? this.animationDuration,
        inactivityTime: inactivityTime ?? this.inactivityTime,
        images: images ?? this.images,
        currentIndex: currentIndex ?? this.currentIndex,
        currentAnimationType: currentAnimationType ?? this.currentAnimationType,
        screenSaverFull: screenSaverFull ?? this.screenSaverFull,
        imgUrl: imgUrl ?? this.imgUrl,
        personalImagePath: personalImagePath ?? this.personalImagePath,
        turnOffDisplay: turnOffDisplay ?? this.turnOffDisplay
        
        );
  }

  @override
  List<Object> get props => [
        currentScreen,
        showScreenSaver,
        animationDuration,
        inactivityTime,
        images,
        currentIndex,
        currentAnimationType,
        screenSaverFull,
        imgUrl,
        personalImagePath,
        turnOffDisplay
      ];
}
