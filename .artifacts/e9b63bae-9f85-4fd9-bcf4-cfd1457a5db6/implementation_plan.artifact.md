# Implementation Plan - Limit Service Card Title to Two Words

This plan outlines the changes to display only the first two words of the service title in the service card widgets to ensure a cleaner UI and consistent look.

## Proposed Changes

### Presentation Layer

#### [MODIFY] [build_service_card.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/home/presentation/widgets/home_widget/build_service_card.dart)
- Modify the `Text` widget displaying `serving.title` to use only the first two words.
- Implementation: `serving.title.trim().split(RegExp(r'\s+')).take(2).join(' ')`.

#### [MODIFY] [my_serving_card.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/widgets/my_serving_card.dart)
- Although the user specifically mentioned "build service card", it's best practice to keep the UI consistent across similar components. I will also apply this limit to the title in `MyServingCard`.

## Verification Plan

### Manual Verification
- Run the app and navigate to the Home screen.
- Verify that service titles now display at most two words.
- Navigate to "My Services" (if applicable) and verify the same behavior for `MyServingCard`.
- Check titles with one word, two words, and more than two words to ensure they display correctly.
