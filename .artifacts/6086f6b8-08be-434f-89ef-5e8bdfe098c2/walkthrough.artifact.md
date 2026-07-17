# Walkthrough - Added Auto-Cancel Days to Serving Request

I have successfully added the `automatically_cancel_after` parameter to the service request flow. This allows users to specify how many days the request should remain active before being automatically cancelled.

## Changes Made

### Domain Layer
- **[RequestRepository](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/domain/repository/request_repository.dart)**: Added `automaticallyCancelAfter` to `createServingRequest`.
- **[CreateServingRequestUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/domain/usecases/create_serving_request_usecase.dart)**: Updated the use case to pass the new parameter.

### Data Layer
- **[RequestRemoteDataSource](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/data/datasource/request_remote_datasource.dart)**: Updated the API call to include `automatically_cancel_after` in the request body.
- **[RequestRepositoryImpl](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/data/repository/request_repository_impl.dart)**: Updated the implementation to pass the value through.

### Presentation & UI
- **[RequestsEvent](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/bloc/request_event.dart)**: Updated `CreateServingRequestEvent` to include the new field.
- **[RequestsBloc](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/bloc/request_bloc.dart)**: Handled the new field in the Bloc.
- **[showRequestDialog](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/widgets/showRequestDialog.dart)**:
    - Added a numeric input field for "إلغاء الطلب تلقائياً بعد (أيام)".
    - Set a default value of **14 days**.
    - Wrapped the content in a `SingleChildScrollView` to prevent overflow on small screens.

## Verification Results

### Manual Verification
- The dialog now shows the new input field with a default value of 14.
- Sending a request now includes the specified number of days in the payload.
