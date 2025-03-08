import 'package:equatable/equatable.dart';

class FileData  extends Equatable{
  final List<Map<String, dynamic>> alerts;
  final Map<String, dynamic> azanFiles;
  final Map<String, dynamic> pictures;
  final Map<String, dynamic> quran;
  final Map<String, dynamic> screenSaver;

  const FileData(
      {required this.alerts,
      required this.azanFiles,
      required this.pictures,
      required this.quran,
      required this.screenSaver});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      alerts: _addLocal(json["Alert"] ?? []),
      azanFiles: _cleanJson(json["AzanFiles"] ?? {}),
      pictures: _cleanJson(json["Pictures"] ?? {}),
      quran: _cleanJson(json["Quran"] ?? {}),
      screenSaver: _cleanJson(json["ScreenSaver"] ?? {}),
    );
  }

  static List<Map<String, dynamic>> _addLocal(List<dynamic> files) {
    final List<Map<String, dynamic>> localFiles = [];
    for (var value in files) {
      if (value is Map<String, dynamic>) {
        localFiles.add({
          "name": value["name"],
          "last_modified": value["last_modified"],
          'local': ''
        });
      }
    }
    return localFiles;
  }

  static Map<String, dynamic> _cleanJson(Map<String, dynamic> json) {
    // Create a new map to store cleaned data
    Map<String, dynamic> cleanedJson = {};
    
    json.forEach((key, value) {
      // Skip numeric keys
      if (int.tryParse(key) != null) {
        return;
      }

      if (value is List) {
        cleanedJson[key] = _addLocal(value);
      } else if (value is Map<String, dynamic>) {
        // Recursively clean nested maps
        cleanedJson[key] = _cleanJson(value);
      } else {
        cleanedJson[key] = value;
      }
    });
    
    return cleanedJson;
  }
  Map<String, dynamic> toJson() {
    return {
      'Alert': alerts,
      'AzanFiles': azanFiles,
      'Pictures': pictures,
      'Quran': quran,
      'ScreenSaver': screenSaver,
    };
  }

  @override
  List<Object?> get props => [ 
   alerts,
   azanFiles,
  pictures,
   quran,
  screenSaver];
}

// class FileUpdater {
//   static const _storage = FlutterSecureStorage();
//   static const _dio = Dio();
//   static const _jsonUrl = "https://app.ayine.tv/Ayine/files_api.php?key=ayine-random-253327x!11&action=view";
//   static const _lastUpdateKey = "last_update_timestamp";
//   static const _storedDataKey = "stored_files_data";

//   static Future<void> checkAndUpdateFiles() async {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final lastUpdateStr = await _storage.read(key: _lastUpdateKey);
//     final lastUpdate = lastUpdateStr != null ? int.tryParse(lastUpdateStr) ?? 0 : 0;

//     if (now - lastUpdate >= 24 * 60 * 60 * 1000) { // 24 hours passed
//       try {
//         // Fetch latest JSON
//         final response = await _dio.get(_jsonUrl);
//         final newData = response.data is String ? jsonDecode(response.data) : response.data;

//         // Retrieve stored JSON
//         final storedJson = await _storage.read(key: _storedDataKey);
//         final storedData = storedJson != null ? jsonDecode(storedJson) : {};

//         // Compare and update
//         final updatedData = _mergeLatestData(storedData, newData);

//         // Store updated data and timestamp
//         await _storage.write(key: _storedDataKey, value: jsonEncode(updatedData));
//         await _storage.write(key: _lastUpdateKey, value: now.toString());

//         print("✔ Data updated successfully.");
//       } catch (e) {
//         print("❌ Error updating data: $e");
//       }
//     } else {
//       print("⏳ 24 hours have not passed yet.");
//     }
//   }

//   static Map<String, dynamic> _mergeLatestData(Map<String, dynamic> oldData, Map<String, dynamic> newData) {
//     newData.forEach((key, newList) {
//       if (newList is List) {
//         oldData[key] = newList.map((newFile) {
//           var existingFile = (oldData[key] as List?)?.firstWhere(
//             (oldFile) => oldFile["name"] == newFile["name"],
//             orElse: () => newFile,
//           );

//           return (existingFile["last_modified"] ?? 0) < (newFile["last_modified"] ?? 0)
//               ? newFile
//               : existingFile;
//         }).toList();
//       } else {
//         oldData[key] = newList;
//       }
//     });

//     return oldData;
//   }

//   static void startAutoUpdate() {
//     Timer.periodic(Duration(hours: 24), (timer) async {
//       await checkAndUpdateFiles();
//     });
//   }
// }
