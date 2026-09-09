# Fix Image Loading for Local File URIs

The app currently crashes or fails to display images when the `imageUrl` provided by the backend or user input is a local file URI (e.g., `file:///storage/...`). This is because `Image.network` is used exclusively, which expects a host (http/https).

## Proposed Changes

### Core Component

#### [NEW] [custom_image_view.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/widgets/custom_image_view.dart)
Create a reusable widget that handles different image sources:
- Network (http/https)
- Local Files (file:// or absolute paths)
- Assets (assets/...)
- Fallback/Error states

### Feature Modifications

#### [MODIFY] [build_service_card.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/home/presentation/widgets/home_widget/build_service_card.dart)
Replace `Image.network` with `CustomImageView`.

#### [MODIFY] [build_details_body.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/home/presentation/widgets/service_details/build_details_body.dart)
Replace `Image.network` with `CustomImageView` while maintaining `Hero` animation.

#### [MODIFY] [portfolio_page.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/profile/presentation/pages/portfolio_page.dart)
Replace `Image.network` with `CustomImageView`.

## Verification Plan

### Manual Verification
1. Test with a standard network URL (e.g., https://via.placeholder.com/150).
2. Test with a local file URI if possible in the emulator/device (e.g., `file:///sdcard/Download/test.png`).
3. Verify that the app no longer throws `ArgumentError: No host specified in URI` when encountering a `file:///` path.
4. Verify `Hero` animations still work correctly in service details.
