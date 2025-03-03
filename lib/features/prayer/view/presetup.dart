import 'package:flutter/material.dart';
import 'package:ruhun_sehbali/features/settings/view/components/locale_dropdown.dart';
import 'package:ruhun_sehbali/features/settings/view/tabs/location_settings.dart';

class PrayerSetupPage extends StatelessWidget {
  const PrayerSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Prayer Times'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LocaleDropdown(),
                SetupLocation(),
              ],
            )),
      ),
    );
  }
}
