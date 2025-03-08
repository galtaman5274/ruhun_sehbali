import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/prayer/bloc/prayer_bloc.dart';
import 'package:ruhun_sehbali/features/quran/bloc/qari/bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/view/screen_saver.dart';
import '../../adhan/adhan_page.dart';
import '../../quran/view/quran.dart';
import '../../screen_saver/bloc/screen_saver.dart';
import '../../settings/providers/ayine_json_cubit.dart';
import '../../settings/view/settings_screen.dart';
import 'components/home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final locale = context.read<LocaleProvider>().locale;
    context.read<ScreenSaverBloc>().add(ResetInactivityTimer());

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.read<ScreenSaverBloc>().add(ResetInactivityTimer()),
      onPanDown: (_) =>
          context.read<ScreenSaverBloc>().add(ResetInactivityTimer()),
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: [
            NavigationScreen(),
            BlocBuilder<AyineJsonCubit, AyineJsonState>(
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
                  // final prayerBloc = context.read<PrayerBloc>()
                  //   ..add(StartTimerEvent());
                  // final imgUrl = context
                  //     .read<ScreenSaverBloc>()
                  //     .state
                  //     .saverStateData
                  //     .imgUrl;
                   context
                      .read<QariBloc>()
                      .add(LoadQariList(state.fileData.quran));
                  return ScreenSaverView();
                }
                // else if (state is AyineJsonLoadedStorage) {
                //   final images = state.screenSaver.getLocalImages(context
                //       .read<ScreenSaverBloc>()
                //       .state
                //       .saverStateData
                //       .imgUrl);
                //   context.read<ScreenSaverBloc>().add(LoadStorage(images));

                //   return ScreenSaverView(
                //     screenSaver: state.screenSaver,
                //   );
                // }
                return Container();
              },
            )
          ]),
        ),
      ),
    );
  }
}

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});
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
