import 'package:hive/hive.dart';
import '../models/service_item_model.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheNearbyServings(List<ServiceModel> servings);
  Future<List<ServiceModel>> getCachedNearbyServings();
  
  Future<void> cacheSearchServings(List<ServiceModel> servings);
  Future<List<ServiceModel>> getCachedSearchServings();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String _nearbyBoxName = 'nearby_servings_box';
  static const String _searchBoxName = 'search_servings_box';

  @override
  Future<void> cacheNearbyServings(List<ServiceModel> servings) async {
    final box = await Hive.openBox(_nearbyBoxName);
    final List<Map<String, dynamic>> jsonList = servings.map((e) => e.toJson()).toList();
    await box.put('nearby', jsonList);
  }

  @override
  Future<List<ServiceModel>> getCachedNearbyServings() async {
    final box = await Hive.openBox(_nearbyBoxName);
    final List<dynamic>? jsonList = box.get('nearby');
    if (jsonList != null) {
      return jsonList.map((json) => ServiceModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  @override
  Future<void> cacheSearchServings(List<ServiceModel> servings) async {
    final box = await Hive.openBox(_searchBoxName);
    final List<Map<String, dynamic>> jsonList = servings.map((e) => e.toJson()).toList();
    await box.put('search', jsonList);
  }

  @override
  Future<List<ServiceModel>> getCachedSearchServings() async {
    final box = await Hive.openBox(_searchBoxName);
    final List<dynamic>? jsonList = box.get('search');
    if (jsonList != null) {
      return jsonList.map((json) => ServiceModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }
}
