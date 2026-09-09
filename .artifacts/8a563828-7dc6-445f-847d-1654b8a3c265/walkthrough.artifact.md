# Architecture Fix and Portfolio Upload Implementation Walkthrough

I have successfully restructured the profile feature to follow the project's architecture and fixed the `PortfolioUploadRemoteDataSource` compilation error.

## Changes Made

### 1. Data Layer
- **[NEW] [portfolio_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/data/datasources/portfolio_remote_data_source.dart)**: Created a new data source to handle portfolio-specific API calls (Image, File, and Link uploads).
- **[MODIFY] [profile_repository_impl.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/data/repositories/profile_repository_impl.dart)**: Integrated `PortfolioRemoteDataSource` and implemented the repository methods for uploading portfolio items.

### 2. Domain Layer
- **[MODIFY] [i_profile_repository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/domain/repositories/i_profile_repository.dart)**: Added upload methods to the repository interface.
- **[NEW] Use Cases**: Created `UploadPortfolioImageUseCase`, `UploadPortfolioFileUseCase`, and `UploadPortfolioLinkUseCase` to encapsulate the business logic for each upload type.

### 3. Presentation Layer
- **Renamed Directory**: Fixed a typo by renaming `bloc/protfilo` to `bloc/portfolio`.
- **[MODIFY] [portfolio_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/presentation/bloc/portfolio/portfolio_bloc.dart)**: Updated the Bloc to handle upload events and manage upload states (`Uploading`, `Success`, `Error`).
- **[MODIFY] [profile_page.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/presentation/pages/profile_page.dart)**:
    - Moved upload logic from the UI to `PortfolioBloc`.
    - Added a `BlocListener` to handle loading dialogs and success/error messages.
    - Simplified the widget by removing direct dependency on data sources.

### 4. Dependency Injection
- **[MODIFY] [injection_container.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/injection_container.dart)**: Registered the new data source, repository dependencies, and use cases.

## Verification Results

### Automated Tests
- Ran `dart analyze` on the modified files, confirming that the compilation errors are resolved and no new critical issues were introduced.

### Manual Verification Path
1. Open the Profile page.
2. Tap on "Image", "File", or "Link" in the Portfolio section.
3. Observe that a loading indicator appears while the item is being uploaded.
4. Verify that a success message appears upon completion and the portfolio is automatically refreshed.
