class AlertItem {
  final String name;
  final int lastModified;

  const AlertItem({
    required this.name,
    required this.lastModified,
  });

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    return AlertItem(
      name: json['name'] as String,
      lastModified: json['last_modified'] is int
          ? json['last_modified'] as int
          : int.tryParse(json['last_modified'].toString()) ?? 0,
    );
  }
}

class Alert {
  final List<AlertItem> alerts;

  const Alert({required this.alerts});

  /// Expects the JSON to be a list of objects.
  factory Alert.fromJson(List<dynamic> json) {
    return Alert(
      alerts: json.map((e) => AlertItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

/// --------------------
/// AZAN FILES
/// --------------------

class AzanFiles {
  final Map<String, List<String>> arabic;
  final Map<String, List<String>> egyptian;
  final Map<String, List<String>> turkish;
  static String url = 'https://app.ayine.tv/Ayine/AzanFiles/';

  const AzanFiles({
    required this.arabic,
    required this.egyptian,
    required this.turkish,
  });

  factory AzanFiles.fromJson(Map<String, dynamic> json) {
    return AzanFiles(
      arabic: tidyUp(json['Arabic'], 'Arabic') ?? {},
      egyptian: tidyUp(json['Egyptian'], 'Egyptian') ?? {},
      turkish: tidyUp(json['Turkish'], 'Turkish') ?? {},
    );
  }

  /// Converts each prayer time list into a map with URL paths.
  static Map<String, List<String>>? tidyUp(
    Map<String, dynamic> json,
    String urlType,
  ) =>
      {
        '01-Fajr': List<Map<String,dynamic>>.from(json['01-Fajr'])
            .map((item) => '$url/$urlType/01-Fajr/${item['name']}')
            .toList(),
        '02-Tulu': List<Map<String,dynamic>>.from(json['02-Tulu'])
            .map((item) => '$url/$urlType/02-Tulu/${item['name']}')
            .toList(),
        '03-Dhuhr': List<Map<String,dynamic>>.from(json['03-Dhuhr'])
            .map((item) => '$url/$urlType/03-Dhuhr/${item['name']}')
            .toList(),
        '04-Asr': List<Map<String,dynamic>>.from(json['04-Asr'])
            .map((item) => '$url/$urlType/04-Asr/${item['name']}')
            .toList(),
        '05-Maghrib': List<Map<String,dynamic>>.from(json['05-Maghrib'])
            .map((item) => '$url/$urlType/05-Maghrib/${item['name']}')
            .toList(),
        '06-Isha': List<Map<String,dynamic>>.from(json['06-Isha'])
            .map((item) => '$url/$urlType/06-Isha/${item['name']}')
            .toList(),
        '07-Suhoor': List<Map<String,dynamic>>.from(json['07-Suhoor'])
            .map((item) => '$url/$urlType/07-Suhoor/${item['name']}')
            .toList(),
        '08-Iftar': List<Map<String,dynamic>>.from(json['08-Iftar'])
            .map((item) => '$url/$urlType/08-Iftar/${item['name']}')
            .toList(),
      };
}

/// --------------------
/// QURAN
/// --------------------

class Quran {
    final List<Qari> qariList;
  static const String url = 'https://app.ayine.tv/Ayine/Quran';

  static const List<String> qariNames = [
    'Muhammad Siddiq Minshawi',
    'Muhammed Jibril',
    'Mustafa Ismail'
  ];

  static const List<String> qariImages = [
    'assets/qari/Muhammad_Siddiq_Minshawi.jpeg',
    'assets/qari/Muhammed_Jibril.jpeg',
    'assets/qari/Mustafa_Ismail.jpeg'
  ];

  Quran({required this.qariList});

  factory Quran.fromJson(Map<String, dynamic> json) {
    final qariList = List.generate(qariNames.length, (i) {
      final name = qariNames[i];
      return Qari(
        name: name,
        imgAsset: qariImages[i],
        imgUrls: prepareUrl(json, name),
      );
    });
    return Quran(qariList: qariList);
  }

  /// Expects each qari's section to have a 'Hatim' list.
  static List<String> prepareUrl(Map<String, dynamic> json, String name) {
    return List<Map<String,dynamic>>.from(json[name]['Hatim']).map((item) => '$url/$name/Hatim/${item['name']}').toList();
 
  }
}

class Qari {
  final String name;
  final String imgAsset;
  final List<String> imgUrls;

  Qari({required this.name, required this.imgAsset, required this.imgUrls});
}

/// --------------------
/// SCREEN SAVER
/// --------------------

class ScreenSaver {
  final Map<String, dynamic> screens;
  final List<String> us;
  final List<String> ar;
  final List<String> de;
  final List<String> tr;
  final List<String> midnight;

  List<String> usLocal = [];
  List<String> arLocal = [];
  List<String> deLocal = [];
  List<String> trLocal = [];
  List<String> midnightLocal = [];

  static String url = 'https://app.ayine.tv/Ayine/ScreenSaver';

  ScreenSaver({required this.screens})
      : us = prepareUrl(screens, 'us'),
        ar = prepareUrl(screens, 'ar'),
        de = prepareUrl(screens, 'de'),
        midnight = prepareUrl(screens, 'midnight'),
        tr = prepareUrl(screens, 'tr');

  factory ScreenSaver.fromJson(Map<String, dynamic> json) {
    return ScreenSaver(screens: json);
  }

  /// Converts a list of file names to full URLs.
  static List<String> prepareUrl(Map<String, dynamic> json, String name) {
   return List<Map<String, dynamic>>.from(json[name]).map((item) => '$url/$name/${item['name']}').toList();
  }

  List<String> getLocalImages(String locale) {
    switch (locale) {
      case 'en':
        return usLocal;
      case 'ar':
        return arLocal;
      case 'de':
        return deLocal;
      case 'tr':
        return trLocal;
      default:
        return trLocal;
    }
  }

  List<String> getImages(String locale) {
    switch (locale) {
      case 'en':
        return us;
      case 'ar':
        return ar;
      case 'de':
        return de;
      case 'tr':
        return tr;
      default:
        return tr;
    }
  }

  void saveToLocal(String path, String locale) {
    switch (locale) {
      case 'en':
        usLocal.add(path);
        break;
      case 'ar':
        arLocal.add(path);
        break;
      case 'de':
        deLocal.add(path);
        break;
      case 'tr':
        trLocal.add(path);
        break;
      default:
        trLocal.add(path);
    }
  }
}
