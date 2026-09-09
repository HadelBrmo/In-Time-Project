# Separate Identity Verification into a Dedicated Feature

This plan outlines the steps to extract "Identity Verification" (currently "Signup Stage 3") from the `auth` feature and move it into its own dedicated `verification` feature. This will improve code organization and separation of concerns.

## Proposed Changes

### [NEW] Verification Feature Structure
Create the standard feature structure for `lib/features/verification/`.

#### [NEW] Verification Feature Directory
`lib/features/verification/data/datasources/`
`lib/features/verification/data/models/`
`lib/features/verification/data/repositories/`
`lib/features/verification/domain/entities/`
`lib/features/verification/domain/repositories/`
`lib/features/verification/domain/usecases/`
`lib/features/verification/presentation/bloc/`
`lib/features/verification/presentation/pages/`
`lib/features/verification/presentation/widgets/`

---

### Domain Layer

#### [MODIFY] [IdentityStatusEntity](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/domain/entities/identity_status_entity.dart) -> [IdentityStatusEntity](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/domain/entities/identity_status_entity.dart)
Move to the new feature and update package name in imports.

#### [NEW] [VerificationRepository](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/domain/repositories/verification_repository.dart)
Define the repository interface for verification.
- `Future<Either<Failure, String>> verifyIdentity();`
- `Future<Either<Failure, IdentityStatusEntity>> getIdentityStatus();`

#### [MODIFY] [VerifyIdentityUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/domain/usecases/verify_identity_usecase.dart) -> [VerifyIdentityUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/domain/usecases/verify_identity_usecase.dart)
Move and update to use `VerificationRepository`.

#### [MODIFY] [GetIdentityStatusUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/domain/usecases/get_identity_status_usecase.dart) -> [GetIdentityStatusUseCase](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/domain/usecases/get_identity_status_usecase.dart)
Move and update to use `VerificationRepository`.

---

### Data Layer

#### [MODIFY] [IdentityStatusModel](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/data/models/identity_status_model.dart) -> [IdentityStatusModel](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/data/models/identity_status_model.dart)
Move to the new feature and update imports.

#### [NEW] [VerificationRemoteDataSource](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/data/datasources/verification_remote_data_source.dart)
Extract verification methods from `AuthRemoteDataSource`.

#### [NEW] [VerificationRepositoryImpl](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/data/repositories/verification_repository_impl.dart)
Implement `VerificationRepository` using `VerificationRemoteDataSource`.

---

### Presentation Layer

#### [MODIFY] [IdentityVerificationCubit](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/presentation/bloc/identity_verification/identity_verification_cubit.dart) -> [IdentityVerificationCubit](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/presentation/bloc/identity_verification_cubit.dart)
Move and update imports.

#### [MODIFY] [IdentityVerificationState](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/presentation/bloc/identity_verification/identity_verification_state.dart) -> [IdentityVerificationState](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/presentation/bloc/identity_verification_state.dart)
Move and update imports.

#### [MODIFY] [SignUpPage3](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/presentation/pages/sign_up/sign_up_page_03.dart) -> [VerificationPage](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/verification/presentation/pages/verification_page.dart)
Move, rename, and update imports.

---

### Core & Configuration

#### [MODIFY] [AuthRepository](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/domain/repositories/auth_repository.dart)
Remove verification methods.

#### [MODIFY] [AuthRepositoryImpl](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/data/repositories/auth_repository_impl.dart)
Remove verification implementations.

#### [MODIFY] [AuthRemoteDataSource](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/auth/data/datasources/auth_remote_data_source.dart)
Remove verification methods.

#### [MODIFY] [InjectionContainer](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/injection_container.dart)
Register new `verification` feature dependencies.

#### [MODIFY] [AppRoutes](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/constants/app_routes.dart)
Update route for verification page.

## Verification Plan

### Automated Tests
- Run existing tests for `IdentityVerificationCubit` and `GetIdentityStatusUseCase` after moving them to ensure they still pass (after updating imports).

### Manual Verification
- Verify that the signup flow still redirects to the verification page correctly.
- Verify that the verification page functions as expected (starting verification, checking status).
