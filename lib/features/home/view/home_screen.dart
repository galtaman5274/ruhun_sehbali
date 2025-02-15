import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';
import 'package:ruhun_sehbali/features/quran/bloc/qari/bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/view/screen_saver.dart';
import 'package:ruhun_sehbali/features/settings/providers/locale_provider.dart';
import '../../adhan/adhan_page.dart';
import '../../quran/view/quran.dart';
import '../../screen_saver/bloc/screen_saver.dart';
import '../../settings/providers/ayine_json_cubit.dart';
import '../../settings/providers/data_models.dart';
import '../../settings/view/settings_screen.dart';
import 'components/home_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.read<LocaleProvider>().locale;
    context.read<ScreenSaverBloc>().add(ResetInactivityTimer(locale.languageCode));

    return BlocListener<AyineJsonCubit, AyineJsonState>(
      listener: (context, state) {
// When JSON is loaded, start downloading images if not already done.
        if (state is AyineJsonLoaded) {
          context.read<AyineJsonCubit>().saveToStorage(locale.languageCode);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => context
            .read<ScreenSaverBloc>()
            .add(ResetInactivityTimer(locale.languageCode)),
        onPanDown: (_) => context
            .read<ScreenSaverBloc>()
            .add(ResetInactivityTimer(locale.languageCode)),
        child: SafeArea(
          child: Scaffold(
            body: BlocBuilder<AyineJsonCubit, AyineJsonState>(
              builder: (context, state) {
                if (state is AyineJsonInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AyineJsonError) {
                  final errorMessage = state.message;
                  if (errorMessage.contains('No internet connection')) {
                    return Center(
                      child: Text(
                          'No internet connection. Please turn on internet.'),
                    );
                  }
                  return Center(
                    child: Text(
                        'An error occurred. Please try again later.\n$errorMessage'),
                  );
                } else if (state is AyineJsonLoaded) {
                  context.read<PrayerBloc>().add(StartTimerEvent());
                  context.read<QariBloc>().add(LoadQariList(state.quran));

                  return Stack(
                    children: [
                      NavigationScreen(
                        alert: state.alert,
                        azanFiles: state.azanFiles,
                        quran: state.quran,
                      ),
                      ScreenSaverView(
                        screenSaver: state.screenSaver,
                      )
                    ],
                  );
                } else if (state is AyineJsonLoadedStorage) {
                  final images =
                      state.screenSaver.getLocalImages(locale.languageCode);
                  context.read<ScreenSaverBloc>().add(LoadStorage(images));

                  return Stack(
                    children: [
                      NavigationScreen(
                        alert: state.alert,
                        azanFiles: state.azanFiles,
                        quran: state.quran,
                      ),
                      ScreenSaverView(
                        screenSaver: state.screenSaver,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationScreen extends StatelessWidget {
  final Alert alert;
  final AzanFiles azanFiles;
  final Quran quran;

  const NavigationScreen({
    super.key,
    required this.alert,
    required this.azanFiles,
    required this.quran,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, localeProvider, child) {
        switch (localeProvider.currentPage) {
          case 'settings':
            return const SettingsPage();
          case 'adhan':
            return const AdhanPage();
          case 'home':
            return const HomePage();
          case 'quran':
            return const QariScreen();
          default:
            return const HomePage();
        }
      },
    );
  }
}
