import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'features/settings/providers/ayine_json_cubit.dart';
import 'features/settings/providers/locale_provider.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Call your JSON comparison function here
    final cubit = AyineJsonCubit(dio: Dio());
    await cubit.compareAndReplaceJson();
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );
  Workmanager().registerPeriodicTask(
    "jsonUpdateTask",
    "jsonUpdateTask",
    frequency: Duration(hours: 24),
  ); // Run every 24 hours
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()..init()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true, // Optional: Enable text adaptation
          builder: (_, child) => const App()),
    );
  }
}
