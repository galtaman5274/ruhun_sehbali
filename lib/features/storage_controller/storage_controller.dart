import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageController {

  // Private constructor
  const StorageController._internal() : _storage = const FlutterSecureStorage();

  // The single instance of StorageController
  static final StorageController _instance = StorageController._internal();

  // Factory constructor that always returns the same instance
  factory StorageController() => _instance;

  final FlutterSecureStorage _storage;

  Future<void> saveValue(String key, String value) async =>
      await _storage.write(key: key, value: value);

  Future<String?> getValue(String key) async =>
      await _storage.read(key: key);
}
