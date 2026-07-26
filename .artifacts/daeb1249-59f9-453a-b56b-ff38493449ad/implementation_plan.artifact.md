# Service Rating Feature Implementation

This plan implements a service rating system that allows users to rate services they have completed, fulfilling the business requirement seen in the Postman tests.

## User Review Required

> [!IMPORTANT]
> - **Rating UI Placement**: To keep the `ServiceDetailsPage` clean, I will place the "Rate Service" trigger inside the **"My Requests" (Activity History)** page. It will appear as a button on any request card that has a `Completed` status.
> - **Interaction Model**: Clicking "Rate" will open a **Rating Bottom Sheet** where the user can select a star rating (1-5).
> - **Validation**: The backend rule "must have a completed request" will be naturally enforced because the UI only shows the button for completed requests.

## Proposed Changes

### 1. Data & Domain Layer

#### [NEW] [rate_service_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/usecases/service/rate_service_usecase.dart)
A use case to handle the `POST /servings/{id}/rate` request.

#### [MODIFY] [services_repository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/repository/services_repository.dart) & [services_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/datasources/services_remote_data_source.dart)
Add `rateService(int serviceId, double rating)` methods to both.

---

### 2. State Management

#### [MODIFY] [services_event.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_event.dart)
Add `RateServiceEvent(int serviceId, double rating)`.

#### [MODIFY] [services_state.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_state.dart)
Add `RateServiceLoadingState`, `RateServiceSuccessState`, and `RateServiceErrorState`.

#### [MODIFY] [services_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_bloc.dart)
Implement the logic to call the use case and emit appropriate states.

---

### 3. UI Implementation

#### [NEW] [rating_bottom_sheet.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/widgets/services/rating_bottom_sheet.dart)
A dedicated UI component using `flutter_rating_bar` (or custom stars) to collect user feedback.

#### [MODIFY] [request_card.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/widgets/request_card.dart)
- Check if `request.status == RequestStatus.completed`.
- If true, display a "⭐ Rate Service" button at the bottom of the card.
- Tie the button to open the `RatingBottomSheet`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to check for syntax errors.

### Manual Verification
- Go to "Activity History" -> "My Requests".
- Find a request with "Completed" status.
- Tap "Rate Service".
- Select a rating and submit.
- Verify success SnackBar and that the button disappears or changes state (if the API supports it).
