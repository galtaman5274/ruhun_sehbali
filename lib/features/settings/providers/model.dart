import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ruhun_sehbali/features/storage_controller/storage_controller.dart';

const _storedDataKey = "stored_files_data";
const url = 'https://app.ayine.tv/Ayine/';

class FileData extends Equatable {
  // Add static instance
  static FileData? _instance;
  static final StorageController _storage = StorageController();

  final List<Map<String, dynamic>> alerts;
  final Map<String, dynamic> azanFiles;
  final Map<String, dynamic> pictures;
  final Map<String, dynamic> quran;
  final Map<String, dynamic> screenSaver;

  // Make constructor private
  const FileData._({
    required this.alerts,
    required this.azanFiles,
    required this.pictures,
    required this.quran,
    required this.screenSaver,
  });

  // Add factory constructor for singleton instance
  factory FileData({
    required List<Map<String, dynamic>> alerts,
    required Map<String, dynamic> azanFiles,
    required Map<String, dynamic> pictures,
    required Map<String, dynamic> quran,
    required Map<String, dynamic> screenSaver,
  }) {
    _instance ??= FileData._(
      alerts: alerts,
      azanFiles: azanFiles,
      pictures: pictures,
      quran: quran,
      screenSaver: screenSaver,
    );
    return _instance!;
  }

  // Get singleton instance
  static FileData get instance {
    if (_instance == null) {
      throw StateError('FileData has not been initialized');
    }
    return _instance!;
  }

  static Future<FileData?> loadFromStorage() async {
    try {
      final storedJson = await _storage.getValue(_storedDataKey);
      if (storedJson != null) {
        final Map<String, dynamic> data = jsonDecode(storedJson);
        _instance = FileData.fromJson(data);
        return _instance!;
      }
      return null;
      //throw StateError('No stored data found');
    } catch (e) {
      return null;
      //throw StateError('Failed to load FileData: $e');
    }
  }

  // Add method to save current instance
  Future<void> saveToStorage(StorageController storage) async {
    try {
      final jsonString = jsonEncode(toJson());
      await storage.saveValue(_storedDataKey, jsonString);
    } catch (e) {
      throw StateError('Failed to save FileData: $e');
    }
  }

  // Add method to update local path
  FileData updateLocalPath(String category, String key, int index, String path,
      [String? qariFile, String? azanTime]) {
    Map<String, dynamic> newData = toJson();

    switch (category) {
      case 'quran':
        if (newData['Quran'][key] != null) {
          newData['Quran'][key][qariFile][index]['local'] = path;
        }
        break;
      case 'screenSaver':
        if (newData['ScreenSaver'][key] != null) {
          newData['ScreenSaver'][key][index]['local'] = path;
        }
        break;
      case 'azanFiles':
        if (newData['AzanFiles'][key] != null) {
          newData['AzanFiles'][key][azanTime][index]['local'] = path;
        }
        break;
    }

    return FileData.fromJson(newData);
  }

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      alerts: _addLocal(json["Alert"] ?? [], 'Alert'),
      azanFiles: _cleanJson(json["AzanFiles"] ?? {},"AzanFiles"),
      pictures: _cleanJson(json["Pictures"] ?? {},"Pictures"),
      quran: _cleanJson(json["Quran"] ?? {},"Quran"),
      screenSaver: _cleanJson(json["ScreenSaver"] ?? {},"ScreenSaver"),
    );
  }

  static List<Map<String, dynamic>> _addLocal(List<dynamic> files, String key) {
    final List<Map<String, dynamic>> localFiles = [];
    for (var value in files) {
      if (value is Map<String, dynamic>) {
        localFiles.add({
          "name": value["name"],
          "last_modified": value["last_modified"],
          'local': '',
          'url': '$key/${value['name']}'
        });
      }
    }
    return localFiles;
  }

  static Map<String, dynamic> _cleanJson(Map<String, dynamic> json,String url) {
    // Create a new map to store cleaned data
    Map<String, dynamic> cleanedJson = {};

    json.forEach((key, value) {
      // Skip numeric keys
      if (int.tryParse(key) != null) {
        return;
      }

      if (value is List) {
        cleanedJson[key] = _addLocal(value, key);
      } else if (value is Map<String, dynamic>) {
        // Recursively clean nested maps
        cleanedJson[key] = _cleanJson(value,'$url/$key');
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
  List<Object?> get props => [alerts, azanFiles, pictures, quran, screenSaver];
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
