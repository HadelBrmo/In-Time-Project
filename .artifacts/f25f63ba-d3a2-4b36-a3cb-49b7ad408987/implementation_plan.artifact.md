# Implementation Plan - Synchronize Proposed Services Card Design

The goal is to make the "Proposed Services" section in the Home Screen use the exact same design and behavior as the main service cards, including animations and layout consistency.

## User Review Required

> [!IMPORTANT]
> I will be applying the same animation effects (`fade` and `slideY`) to the proposed services cards to match the main list. I will also adjust the card width in the horizontal list to `width * 0.75` to make it look more like a standard carousel and ensure it matches the visual weight of the main list cards.

## Proposed Changes

### Presentation Layer

#### [MODIFY] [home_screen.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/home/presentation/pages/home_screen.dart)
- Update `_buildProposedServicesSection` to:
    - Add the animation chain (`.animate().fade().slideY()`) to the cards.
    - Adjust the `Container` width from `width * 0.85` to `width * 0.75` for better visibility of the next items.
    - Ensure margins and padding are consistent with the main list's appearance.

## Verification Plan

### Manual Verification
- Run the app and navigate to the Home screen.
- Scroll to the "Proposed Services" section.
- Verify that the cards now animate into view just like the main service list.
- Verify that the design (borders, shadows, glowing effect) is identical to the main list cards.
