import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/quran/view/media_list.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';
import '../bloc/playlist/bloc.dart';
import 'media_player_page.dart';

class QariProfile extends StatelessWidget {
  final String qariName;
  final Map<String, dynamic> json;
  final String qariImage;
  final String qariDescription;

  const QariProfile(
      {super.key,
      required this.qariName,
      required this.json,
      required this.qariImage,
      required this.qariDescription});

  @override
  Widget build(BuildContext context) {
    final items = json.keys.toList();

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image(
                    image: AssetImage(
                      qariImage,
                    ),
                    width: 200,
                    height: 200,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          qariDescription,
                          softWrap: true, // Enables text wrapping
                          overflow: TextOverflow.clip,
                        ),
                      ), // Ensures text doesn't overflow),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  //final List<String> urls = [];
                  //final List<String> names = [];
                  final List<PlaylistItem> playList = [];
                  json[items[index]].forEach((item) {
                    playList.add(PlaylistItem(
                      fileName: items[index],
                      qariName: qariName,
                        localPath: item['local'],
                        url: '$url$qariName/${items[index]}/${item['name']}',
                        name: item['name']));
                        
                    // urls.add('$url$qariName/${items[index]}/${item['name']}');
                    // names.add(item['name']);
                  });

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MediaList(
                                quranList: playList,
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
                                    context.read<AyineJsonCubit>().onAddMediaList(qariName, items[index]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '$qariName added to playlist')),
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
                                  onPressed: () {
                                    context
                                        .read<AyineJsonCubit>()
                                        .saveQuranToStorage(
                                            qariName, items[index]);
                                  },
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
              ),
            ),
          ],
        ));
  }
}
