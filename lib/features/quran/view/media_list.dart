import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';

import '../bloc/playlist/bloc.dart';

class MediaList extends StatelessWidget {
  final List<String> quranList;
  const MediaList({super.key, required this.quranList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Media List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<NavigationProvider>().setPage('home'),
          tooltip: 'Go to Home',
          child: const Icon(Icons.home),
        ),
        body: ListView.builder(
          itemCount: quranList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  Text('${index + 1}'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(quranList[index])
                ],
              ),
              trailing: MaterialButton(
                onPressed: () {
                  // Add the media URL to the playlist
                  final playerState = context.read<PlaylistBloc>();
                  playerState.add(AddMedia(
                      playerState.state.playlist..add(quranList[index])));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('media added to playlist')),
                  );
                },
                child: Row(
                  children: [Text('Add to p laylist'), Icon(Icons.list)],
                ),
              ),
            );
          },
        )
        );
  }
}
