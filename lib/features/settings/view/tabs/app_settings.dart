import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/bloc/screen_saver.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';
import 'package:ruhun_sehbali/features/settings/providers/data_source.dart';
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
              min: 30,
              max: 120,
              divisions: 6,
              label: animationDuration.toString(),
              onChanged: (value) => context
                  .read<ScreenSaverBloc>()
                  .add(SetAnimationDurationEvent(value.toInt())),
            ),
            const SizedBox(height: 20),
            // Text(
            //   context.l10n.screenSaverImages,
            //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // ImagesUrlSelector(),
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
              title: const Text('Turn off display untill tull'),
              trailing: Checkbox(
                  value: state.saverStateData.turnOffDisplay,
                  onChanged: (value) => context
                      .read<ScreenSaverBloc>()
                      .add(TurnOffDisplayEvent(value as bool))),
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
            const SizedBox(height: 20),
            Text(
              'Güncelleme',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ruhun Şehbali uygulamasının yeni versiyonunu kontrol et ve mevcut ise yükle',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String? newVersion = await _checkUpdate();
                    // if (hasUpdate) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog.adaptive(
                        content: Text(newVersion != null
                            ? 'Ruhun Şehbali uygulamasının yeni versiyonu yüklenmiştir.\nUygulamanızı güncellemek ister misiniz?'
                            : 'Yeni güncelleme mevcut değil.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('İPTAL'),
                          ),
                          if (newVersion != null)
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _downloadApk(newVersion);
                              },
                              child: Text('TAMAM'),
                            ),
                        ],
                      ),
                    );
                    // } else {

                    // }
                  },
                  child: Text(
                    'Kontrol et'.toUpperCase(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Future<String?> _checkUpdate() async {
    log('---------- check update has called');
    final dataSource = DataSource(Dio());

    final cubit = AyineJsonCubit(dio: Dio());
    final json = await cubit.getAyineJson();

    String? newVersion;
    if (json != null) {
      final version = (json['UpdateApk'] as Map).entries.last.key;
      log('newVersion in app settings: $newVersion');
      final result = await dataSource.checkVersion(version);
      if (result > 0) {
        newVersion = version;
      }
    }
    return newVersion;
  }

  Future<void> _downloadApk(String newVersion) async {
    final dataSource = DataSource(Dio());
    await dataSource.downloadAndInstallApk(newVersion);
  }
}
