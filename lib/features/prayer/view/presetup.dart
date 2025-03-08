import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/settings/view/components/azan_radio.dart';
import 'package:ruhun_sehbali/features/settings/view/components/image_url_radio.dart';
import 'package:ruhun_sehbali/features/settings/view/components/locale_dropdown.dart';
import 'package:ruhun_sehbali/features/settings/view/tabs/location_settings.dart';

import '../../home/view/home_screen.dart';
import '../../screen_saver/bloc/screen_saver.dart';
import '../../settings/providers/ayine_json_cubit.dart';
import '../bloc/prayer_bloc.dart';

class PrayerSetupPage extends StatelessWidget {
  const PrayerSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Prayer Times',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Choose interface language',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 50,
                    ),
                    LocaleDropdown(),
                  ],
                ),
                Divider(),
                Text('Prayer settings',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SetupLocation(),
                Divider(),
                Text('Screen saver images',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ImagesUrlSelector(),
                Divider(),
                Text('Select Azan type',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                AzanSelector(),
                Divider(),
                ElevatedButton(
                  onPressed: () {
                    final prayerBloc = context.read<PrayerBloc>()
                    ..add(StartTimerEvent());
                  final imgUrl = context
                      .read<ScreenSaverBloc>()
                      .state
                      .saverStateData
                      .imgUrl;
                    context.read<PrayerBloc>().add(SavePrayerSettingsEvent());
                                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                        context.read<AyineJsonCubit>().saveToStorage(imgUrl,
                       prayerBloc.state.prayerData.azanType);
                  },
                  child: const Text('Save Settings',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )),
      ),
    );
  }
}
