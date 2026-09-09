import '../../domain/entity/service_entity.dart';
import '../../domain/repository/saved_services_repository.dart';
import '../datasources/saved_services_local_datasource.dart';
import '../models/service_model.dart';

class SavedServicesRepositoryImpl implements SavedServicesRepository {
  final SavedServicesLocalDataSource localDataSource;

  SavedServicesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ServiceEntity>> getSavedServices() async {
    return await localDataSource.getSavedServices();
  }

  @override
  Future<void> toggleSaveService(ServiceEntity service) async {
    final bool isSaved = await localDataSource.isServiceSaved(service.id!);
    final serviceModel = ServiceModel(
      id: service.id,
      title: service.title,
      description: service.description,
      categoryId: service.categoryId,
      costAmount: service.costAmount,
      unitId: service.unitId,
      locationAddress: service.locationAddress,
      locationLat: service.locationLat,
      locationLng: service.locationLng,
      meetingType: service.meetingType,
      imageUrl: service.imageUrl,
      userId: service.userId,
      userFullName: service.userFullName,
      unitName: service.unitName,
      servingTypeName: service.servingTypeName,
    );

    if (isSaved) {
      await localDataSource.removeService(service.id!);
    } else {
      await localDataSource.saveService(serviceModel);
    }
  }

  @override
  Future<bool> isServiceSaved(int serviceId) async {
    return await localDataSource.isServiceSaved(serviceId);
  }

  @override
  Future<void> clearAllSavedServices() async {
    await localDataSource.clearAll();
  }
}
