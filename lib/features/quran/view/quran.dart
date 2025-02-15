// qari_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import '../bloc/playlist/bloc.dart';
import '../bloc/qari/bloc.dart';
import 'media_list.dart';
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
            final qariList = state.quranFiles.qariList;
            return ListView.builder(
              itemCount: qariList.length,
              itemBuilder: (context, index) {
                final qariName = qariList[index].name;
                final qariImage = qariList[index].imgAsset;
                // Assume each Qari has a property `mediaUrl` for the audio
                final mediaUrl = qariList[index].imgUrls; 

                return ListTile(
                  leading: Image(
                    image: AssetImage(qariImage),
                    width: 100,
                    height: 100,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MediaList(quranList: qariList[index].imgUrls),
                    ),
                  ),
                  title: Text(qariName),
                  subtitle: const Text('Egypt'),
                  trailing: IconButton(
                    onPressed: () {
                      // Add the media URL to the playlist
                      context.read<PlaylistBloc>().add(AddMedia(mediaUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$qariName added to playlist')),
                      );
                    },
                    icon: const Text('Add to playlist'),
                  ),
                );
              },
            );
          }  else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
