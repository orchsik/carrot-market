import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = new FlutterSecureStorage();

  Future<String?> getStoredValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> storeValue(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteValue(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      print(e);
    }
  }
}

// // Read value
// String value = await storage.read(key: key);

// // Read all values
// Map<String, String> allValues = await storage.readAll();

// // Delete value
// await storage.delete(key: key);

// // Delete all
// await storage.deleteAll();

// // Write value
// await storage.write(key: key, value: value);