# Google Play Store Release Checklist

Before building the final App Bundle (AAB), ensure the following steps are completed.

## 1. Store Assets & Metadata
- [ ] **App Icon:** Ensure high-res launcher icons are generated/updated.
- [ ] **Screenshots & Feature Graphic:** Prepare localized screenshots (phone, tablet) and a 1024x500 feature graphic.
- [ ] **Store Listing:** Update title, short description, and full description.

## 2. Licenses & Legal
- [ ] **Privacy Policy:** Ensure a valid Privacy Policy URL is available for the Play Console.
- [ ] **Open Source Licenses:** Verify that third-party licenses are accessible in-app if required.
- [ ] **Content Ratings:** Ensure content rating questionnaires are up-to-date in the Play Console.

## 3. Final Store Listing Checks
- [ ] **Contact Info:** Ensure support email or website URL is correct for users to report bugs.
- [ ] **Category & Tags:** Double-check that your app is placed in the right category (e.g., Trivia/Educational) with accurate tags.

## 4. User Experience & Live Testing
- [ ] **Feedback/Rating Prompt:** Ensure you have a way to ask users to rate the app or provide feedback.
- [ ] **External APIs & Databases:** Very important: verify production URLs/keys are in place instead of staging/dev keys.
- [ ] **Ads & In-App Purchases:** (If applicable) Ensure test ad units are swapped for live ones, and IAPs are configured in the Play Console.

*(Once you've cleared this checklist, proceed to `docs/how-to-build-aab.md` to run your technical pre-checks and actually build the app!)*
