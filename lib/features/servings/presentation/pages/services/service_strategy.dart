import '../../../domain/entity/service_entity.dart';

abstract class ServiceStrategy {
  ServiceEntity prepareService({
    required String title,
    required String description,
    required String categoryId,
    required String hours,
    required String priceOrCost,
    required String? paymentUnit,
    required String locationAddress,
    required double? lat,
    required double? lng,
    required String meetingType,
  });
}

class PaidServiceStrategy implements ServiceStrategy {
  @override
  ServiceEntity prepareService({
    required String title, required String description, required String categoryId,
    required String hours, required String priceOrCost, required String? paymentUnit,
    required String locationAddress, required double? lat, required double? lng, required String meetingType,
  }) {
    return ServiceEntity(
      title: title,
      description: description,
      categoryId: categoryId,
      costAmount: priceOrCost,
      unitId: paymentUnit,
      locationAddress: locationAddress,
      locationLat: lat ?? 33.5138,
      locationLng: lng ?? 36.2765,
      meetingType: meetingType,
      servingTypeId: 1,
    );
  }
}

class BarterServiceStrategy implements ServiceStrategy {
  @override
  ServiceEntity prepareService({
    required String title, required String description, required String categoryId,
    required String hours, required String priceOrCost, required String? paymentUnit,
    required String locationAddress, required double? lat, required double? lng, required String meetingType,
  }) {
    return ServiceEntity(
      title: title,
      description: description,
      categoryId: categoryId,
      costAmount: hours,
      unitId: "2",
      locationAddress: locationAddress,
      locationLat: lat ?? 33.5138,
      locationLng: lng ?? 36.2765,
      meetingType: meetingType,
      servingTypeId: 2,
    );
  }
}

class VolunteerServiceStrategy implements ServiceStrategy {
  @override
  ServiceEntity prepareService({
    required String title, required String description, required String categoryId,
    required String hours, required String priceOrCost, required String? paymentUnit,
    required String locationAddress, required double? lat, required double? lng, required String meetingType,
  }) {
    return ServiceEntity(
      title: title,
      description: description,
      categoryId: categoryId,
      costAmount: "0",
      unitId: "1",
      locationAddress: locationAddress,
      locationLat: lat ?? 33.5138,
      locationLng: lng ?? 36.2765,
      meetingType: meetingType,
      servingTypeId: 3,
    );
  }
}
