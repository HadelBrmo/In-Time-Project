# Enhanced Rewards Feature Implementation Plan

The goal is to update the Rewards feature to reflect the actual data types (weekly, monthly, lifetime) and provide a unique, interactive UI for viewing earned rewards.

## User Review Required

> [!IMPORTANT]
> The design will use high-contrast gradients and glassmorphism elements to achieve the "unique/weird" look requested. I will use `flutter_animate` for smooth entry transitions.

## Proposed Changes

### [Data & Domain Layer]

#### [MODIFY] [rewards_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/data/datasources/rewards_remote_data_source.dart)
- Update `getMyRewards` to return a Record `(List<RewardModel>, int)` containing both the reward list and `total_hours_added`.

#### [MODIFY] [rewards_repository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/domain/repositories/rewards_repository.dart)
- Update signature to return `ApiResult<(List<RewardEntity>, int)>`.

#### [MODIFY] [rewards_repository_impl.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/data/repositories/rewards_repository_impl.dart)
- Implement the record return logic.

#### [MODIFY] [get_rewards_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/domain/usecases/get_rewards_usecase.dart)
- Update signature to match the repository.

---

### [Presentation Layer]

#### [MODIFY] [rewards_state.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/presentation/bloc/rewards_state.dart)
- Update `RewardsLoaded` to include `totalHoursAdded`.

#### [MODIFY] [rewards_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/presentation/bloc/rewards_bloc.dart)
- Update the emission logic to handle the new return type.

#### [NEW] [my_rewards_page.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/presentation/pages/my_rewards_page.dart)
- Create a stylish page to display reward history.
- Feature a "Total Earned" header with a glow effect.
- Use a `ListView` with specialized animated cards for each type (Weekly, Monthly, Lifetime).

#### [MODIFY] [rewards_section.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/presentation/widgets/rewards_section.dart)
- Remove static cards.
- Add a "Total Hours Earned" summary widget.
- Add a "View My Rewards" (عرض مكافآتي) button that navigates to the new page.

#### [MODIFY] [reward_card.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/rewards/presentation/widgets/reward_card.dart)
- Redesign to be more "unique":
    - Dynamic gradients based on type.
    - Glassmorphism background.
    - Icon reflecting the reward status.

---

### [Infrastructure]

#### [MODIFY] [app_routes.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/constants/app_routes.dart)
- Add `/myRewardsPage` route.

#### [MODIFY] [ar.json](file:///C:/Users/User/StudioProjects/In-Time-Project/assets/lang/ar.json)
- Add keys: `view_my_rewards`, `total_hours_earned`, `weekly_reward`, `monthly_reward`, `lifetime_reward`.

## Verification Plan

### Manual Verification
- Navigate to "ساعاتي".
- Verify the "Rewards" section shows the total hours and the "View My Rewards" button.
- Click the button and verify the new page opens with correctly styled cards for each type.
- Verify the data matches the API response (weekly, lifetime).
