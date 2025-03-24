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
    final List<String> qariDescriptions = [
      "Muhammad Siddiq al-Minshawi, (January 1, 1920 - June 20, 1969) was an Egyptian Quranic reciter par excellence and was not in need of any introduction. \nHe was the able son of the great Sheikh Siddiq al-Minshawi and his brother Sheikh Mahmoud Al-Minshawi is also an eminent Quran reciter.\nSheikh Muhammad Siddiq al-Minshawi was a protegé of the esteemed Sheikh Mohammed Salamah, who was himself a great reciter of the 20th century. \nHe studied Ilm e Tajweed under the guidance of the distinguished Sheikh Ibrahim As-Su'udi at a very young age.\nSheikh Muhammad Siddiq al-Minshawi has visited many countries, including Indonesia, Jordan, Kuwait, Libya, Palestine (Al-Aqsa Mosque), \nSaudi Arabia and Syria, for the enhancement and propagation of Deer",
      "His full name is Muharmed-Muhammed Al Said Hassanein; he was born in the village of Tahoria and is one of the famous reciters of the Holy Quran in Egypt.\nKnown as Shaykh Jebreel; he learntthe Quran at the age of 9 and won a number of national and international competitions of Quran recitation. \nHe studied at Al-Azhar University and received a B.A in Sharia and Law; he also went to the University of Jordan and worked as a lecturer and \nauthor of some religious programs for the Jordanian television.Since 1988 and during the holy month of Ramadan, \nappointed as supervisor of the establishment of the dnkh Jebril has led the Tarawih prayers at the Amru Ibnu Aass mosque in Egypt. \nHe was also Tional Islamic Center of Quranic Sciences in Cairo.To conclude, Shaykh Jebreel has a number prominent TV shows breadcasted on various Egyptian \nChannels such as Verses and Prayers, Allah@s loved ones, in addition to recordings of his recitation of the Quran.",
      "One of the most known Quran readers in Egypt. Sheikh Mustafa lsmall was born in June 17, 1905 in the small village of 'Mit Ghazal' in the center of \n Sheikh Mustafa Ismail was able to complete the memorization of the Holy Quran in his village at the age of twelve years old, and then he joined \n'Al Ahmadi' mosque in 'Tanta' to master the sciences of Quran readings and 'Tajweed'. Sheikh 'Mohamed Refaat' had predicted for him a very \nbright future after having listened to his 'Tilawat' and reading methods. At first, Sheikh Mustafa Ismail became \nfamous in all parts of 'Al Gharbiya' province and neighboring provinces before one of his friends advised him to go to 'Cairo' to try \nhis luck there. He also had the chance to recite the holy Quran in a big celebration due to the absence of Sheikh Abdelfatah Al Shaashai Sheikh Mustafa Ismail \nwas appointed as a reader of the Holy Quran in the royal palace during the reign of Farouk I, \nand thanks to that, he became famous in various Arab and Muslim countries.Sheikh Mustafa Ismail passed away on Friday, 12 December, 1978.",
    ];
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
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                // Set height
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  border: Border.all(
                    color: Colors.grey, // Grey border
                    width: 2, // Border width
                  ),
                  borderRadius:
                      BorderRadius.circular(10), // Optional: Rounded corners
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey, // Set color
                    thickness: 1, // Set thickness
                  ),
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final qariName = keys[index];
                    final qariImage = Quran.qariImages[index];
                    // Assume each Qari has a property `mediaUrl` for the audio
                    // final mediaUrl = state.quranFiles.qariList[0].imgUrls;
                    // print(mediaUrl);
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ListTile(
                        leading: Image(
                          image: AssetImage(
                            qariImage,
                          ),
                          width: 100,
                          height: 100,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (_) => MediaList(quranList: qariList[index].imgUrls,mp3List: qariList[index].mp3Names,),
                            builder: (_) => QariProfile(
                              qariDescription:
                                  index != 3 ? qariDescriptions[index] : '',
                              qariImage: qariImage,
                              qariName: qariName,
                              json: json[qariName],
                            ),
                          ),
                        ),
                        title: Text(qariName),
                        subtitle: Row(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/qari/egypt_flag.png',
                              ),
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Egypt'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
