# Implementation Plan - Add `automatically_cancel_after` to Serving Request

This plan outlines the changes required to add the `automatically_cancel_after` parameter to the "Create Serving Request" flow. This parameter indicates the number of days after which the request will be automatically cancelled.

## User Review Required

> [!IMPORTANT]
> I will add a numeric input field in the request dialog for the user to specify the number of days.
> I'll set a default value of **14 days** if the user doesn't specify otherwise, as shown in your Postman example.

## Proposed Changes

### Domain Layer

#### [MODIFY] [RequestRepository](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/domain/repository/request_repository.dart)
- Update `createServingRequest` signature to include `int? automaticallyCancelAfter`.

#### [MODIFY] [CreateServingRequestUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/domain/usecases/create_serving_request_usecase.dart)
- Update `call` method signature and implementation to include `int? automaticallyCancelAfter`.

---

### Data Layer

#### [MODIFY] [RequestRemoteDataSource](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/data/datasource/request_remote_datasource.dart)
- Update `createServingRequest` signature in both abstract class and implementation.
- Include `automatically_cancel_after` in the Dio POST request body.

#### [MODIFY] [RequestRepositoryImpl](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/data/repository/request_repository_impl.dart)
- Update `createServingRequest` implementation to pass the new parameter to the datasource.

---

### Presentation Layer

#### [MODIFY] [RequestsEvent](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/bloc/request_event.dart)
- Update `CreateServingRequestEvent` to include `int? automaticallyCancelAfter`.

#### [MODIFY] [RequestsBloc](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/bloc/request_bloc.dart)
- Update the handler for `CreateServingRequestEvent` to pass the new parameter to the use case.

#### [MODIFY] [showRequestDialog](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/widgets/showRequestDialog.dart)
- Add a new `TextField` for entering the number of days.
- Ensure the input is validated to be an integer.
- Pass this value when dispatching the `CreateServingRequestEvent`.

## Verification Plan

### Manual Verification
- Open the service details and click the "Request Service" button.
- Verify that a new field for "Auto-cancel days" (or similar label) appears.
- Try sending a request with a custom number of days and verify (via logs or network inspector if available) that `automatically_cancel_after` is sent correctly.
- Try sending a request without entering a value and ensure it handles it (either by sending null or a default).
