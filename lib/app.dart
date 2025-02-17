import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';
import 'package:ruhun_sehbali/features/prayer/view/presetup.dart';
import 'package:ruhun_sehbali/features/quran/bloc/qari/bloc.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';
import 'package:ruhun_sehbali/features/settings/providers/locale_provider.dart';
import 'features/home/view/home_screen.dart';
import 'features/localization/localization.dart';
import 'features/quran/bloc/playlist/bloc.dart';
import 'features/screen_saver/bloc/screen_saver.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AyineJsonCubit(dio: Dio())..checkForAyineJson()),
          BlocProvider(
            create: (_) =>
                ScreenSaverBloc(),
          ),
          BlocProvider( create: (_) => PrayerBloc()..add(InitEvent())),
          BlocProvider( create: (_) => PlaylistBloc()),
          BlocProvider( create: (_) => QariBloc()),

        ],
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            return MaterialApp(
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: localeProvider.locale, // Locale provided via Consumer
              title: 'Azan',
              debugShowCheckedModeBanner: false,
              home: AppStart(), // Your home screen widget
            );
          },
        ));
  }
}

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<AyineJsonCubit>().checkIfSetupRequired(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
                child: Text('An error occurred. Please try again later.')),
          );
        } else if (snapshot.data == true) {
          return const PrayerSetupPage(); // Show Setup Page if settings are missing
        } else {
          return const HomeScreen(); // Show Main Page if settings are found
        }
      },
    );
  }
}
