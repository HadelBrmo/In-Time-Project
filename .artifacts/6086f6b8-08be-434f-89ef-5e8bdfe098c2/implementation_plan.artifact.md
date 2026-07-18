# Implementation Plan - Toggle Serving Status (Active/Inactive)

This plan outlines the steps to add a `status` field to the serving model and implement a toggle mechanism in the "My Services" page to activate or deactivate a service.

## User Review Required

> [!IMPORTANT]
> You mentioned that you don't have a specific `activate` API. Usually, in these patterns, if `/deactivate` exists, there is a corresponding `/activate`.
> I will implement the logic to call `{{base_url}}/servings/{id}/activate` when the switch is turned ON and `{{base_url}}/servings/{id}/deactivate` when OFF.
> **If the activation endpoint is different (e.g., via the general update API), please let me know.**

## Proposed Changes

### Domain Layer

#### [MODIFY] [ServiceEntity](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/entity/service_entity.dart)
- Add `String? status` to the entity and `copyWith` method.

#### [NEW] [ToggleServingStatusUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/usecases/service/toggle_serving_status_usecase.dart)
- Create a new use case to handle the toggle operation.

#### [MODIFY] [ServicesRepository](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/repository/servicesRepository.dart)
- Add `toggleServingStatus(int id, bool isActive)` to the interface.

---

### Data Layer

#### [MODIFY] [ServiceModel](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/models/service_model.dart)
- Update model to include `status` in `fromJson`. Note: `toJson` is mostly used for creating/updating where status might not be needed yet, but I'll add it for consistency.
- Also update [service_item_model.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/home/data/models/service_item_model.dart).

#### [MODIFY] [ServicesRemoteDataSource](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/datasources/services_remote_data_source.dart)
- Implement `toggleServingStatus(int id, bool isActive)` which calls `/activate` or `/deactivate` based on the flag.

#### [MODIFY] [ServicesRepositoryImpl](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/repository/services_repository_impl.dart)
- Implement the new repository method.

---

### Presentation Layer

#### [MODIFY] [MyServingsEvent](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/my_servings/my_servings_event.dart)
- Add `ToggleMyServingStatusEvent({required int id, required bool isActive})`.

#### [MODIFY] [MyServingsBloc](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/my_servings/my_servings_bloc.dart)
- Inject `ToggleServingStatusUseCase` and handle the new event.

#### [MODIFY] [MyServingCard](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/widgets/my_serving_card.dart)
- Add a `Switch` widget in the top right or bottom area to toggle the status.
- Show a label "نشط" or "غير نشط" next to the switch.

#### [MODIFY] [injection_container.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/injection_container.dart)
- Register the new use case and update the `MyServingsBloc` factory.

## Verification Plan

### Manual Verification
- Go to "My Services" page.
- Toggle the switch for a service.
- Verify that the status label changes and a success message appears.
- Refresh the list to ensure the status persists.
