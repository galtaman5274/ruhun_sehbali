import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DataSource {
  final Dio _dio;
  DataSource(this._dio);
  final baseApi = 'https://app.ayine.tv/Ayine/UpdateApk/';
  final apkPath = 'app-release.apk';

  Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      await permission.request();
      var status = await permission.status;
      print('>>>>>> $permission status: $status');
      return status.isGranted;
    }
    return status.isGranted;
  }

  Future<void> downloadAndInstallApk(String version) async {
    try {
      // Request permission
      final permission1 = await _requestPermission(Permission.storage);
      // final permission2 =
      //     await _requestPermission(Permission.manageExternalStorage);
      final permission3 =
          await _requestPermission(Permission.requestInstallPackages);
      if (permission1 && permission3) {
        final filePath = await _downloadAPK('$baseApi$version/$apkPath');
        print('file path -> $filePath');
        await _installAPK(filePath);
      }
    } catch (e) {
      print('Error on installing... ${e.toString()}');
    }
  }

  Future<String> _downloadAPK(String url) async {
    // Get the directory to save the file
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/downloaded_app.apk';

    // Send HTTP GET request to download the file
    print('Get request...');
    final response = await _dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      print('Status 200');
      // Save the file to the local storage
      final file = File(filePath);
      print('Response data type : ${response.data.runtimeType}');
      await file.writeAsBytes((response.data as Uint8List).toList());
      print('Written as bytes');
    } else {
      throw Exception("Failed to download APK");
    }
    return filePath; // Return the file path
  }

  Future<void> _installAPK(String filePath) async {
    try {
      print('>>>>> Installing started');
      final result = await OpenFile.open(filePath);
      print('++++++ Install finished : ${result.message}');
    } catch (e) {
      print("?????? Installation failed: $e");
    }
  }

  Future<int> checkVersion(String version1) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version2 = packageInfo.version;
    int result = compareVersion(version1, version2);
    return result;
  }

  int compareVersion(String version1, String version2) {
    // Split the version strings into parts
    List<int> v1Parts = version1.split('.').map(int.parse).toList();
    List<int> v2Parts = version2.split('.').map(int.parse).toList();

    // Compare each part
    int length =
        v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

    for (int i = 0; i < length; i++) {
      // If v1 has fewer parts, assume missing parts are 0
      int v1Part = i < v1Parts.length ? v1Parts[i] : 0;
      int v2Part = i < v2Parts.length ? v2Parts[i] : 0;

      if (v1Part > v2Part) return 1; // v1 is greater
      if (v1Part < v2Part) return -1; // v2 is greater
    }

    return 0; // The versions are equal
  }
}
