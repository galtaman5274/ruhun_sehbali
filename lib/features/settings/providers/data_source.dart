import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DataSource {
  final Dio _dio;
  DataSource(this._dio);
  final baseApi = 'https://app.ayine.tv/Ayine/UpdateApk/';
  final apkPath = 'app-release.apk';

  Future<void> _requestPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isDenied) {
      await permission.request();
      var status = await permission.status;
      debugPrint('>>>>>> $permission status: $status');
    }
  }

  Future<void> downloadAndInstallApk(String version) async {
    try {
      // Request permission
      await _requestPermission(Permission.requestInstallPackages);
      await _requestPermission(Permission.storage);
      await _requestPermission(Permission.manageExternalStorage);
      final filePath = await _downloadAPK('$baseApi$version/$apkPath');
      debugPrint('file path -> $filePath');
      await _installAPK(filePath);
    } catch (e) {
      debugPrint('Error on installing... ${e.toString()}');
    }
  }

  Future<String> _downloadAPK(String url) async {
    // Get the directory to save the file
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/downloaded_app.apk';

    // Send HTTP GET request to download the file
    debugPrint('Get request...');
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      debugPrint('Status 200');
      // Save the file to the local storage
      final file = File(filePath);
      await file.writeAsBytes(response.data);
      debugPrint('Written as bytes');
    } else {
      throw Exception("Failed to download APK");
    }
    return filePath; // Return the file path
  }

  Future<void> _installAPK(String filePath) async {
    try {
      debugPrint('>>>>> Installing started');
      final result = await OpenFile.open(filePath);
      debugPrint('Install finished : ${result.message}');
    } catch (e) {
      debugPrint("Installation failed: $e");
    }
  }

  Future<void> checkVersion(String version1) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version2 = packageInfo.version;

    int result = compareVersion(version1, version2);
    if (result < 0) downloadAndInstallApk(version1);
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
