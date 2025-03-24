import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ruhun_sehbali/features/settings/providers/data_source.dart';
import 'package:ruhun_sehbali/features/storage_controller/storage_controller.dart';
import 'data_models.dart';
import 'model.dart';
part 'ayine_states.dart';

const _jsonUrl =
    "https://app.ayine.tv/Ayine/files_api.php?key=ayine-random-253327x!11&action=view";

const _lastUpdateKey = "last_update_timestamp";
const _storedDataKey = "stored_files_data";

class AyineJsonCubit extends Cubit<AyineJsonState> {
  final Dio _dio;
  DataSource dataSource;
  final StorageController _secureStorage = StorageController();

  AyineJsonCubit({
    required Dio dio,
    StorageController? secureStorage,
  })  : _dio = dio,
        dataSource = DataSource(dio),
        super(AyineJsonInitial()) {
    // _initializeFileData();
    // getAyineJson();
  }

  Future<void> updateLocalPath(
      String category, String key, int index, String path) async {
    try {
      if (state is AyineJsonLoaded) {
        final currentState = state as AyineJsonLoaded;
        final updatedData =
            currentState.fileData.updateLocalPath(category, key, index, path);
        await updatedData.saveToStorage(_secureStorage);
        emit(AyineJsonLoaded(fileData: updatedData));
      }
    } catch (e) {
      emit(AyineJsonError(message: 'Failed to update local path: $e'));
    }
  }

  Future<Map<String, dynamic>?> getAyineJson() async {
    try {
      final checkResponse = await _dio.get(
        'https://app.ayine.tv/Ayine/files_api.php?key=ayine-random-253327x!11&action=scan',
      );
      log('<><><><><><> scan response status: ${checkResponse.statusCode}');

      final response = await _dio.get(
        _jsonUrl,
        options: Options(responseType: ResponseType.json),
      );

      log('<><><><><><> response status: ${response.statusCode}');
      log('<><><><><><> response data: ${response.data['UpdateApk']}');

      if (response.statusCode == 200) {
        // final fileData = FileData.fromJson(response.data);
        // print(fileData.alerts);
        return response.data;
      } else {
        return null;
      }

      // await checkUpdate(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<FileData> getFileData() async {
    final storedJson = await _secureStorage.getValue(_storedDataKey);

    final Map<String, dynamic> storedData =
        Map<String, dynamic>.from(jsonDecode(storedJson ?? ''));
    return FileData.fromJson(storedData);
  }

  Future<void> onAddMediaList(
    String qari,
    String quranFile,
  ) async {
    final storedJson = await _secureStorage.getValue(_storedDataKey);
    if (storedJson != null) {
      final finalJson = await getFileData();
      final mediaList = finalJson.quran[qari][quranFile];
      for (var i = 0; i < mediaList.length; i++) {
        finalJson.quran[qari][quranFile][i]['onPlayList'] = true;
      }
      await _secureStorage.saveValue(
          _storedDataKey, jsonEncode(finalJson.toJson()));
      emit(AyineJsonInitial());
      emit(AyineJsonLoaded(fileData: finalJson));
    }
  }

  Future<Map<String, dynamic>> getFileDatas() async {
    final storedJson = await _secureStorage.getValue(_storedDataKey);

    final Map<String, dynamic> storedData =
        Map<String, dynamic>.from(jsonDecode(storedJson ?? ''));
    return storedData;
  }

  Future<void> saveQuranToStorage(String qari, String quranFile,
      [String? fileName]) async {
    final storedJson = await _secureStorage.getValue(_storedDataKey);

    if (storedJson != null) {
      final finalJson = await getFileData();
      final qaris = finalJson.quran[qari];

      //final String url = 'https://app.ayine.tv/Ayine/Quran/$qari';

      if (qaris[quranFile].isNotEmpty) {
        try {
          final Directory appDocDir = await getApplicationDocumentsDirectory();
          final Directory directory =
              Directory('${appDocDir.path}/Quran/$qari/$quranFile');

          directory.createSync(recursive: true);
          for (var j = 0; j < qaris[quranFile].length; j++) {
            if (qaris[quranFile][j]['local'] == '') {
              final response = await _dio.get(
                qaris[quranFile][j]['url'],
                options: Options(responseType: ResponseType.bytes),
              );

              if (response.statusCode == 200) {
                final file =
                    File('${directory.path}/${qaris[quranFile][j]['name']}');

                // Write binary data to the file
                await file.writeAsBytes(response.data);

                // Optionally save to local in your ScreenSaver model
                finalJson.quran[qari][quranFile][j]['local'] =
                    file.absolute.path;

                print(finalJson.quran[qari][quranFile][j]['local']);
                await _secureStorage.saveValue(
                    _storedDataKey, jsonEncode(finalJson.toJson()));
                print('File saved: ${file.absolute.path}');
              } else {
                print(
                    'Failed to download ${qaris[qari][quranFile]}. Status code: ${response.statusCode}');
              }
            }
          }
          emit(AyineJsonInitial());
          emit(AyineJsonLoaded(fileData: finalJson));
        } catch (e) {
          // emit(AyineJsonError(message: 'Error downloading images: $e'));
          print(e);
        }
      }
    }
  }

  Future<void> saveToStorage(String imgPath, String azanPath) async {
    final storedJson = await _secureStorage.getValue(_storedDataKey);
    if (storedJson != null) {
      final finalJson = await getFileData();
      final images = finalJson.screenSaver[imgPath];

      //final String url = 'https://app.ayine.tv/Ayine/ScreenSaver/$imgPath/';
      try {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final Directory directory =
            Directory('${appDocDir.path}/screen_savers/$imgPath/');
        if (!await directory.exists() || directory.listSync().isEmpty) {
          directory.createSync(recursive: true);
          for (var i = 0; i < images.length; i++) {
            if (images[i]['local'] == '') {
              final response = await _dio.get(
                images[i]['url'],
                options: Options(responseType: ResponseType.bytes),
              );

              if (response.statusCode == 200) {
                final file = File('${directory.path}${images[i]['name']}');

                // Write binary data to the file
                await file.writeAsBytes(response.data);

                // Optionally save to local in your ScreenSaver model
                finalJson.screenSaver[imgPath][i]['local'] = file.absolute.path;
                await _secureStorage.saveValue(
                    _storedDataKey, jsonEncode(finalJson.toJson()));
                print('File saved: ${file.absolute.path}');
              } else {
                print(
                    'Failed to download ${images[i]}. Status code: ${response.statusCode}');
              }
            }
          }
        }

        final azanFiles = finalJson.azanFiles;

        // final String urlAzan = 'https://app.ayine.tv/Ayine/AzanFiles/$azanPath';
        final keys = azanFiles[azanPath].keys;
        for (var i in keys) {
          if (azanFiles[azanPath][i].isNotEmpty) {
            final Directory appDocDir =
                await getApplicationDocumentsDirectory();
            final Directory directory =
                Directory('${appDocDir.path}/AzanFiles/$azanPath/$i');

            directory.createSync(recursive: true);
            for (var j = 0; j < azanFiles[azanPath][i].length; j++) {
              if (azanFiles[azanPath][i][j]['local'] == '') {
                final response = await _dio.get(
                  //'$urlAzan/$i/${azanFiles[azanPath][i][j]['name']}',
                  azanFiles[azanPath][i][j]['url'],
                  options: Options(
                    responseType: ResponseType.bytes,
                    headers: {
                      'Accept': 'video/mp4',
                      'Content-Type': 'video/mp4',
                    },
                  ),
                );

                if (response.statusCode == 200) {
                  final file = File(
                      '${directory.path}/${azanFiles[azanPath][i][j]['name']}');

                  // Write binary data to the file
                  await file.writeAsBytes(response.data);

                  // Optionally save to local in your ScreenSaver model
                  finalJson.azanFiles[azanPath][i][j]['local'] =
                      file.absolute.path;
                  print(finalJson.azanFiles[azanPath][i][j]['local']);
                  await _secureStorage.saveValue(
                      _storedDataKey, jsonEncode(finalJson.toJson()));
                  print('File saved: ${file.absolute.path}');
                } else {
                  print(
                      'Failed to download ${azanFiles[azanPath][i]}. Status code: ${response.statusCode}');
                }
              }
            }
          }
        }
      } catch (e) {
        // emit(AyineJsonError(message: 'Error downloading images: $e'));
        print(e);
      }
    }
  }

  String fixMalformedJson(String input) {
    // This regex matches unquoted keys (a sequence of word characters) followed by a colon.
    final keyPattern = RegExp(r'(\w+):');
    String output = input.replaceAllMapped(keyPattern, (match) {
      // Avoid double quoting if already quoted.
      final key = match.group(1);
      return '"$key":';
    });

    // Optionally, you could add further fixes here (for example, wrapping unquoted string values).
    return output;
  }

  Future<bool> checkIfSetupRequired() async {
    final results = await Future.wait([
      _secureStorage.getValue('longitude'),
      _secureStorage.getValue('latitude'),
      _secureStorage.getValue('city'),
    ]);
    return results.any((element) => element == null);
  }

  Future<void> compareAndReplaceJson() async {
    try {
      await _dio.get(
        'https://app.ayine.tv/Ayine/files_api.php?key=ayine-random-253327x!11&action=scan',
      );
      // Step 1: Get the stored JSON from secure storage.
      String? storedJson = await _secureStorage.getValue('ayine_json');

      // Step 2: Download the latest JSON from the server.
      final response = await _dio.get(
        'https://app.ayine.tv/Ayine/files_api.php?key=ayine-random-253327x!11&action=view',
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        checkUpdate(response.data);

        // Process the downloaded JSON.
        String downloadedJson = response.data is String
            ? fixMalformedJson(response.data)
            : jsonEncode(response.data);
        // Step 3: Compare the downloaded JSON with the stored JSON.
        if (storedJson == null || storedJson != downloadedJson) {
          // If they are different, replace the stored JSON with the new one.
          await _secureStorage.saveValue('ayine_json', downloadedJson);
          print('JSON replaced with the latest version.');
        } else {
          print('JSON is already up-to-date.');
        }
      } else {
        throw Exception(
            'Failed to download JSON. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error downloading JSON: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> checkUpdate(Map<String, dynamic> json) async {
    final dataSource = DataSource(Dio());
    try {
      final newVersion = (json['UpdateApk'] as Map).entries.last.key;
      final result = await dataSource.checkVersion(newVersion);
      if (result > 0) await dataSource.downloadAndInstallApk(newVersion);
      // String? version = await _secureStorage.getValue('version');
      // log('stored version : $version');
      // if (version != null) {
      //   List<int> v1Parts = version.split('.').map(int.parse).toList();
      //   v1Parts[2] = v1Parts[2] + 1;
      //   final newVersion = v1Parts.join('.');
      //   log('new version $newVersion, version from json ${json['UpdateApk'][newVersion]}');
      // if (json['UpdateApk'][newVersion] != null)
      //   dataSource.downloadAndInstallApk(newVersion);
      // print(newVersion);
      // }
    } on DioException catch (e) {
      throw Exception('Error downloading JSON: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> checkAndUpdateFiles() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastUpdateStr = await _secureStorage.getValue(_lastUpdateKey);
    final lastUpdate =
        lastUpdateStr != null ? int.tryParse(lastUpdateStr) ?? 0 : 0;

    if (now - lastUpdate >= 24 * 60 * 60 * 1000) {
      try {
        final response = await _dio.get(
          _jsonUrl,
          options: Options(responseType: ResponseType.json),
        );

        final Map<String, dynamic> newData = response.data is String
            ? jsonDecode(response.data)
            : Map<String, dynamic>.from(response.data);
        checkUpdate(newData);
        // Get current stored data
        final currentData = await FileData.loadFromStorage();
        // Merge and update data
        if (currentData != null) {
          final updatedData = _mergeLatestData(currentData.toJson(), newData);
          final finalData = FileData.fromJson(updatedData);
          await finalData.saveToStorage(_secureStorage);
          await _secureStorage.saveValue(_lastUpdateKey, now.toString());
          emit(AyineJsonLoaded(fileData: finalData));
        } else {
          final finalData = FileData.fromJson(newData);
          await finalData.saveToStorage(_secureStorage);
          await _secureStorage.saveValue(_lastUpdateKey, now.toString());
          emit(AyineJsonLoaded(fileData: finalData));
        }
      } catch (e) {
        emit(AyineJsonError(message: 'Failed to update data: $e'));
      }
    } else {
      final finalData = await FileData.loadFromStorage();

      if (finalData != null) emit(AyineJsonLoaded(fileData: finalData));
    }
  }

  Map<String, dynamic> _mergeLatestData(
      Map<String, dynamic> oldData, Map<String, dynamic> newData) {
    final result = Map<String, dynamic>.from(oldData);

    newData.forEach((key, value) {
      if (value is List) {
        result[key] = value; // Simply replace lists
      } else if (value is Map) {
        // Recursively merge nested maps
        if (!result.containsKey(key) || !(result[key] is Map)) {
          result[key] = <String, dynamic>{};
        }
        result[key] = _mergeLatestData(
            Map<String, dynamic>.from(result[key] as Map),
            Map<String, dynamic>.from(value));
      } else {
        result[key] = value;
      }
    });

    return result;
  }

  void startAutoUpdate() {
    checkAndUpdateFiles();
    Timer.periodic(Duration(hours: 24), (timer) async {
      await checkAndUpdateFiles();
    });
  }
}
