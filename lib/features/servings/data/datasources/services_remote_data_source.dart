import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_time/core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/payment_unit_model.dart';
import '../models/service_model.dart';
import '../models/serving_type_model.dart';

abstract class ServicesRemoteDataSource {
  Future<void> addService({
    required ServiceModel serviceModel,
    required XFile? image,
    required String endpoint,
  });

  Future<List<PaymentUnitModel>> getPaymentUnits();

  Future<List<CategoryModel>> getCategories();

  Future<List<ServingTypeModel>> getServingTypes();

  Future<ServiceModel> getServiceDetails(int serviceId);

  Future<List<dynamic>> getAvailabilitySlots(int serviceId);

  Future<List<ServiceModel>> getMyServings();
  
  Future<void> updateServing({
    required int id,
    required String title,
    required String description,
    required double costAmount,
    required String meetingType,
  });

  Future<void> toggleServingStatus(int id, bool isActive);

  Future<void> rateServing(int serviceId, double rating);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final Dio dio;

  ServicesRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> addService({
    required ServiceModel serviceModel,
    required XFile? image,
    required String endpoint,
  }) async {
    try {
      final Map<String, dynamic> data = serviceModel.toJson();
      final FormData formData = FormData.fromMap(data);

      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            ),
          ),
        );
      }
      final response = await dio.post(
        endpoint,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل الاتصال بالسيرفر',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'تأكد من اتصالك بالإنترنت وحاول مجدداً',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
      );
    }
  }

  @override
  Future<List<PaymentUnitModel>> getPaymentUnits() async {
    try {
      final response = await dio.get(ApiStringConstants.getPaymentUnitsUrl);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => PaymentUnitModel.fromJson(e)).toList();
      } else {
        throw ServerExceptionWithDetails(
          message: response.data['message'] ?? 'فشل جلب وحدات الدفع',
        );
      }
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء جلب وحدات الدفع');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.post(
        ApiStringConstants.getCategoriesUrl,
        data: {"name": null, "parent_id": null},
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw ServerExceptionWithDetails(
          message: response.data['message'] ?? 'فشل جلب التصنيفات',
        );
      }
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء جلب التصنيفات');
    }
  }

  @override
  Future<List<ServingTypeModel>> getServingTypes() async {
    try {
      final response = await dio.get(ApiStringConstants.getServingTypesUrl);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => ServingTypeModel.fromJson(e)).toList();
      } else {
        throw ServerExceptionWithDetails(
          message: response.data['message'] ?? 'فشل جلب أنواع الخدمات',
        );
      }
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء جلب أنواع الخدمات');
    }
  }

  @override
  Future<ServiceModel> getServiceDetails(int serviceId) async {
    try {
      final response = await dio.get('servings/$serviceId');
      if (response.statusCode == 200) {
        return ServiceModel.fromJson(response.data['data']);
      } else {
        throw ServerExceptionWithDetails(
          message: response.data['message'] ?? 'فشل جلب تفاصيل الخدمة',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'فشل الاتصال بالسيرفر',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء جلب تفاصيل الخدمة');
    }
  }

  @override
  Future<List<dynamic>> getAvailabilitySlots(int serviceId) async {
    try {
      final response = await dio.get('servings/$serviceId/availability-slots');
      if (response.statusCode == 200) {
        return response.data['data'] as List<dynamic>;
      } else {
        throw ServerExceptionWithDetails(
          message: response.data['message'] ?? 'فشل جلب أوقات التوفر',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'فشل الاتصال بالسيرفر',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء جلب أوقات التوفر');
    }
  }

  @override
  Future<List<ServiceModel>> getMyServings() async {
    try {
      final response = await dio.post(
        'servings/my',
        data: {
          'skip': 0,
          'take': 20,
        },
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw ServerExceptionWithDetails(
          message: response.data['message'] ?? 'فشل جلب خدماتي',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'فشل الاتصال بالسيرفر',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء جلب خدماتي');
    }
  }

  @override
  Future<void> updateServing({
    required int id,
    required String title,
    required String description,
    required double costAmount,
    required String meetingType,
  }) async {
    try {
      final response = await dio.put(
        '${ApiStringConstants.addPaidServiceUrl}/$id',
        data: {
          'title': title,
          'description': description,
          'cost_amount': costAmount,
          'meeting_type': meetingType,
        },
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل تحديث الخدمة',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'فشل الاتصال بالسيرفر',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء تحديث الخدمة');
    }
  }

  @override
  Future<void> toggleServingStatus(int id, bool isActive) async {
    try {
      final endpoint = isActive 
          ? ApiStringConstants.activateServingUrl(id) 
          : ApiStringConstants.deactivateServingUrl(id);
          
      final response = await dio.post(endpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل تغيير حالة الخدمة',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'فشل الاتصال بالسيرفر',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء تغيير حالة الخدمة');
    }
  }

  @override
  Future<void> rateServing(int serviceId, double rating) async {
    try {
      final response = await dio.post(
        'servings/$serviceId/rate',
        data: {'rating': rating},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل إرسال التقييم',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'فشل الاتصال بالسيرفر',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(message: 'حدث خطأ أثناء إرسال التقييم');
    }
  }
}

