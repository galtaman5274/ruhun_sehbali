import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';

import '../bloc/playlist/bloc.dart';

class MediaList extends StatelessWidget {
  final List<PlaylistItem> quranList;
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
                  Text(quranList[index].name)
                ],
              ),
              trailing: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        context.read<AyineJsonCubit>().onAddMedia(
                            quranList[index].qariName,
                            quranList[index].fileName,
                            quranList[index].name);
                     
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('media added to playlist')),
                        );
                      },
                      child: Row(
                        children: [Text('Add to p laylist'), Icon(Icons.list)],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        context.read<AyineJsonCubit>().saveQuranItemToStorage(
                            quranList[index].qariName,
                            quranList[index].fileName,
                            quranList[index].name);
                      },
                      child: Row(
                        children: [Text('Download'), Icon(Icons.download)],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
