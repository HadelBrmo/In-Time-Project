# Fix Profile Feature Architecture and Portfolio Uploads

The user reported a compilation error regarding `PortfolioUploadRemoteDataSource` and noted that the profile feature doesn't follow the project's architecture. I will restructure the portfolio upload logic to follow the `presentation -> domain -> data` flow, fix the missing types, and correct architectural violations.

## User Review Required

> [!IMPORTANT]
> I will be renaming the directory `features/profile/presentation/bloc/protfilo` to `features/profile/presentation/bloc/portfolio` to fix the typo. This will affect imports in `profile_page.dart` and `portfolio_page.dart`.

## Proposed Changes

### Data Layer

#### [NEW] [portfolio_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/data/datasources/portfolio_remote_data_source.dart)
Modify existing `ProfileRemoteDataSource` or create a specific one for portfolio if it helps separation. Given the user's error mentions `PortfolioUploadRemoteDataSource`, I will create a new one to match their expectation but integrate it properly.

#### [MODIFY] [profile_repository_impl.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/data/repositories/profile_repository_impl.dart)
Implement the new upload methods in the repository.

### Domain Layer

#### [MODIFY] [i_profile_repository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/domain/repositories/i_profile_repository.dart)
Add `uploadPortfolioImage`, `uploadPortfolioFile`, and `uploadPortfolioLink` to the interface.

#### [NEW] [upload_portfolio_image_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/domain/usecases/upload_portfolio_image_usecase.dart)
#### [NEW] [upload_portfolio_file_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/domain/usecases/upload_portfolio_file_usecase.dart)
#### [NEW] [upload_portfolio_link_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/domain/usecases/upload_portfolio_link_usecase.dart)

### Presentation Layer

#### [MODIFY] [portfolio_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/presentation/bloc/portfolio/portfolio_bloc.dart)
Add events and states for uploading items.

#### [MODIFY] [profile_page.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/presentation/pages/profile_page.dart)
Move upload logic to `PortfolioBloc` and use `BlocListener` to handle success/error messages and loading states.

### Dependency Injection

#### [MODIFY] [injection_container.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/injection_container.dart)
Register the new data source and use cases.

## Verification Plan

### Automated Tests
- I will check for syntax errors and ensure the project compiles.

### Manual Verification
- The user can verify that picking an image/file/link now triggers a Bloc event and shows the loading indicator correctly.
