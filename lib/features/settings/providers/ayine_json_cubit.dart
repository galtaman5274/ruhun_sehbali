import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ruhun_sehbali/features/storage_controller/storage_controller.dart';
import 'data_models.dart';
part 'ayine_states.dart';

class AyineJsonCubit extends Cubit<AyineJsonState> {
  final Dio _dio;
  final StorageController _secureStorage =  StorageController();

  AyineJsonCubit({
    Dio? dio,
    StorageController? secureStorage,
  })  : _dio = dio ?? Dio(),
        super(AyineJsonInitial());
  Future<void> checkForAyineJson() async {
    emit(AyineJsonInitial());
    try {
      // Try to read the JSON from secure storage.
      String? storedJson = await _secureStorage.getValue( 'ayine_json');

      // If not stored, attempt to download it.
      if (storedJson == null) {
        try {
          final response = await _dio.get(
            'https://app.ayine.tv/Ayine/ayine.json',
            options: Options(responseType: ResponseType.json),
          );
          if (response.statusCode == 200) {
            storedJson = response.data is String
                ? fixMalformedJson(response.data)
                : jsonEncode(response.data);
            await _secureStorage.saveValue('ayine_json',storedJson);
          } else {
            throw Exception(
                'Failed to download JSON. Status code: ${response.statusCode}');
          }
        } on DioException catch (e) {
          throw Exception('Error downloading JSON: ${e.message}');
        }
      }

      // Parse the stored JSON string.
      final Map<String, dynamic> decoded = jsonDecode(storedJson);

      final Alert alert = Alert.fromJson(decoded['Alert']);

      final AzanFiles azanFiles = AzanFiles.fromJson(decoded['AzanFiles']);
      final Quran quran = Quran.fromJson(decoded['Quran']);
      final ScreenSaver screenSaver =
          ScreenSaver.fromJson(decoded['ScreenSaver']);

      // Emit a loaded state with these objects.
      emit(AyineJsonLoaded(
        alert: alert,
        azanFiles: azanFiles,
        quran: quran,
        screenSaver: screenSaver,
      ));
    } catch (e) {
      // Any error (including no internet) will be handled by the FutureBuilder.
      emit(AyineJsonError(message: 'message$e'));
    }
  }

  Future<void> saveToStorage(String locale) async {
    final currentState = state;
    if (currentState is AyineJsonLoaded) {
      final screenSaver = currentState.screenSaver;
      final images = screenSaver.getImages(locale);

      try {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final Directory directory =
            Directory('${appDocDir.path}/screen_savers/$locale');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
          for (final imageUrl in images) {
            final uri = Uri.parse(imageUrl);

            final response = await _dio.get(
              imageUrl,
              options: Options(responseType: ResponseType.bytes),
            );

            if (response.statusCode == 200) {
              final fileName = uri.pathSegments.last;
              final file = File('${directory.path}/$fileName');

              // Write binary data to the file
              await file.writeAsBytes(response.data);

              // Optionally save to local in your ScreenSaver model
              screenSaver.saveToLocal(file.absolute.path, locale);

              print('File saved: ${file.absolute.path}');
            } else {
              print(
                  'Failed to download $imageUrl. Status code: ${response.statusCode}');
            }
          }
        } else {
          final List<FileSystemEntity> files = directory.listSync();
          files.forEach(
              (file) => screenSaver.saveToLocal(file.absolute.path, locale));

          if (screenSaver.getLocalImages(locale).length != images.length) {
            directory
                .delete(recursive: true)
                .then((_) => directory.createSync(recursive: true));
            screenSaver.getLocalImages(locale).clear();
            for (final imageUrl in images) {
              final uri = Uri.parse(imageUrl);

              final response = await _dio.get(
                imageUrl,
                options: Options(responseType: ResponseType.bytes),
              );
              if (response.statusCode == 200) {
                final fileName = uri.pathSegments.last;
                final file = File('${directory.path}/$fileName');
                // Write binary data to the file
                await file.writeAsBytes(response.data);
                // Optionally save to local in your ScreenSaver model
                screenSaver.saveToLocal(file.absolute.path, locale);
                print('File saved: ${file.absolute.path}');
              } else {
                print(
                    'Failed to download $imageUrl. Status code: ${response.statusCode}');
              }
            }
          }
        }
        // Once images are saved, we emit the ContentSavedToStorage state
        emit(AyineJsonInitial());
        emit(AyineJsonLoadedStorage(
          alert: currentState.alert,
          azanFiles: currentState.azanFiles,
          quran: currentState.quran,
          screenSaver: screenSaver,
        ));
      } catch (e) {
        emit(AyineJsonError(message: 'Error downloading images: $e'));
      }
    } else {
      emit(AyineJsonError(message: 'Content must be downloaded first.'));
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
}
