# Updated TODO for Home Screen Adjustments

- [x] Previous updates: Theme-aware colors in search_bar.dart and home_screen.dart, SliverAppBar implementation.

Based on user feedback:
- Adjust layout to keep banner, search, and categories fixed/floating (do not scroll them away).
- Make content (starting from Live Classes) scroll under the fixed header.
- Ensure the scrollable content starts right below categories, scrolling up only under the fixed parts.
- Enhance visual appeal without changing the floating structure (e.g., adjust positions, shadows, spacing for "cool" look).
- Retain dark mode fixes.

New Plan Steps:
- [ ] Update lib/screens/pages/home_screen.dart:
  - Revert to Stack with clipBehavior: Clip.none.
  - Fixed banner height ~200px with image.
  - Positioned logo centered at top ~40px.
  - Positioned search bar at top ~120px, full width.
  - Positioned categories horizontal ListView at top ~200px, height 110px.
  - SingleChildScrollView for content: Column starting directly with Live Classes (remove all offset SizedBox), so it scrolls under fixed elements.
  - Adjust banner height, positions for better aesthetics (e.g., add subtle gradients or overlays if needed for cool look).
  - Ensure theme-aware colors are preserved.
- [ ] Test: Run app, verify fixed header, scrolling under, dark mode visibility, and overall cool appearance.
