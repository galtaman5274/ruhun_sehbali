// qari_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/quran/view/qari_profile.dart';
import 'package:ruhun_sehbali/features/settings/providers/data_models.dart';
import '../bloc/qari/bloc.dart';
import 'media_player_page.dart'; // see below

class QariScreen extends StatelessWidget {
  const QariScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qari List'),
        actions: [
          const Text('Open Playlist'),
          IconButton(
            onPressed: () {
              // Navigate to the media player page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MediaPlayerPage()),
              );
            },
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<NavigationProvider>().setPage('home'),
        tooltip: 'Go to Home',
        child: const Icon(Icons.home),
      ),
      body: BlocBuilder<QariBloc, QariState>(
        builder: (context, state) {
          if (state is QariLoaded) {
            // Get the qariList from your state

            final json = state.quranFiles;
            final keys = json.keys
                // .where((value) => int.tryParse(value) == null)
                .toList();
            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final qariName = keys[index];
                final qariImage = Quran.qariImages[index];
                // Assume each Qari has a property `mediaUrl` for the audio
                // final mediaUrl = state.quranFiles.qariList[0].imgUrls;
                // print(mediaUrl);
                return ListTile(
                  leading: Image(
                    image: AssetImage(qariImage),
                    width: 100,
                    height: 100,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (_) => MediaList(quranList: qariList[index].imgUrls,mp3List: qariList[index].mp3Names,),
                      builder: (_) => QariProfile(
                        qariName: qariName,
                        json: json[qariName],
                      ),
                    ),
                  ),
                  title: Text(qariName),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
