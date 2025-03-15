import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';
import 'package:ruhun_sehbali/features/settings/view/tabs/download_files.dart';

import 'tabs/app_settings.dart';
import 'tabs/location_settings.dart';
import 'tabs/prayer_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int currentIndex = 0;
  void setIndex(int index) => setState(() {
        currentIndex = index;
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            // Left-side menu
            Container(
              width: 250,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  MenuItem(
                    icon: Icons.access_time,
                    section: context.l10n.prayerSettings,
                    index: 0,
                    currentIndex: currentIndex,
                    func: setIndex,
                  ),
                  MenuItem(
                    icon: Icons.settings,
                    section: context.l10n.appSettings,
                    index: 1,
                    currentIndex: currentIndex,
                    func: setIndex,
                  ),
                  MenuItem(
                    icon: Icons.location_on_outlined,
                    section: context.l10n.locationSettings,
                    index: 2,
                    currentIndex: currentIndex,
                    func: setIndex,
                  ),
                  MenuItem(
                    icon: Icons.download,
                    section: 'Download',
                    index: 3,
                    currentIndex: currentIndex,
                    func: setIndex,
                  ),
                ],
              ),
            ),
            Content(
              currentIndex: currentIndex,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<NavigationProvider>().setPage('home'),
        tooltip: 'Go to Home',
        child: const Icon(Icons.home),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.icon,
      required this.section,
      required this.index,
      required this.currentIndex,
      required this.func});
  final IconData icon;
  final String section;
  final int index;
  final currentIndex;
  final Function(int index) func;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          // IconButton(
          //   icon: Icon(icon),
          //   color: currentIndex == index ? Colors.blue : Colors.white,
          //   iconSize: 30.0,
          //   onPressed: () =>context.read<SetupProvider>().setCurrentIndex(index),
          // ),
          TextButton(
              onPressed: () => func(index),
              child: Text(
                section,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IndexedStack(
          index: currentIndex,
          children: [
            const PrayerSettingsTab(),
            const AppSettingsTab(),
            SetupLocation(),
            DownloadFilesTab()
          ],
        ),
      ),
    );
  }
}
