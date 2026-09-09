import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';

abstract class SavedServicesLocalDataSource {
  Future<List<ServiceModel>> getSavedServices();
  Future<void> saveService(ServiceModel service);
  Future<void> removeService(int serviceId);
  Future<bool> isServiceSaved(int serviceId);
  Future<void> clearAll();
}

class SavedServicesLocalDataSourceImpl implements SavedServicesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _savedKey = 'saved_services';

  SavedServicesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ServiceModel>> getSavedServices() async {
    final List<String>? savedList = sharedPreferences.getStringList(_savedKey);
    if (savedList == null) return [];

    final List<ServiceModel> services = [];
    for (var item in savedList) {
      try {
        services.add(ServiceModel.fromJson(json.decode(item)));
      } catch (e) {
        // Skip corrupted items
      }
    }
    return services;
  }

  @override
  Future<void> saveService(ServiceModel service) async {
    final List<String> savedList = sharedPreferences.getStringList(_savedKey) ?? [];

    // Check if already exists
    final bool exists = savedList.any((item) {
      try {
        final decoded = json.decode(item);
        return decoded['id'].toString() == service.id.toString();
      } catch (e) {
        return false;
      }
    });

    if (!exists) {
      savedList.add(json.encode(service.toJson()));
      await sharedPreferences.setStringList(_savedKey, savedList);
    }
  }

  @override
  Future<void> removeService(int serviceId) async {
    final List<String> savedList = sharedPreferences.getStringList(_savedKey) ?? [];

    savedList.removeWhere((item) {
      try {
        final decoded = json.decode(item);
        return decoded['id'].toString() == serviceId.toString();
      } catch (e) {
        return true; // Remove corrupted items as well
      }
    });

    await sharedPreferences.setStringList(_savedKey, savedList);
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.remove(_savedKey);
  }

  @override
  Future<bool> isServiceSaved(int serviceId) async {
    final List<String>? savedList = sharedPreferences.getStringList(_savedKey);
    if (savedList == null) return false;

    return savedList.any((item) {
      try {
        final decoded = json.decode(item);
        return decoded['id'].toString() == serviceId.toString();
      } catch (e) {
        return false;
      }
    });
  }
}
