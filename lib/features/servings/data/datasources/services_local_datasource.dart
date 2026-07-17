import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/payment_unit_model.dart';
import '../models/service_model.dart';

abstract class ServicesLocalDataSource {
  Future<void> cachePaymentUnits(List<PaymentUnitModel> units);
  Future<List<PaymentUnitModel>> getCachedPaymentUnits();

  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>> getCachedCategories();

  Future<void> cacheServiceDetails(ServiceModel service);
  Future<ServiceModel?> getCachedServiceDetails(int serviceId);

  Future<void> cacheMyServings(List<ServiceModel> servings);
  Future<List<ServiceModel>> getCachedMyServings();
}

class ServicesLocalDataSourceImpl implements ServicesLocalDataSource {
  static const String _unitsBoxName = 'payment_units_box';
  static const String _categoriesBoxName = 'categories_box';
  static const String _detailsBoxName = 'service_details_box';
  static const String _myServingsBoxName = 'my_servings_box';

  @override
  Future<void> cachePaymentUnits(List<PaymentUnitModel> units) async {
    final box = await Hive.openBox(_unitsBoxName);
    final List<Map<String, dynamic>> jsonList = units.map((e) => e.toJson()).toList();
    await box.put('units', jsonList);
  }

  @override
  Future<List<PaymentUnitModel>> getCachedPaymentUnits() async {
    final box = await Hive.openBox(_unitsBoxName);
    final List<dynamic>? jsonList = box.get('units');
    if (jsonList != null) {
      return jsonList.map((json) => PaymentUnitModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final box = await Hive.openBox(_categoriesBoxName);
    final List<Map<String, dynamic>> jsonList = categories.map((e) => e.toJson()).toList();
    await box.put('categories', jsonList);
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    final box = await Hive.openBox(_categoriesBoxName);
    final List<dynamic>? jsonList = box.get('categories');
    if (jsonList != null) {
      return jsonList.map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  @override
  Future<void> cacheServiceDetails(ServiceModel service) async {
    final box = await Hive.openBox(_detailsBoxName);
    await box.put(service.id, service.toJson());
  }

  @override
  Future<ServiceModel?> getCachedServiceDetails(int serviceId) async {
    final box = await Hive.openBox(_detailsBoxName);
    final json = box.get(serviceId);
    if (json != null) {
      return ServiceModel.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  @override
  Future<void> cacheMyServings(List<ServiceModel> servings) async {
    final box = await Hive.openBox(_myServingsBoxName);
    final List<Map<String, dynamic>> jsonList = servings.map((e) => e.toJson()).toList();
    await box.put('my', jsonList);
  }

  @override
  Future<List<ServiceModel>> getCachedMyServings() async {
    final box = await Hive.openBox(_myServingsBoxName);
    final List<dynamic>? jsonList = box.get('my');
    if (jsonList != null) {
      return jsonList.map((json) => ServiceModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }
}
