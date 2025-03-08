import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';
import 'package:ruhun_sehbali/features/settings/view/components/image_url_radio.dart';
import '../../../home/view/home_screen.dart';
import '../../../localization/localization.dart';
import '../../../prayer/bloc/prayer_bloc.dart';
import '../../providers/ayine_json_cubit.dart';
import '../components/azan_radio.dart';

class DownloadFilesTab extends StatelessWidget {
  const DownloadFilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenSaverBloc, ScreenSaverState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.screenSaverImages,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
               
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
                context.read<AyineJsonCubit>().saveToStorage(
                    state.saverStateData.imgUrl, prayerBloc.state.prayerData.azanType);
              },
              child: const Text('Save Settings',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }
}
