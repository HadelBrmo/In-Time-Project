# Walkthrough - Filter Inactive Services from Home Screen

I have updated the `HomeBloc` to ensure that only active services are displayed to users on the home screen, covering both the general search and the nearby services search.

## Changes Made

### Home Feature
- **[HomeBloc](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/home/presentation/bloc/home_bloc.dart)**:
    - Updated `FetchHomeServingsEvent` and `FetchNearbyServingsEvent` handlers to filter the list of services fetched from the server. Only services with `status == 'active'` (or `null`, for backward compatibility/default state) are kept.
    - Updated the `_cloneServiceWithRequestedStatus` helper method to include the `status` field when cloning a `ServiceEntity`, ensuring the status is preserved when the UI state is updated (e.g., when a user requests a service).

## Verification Results

### Manual Verification
1.  Deactivate one of your services from the **My Services** page.
2.  Return to the **Home Screen** and refresh (or perform a search/nearby search).
3.  Verify that the deactivated service no longer appears in the list of available services.
