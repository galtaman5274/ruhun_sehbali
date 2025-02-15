import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';

import 'app.dart';
import 'features/settings/providers/locale_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LocaleProvider()),
        ChangeNotifierProvider(create: (_)=>NavigationProvider()),
      ],
      child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true, // Optional: Enable text adaptation
            builder: (_, child) => const App()),
    );
  }
}