import '../entity/service_entity.dart';

abstract class SavedServicesRepository {
  Future<List<ServiceEntity>> getSavedServices();
  Future<void> toggleSaveService(ServiceEntity service);
  Future<bool> isServiceSaved(int serviceId);
  Future<void> clearAllSavedServices();
}
