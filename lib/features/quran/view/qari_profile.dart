import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/quran/view/media_list.dart';
import '../bloc/playlist/bloc.dart';
import 'media_player_page.dart';

class QariProfile extends StatelessWidget {
  final String qariName;
  final Map<String, dynamic> json;

  const QariProfile({super.key, required this.qariName, required this.json});

  @override
  Widget build(BuildContext context) {
    final items =
        json.keys.toList();
    final List<String> urls = [];
    final List<String> names = [];
    final String url = 'https://app.ayine.tv/Ayine/Quran/';
    return Scaffold(
        appBar: AppBar(
          title: Text(qariName),
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
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            json[items[index]].forEach((item) {
              urls.add('$url$qariName/${items[index]}/${item['name']}');
              names.add(item['name']);
            });
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MediaList(
                          quranList: names,
                        )),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${index + 1}'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            items[index],
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          MaterialButton(
                            onPressed: () {
                              // Add the media URL to the playlist
                              context.read<PlaylistBloc>().add(AddMedia(urls));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('$qariName added to playlist')),
                              );
                            },
                            child: Row(
                              children: [
                                Text('Add to p laylist'),
                                Icon(Icons.list)
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text('download'),
                                Icon(Icons.download)
                              ],
                            ),
                          )
                        ],
                      )
                    ]),
              ),
            );
          },
        ));
  }
}
