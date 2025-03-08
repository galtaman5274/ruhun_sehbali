import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';

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
              // onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => MediaPlayerPage(url: mp3List[index]))),
            );
          },
        ));
  }
}
