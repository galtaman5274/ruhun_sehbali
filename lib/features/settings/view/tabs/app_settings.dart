import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';
import 'package:ruhun_sehbali/features/settings/view/components/image_url_radio.dart';
import '../../../localization/localization.dart';
import '../components/locale_dropdown.dart';

class AppSettingsTab extends StatelessWidget {
  const AppSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenSaverBloc, ScreenSaverState>(
      builder: (context, state) {
        final animationDuration = state.saverStateData.animationDuration;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.systemLanguage,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            LocaleDropdown(),
            const SizedBox(height: 30),
            Text(
              context.l10n.animationDuration,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Slider(
              value: animationDuration.toDouble(),
              min: 1,
              max: 60,
              divisions: 12,
              label: animationDuration.toString(),
              onChanged: (value) => context
                  .read<ScreenSaverBloc>()
                  .add(SetAnimationDurationEvent(value.toInt())),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.screenSaverImages,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ImagesUrlSelector(),
            ListTile(
              title: const Text('Screen Saver Full screen'),
              trailing: Checkbox(
                  value: state.saverStateData.screenSaverFull,
                  onChanged: (value) => context
                      .read<ScreenSaverBloc>()
                      .add(ScreenSaverFullEvent(value as bool))),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                  'Your personal photos place: ${state.saverStateData.personalImagePath}'),
              trailing: IconButton(
                  onPressed: () {
                    context.read<ScreenSaverBloc>().add(PickFolderEvent());
                  },
                  icon: const Icon(Icons.image_search_sharp)),
            ),
          ],
        );
      },
    );
  }
}
