# App Store Submission Checklist for E1RM Calculator

## Before Submission

### Assets Prepared
- [ ] App Icon (1024x1024) - Generated in `AppIcon/`
- [ ] Screenshots for iPhone 6.7" (1290 x 2796)
- [ ] Screenshots for iPhone 6.5" (1284 x 2778)
- [ ] Screenshots for iPhone 5.5" (1242 x 2208)

### Metadata Ready
- [ ] App Name (30 chars max)
- [ ] Subtitle (30 chars max)
- [ ] Description (4000 chars max)
- [ ] Keywords (100 chars max)
- [ ] Promotional Text (170 chars max)
- [ ] What's New / Release Notes
- [ ] Support URL
- [ ] Privacy Policy URL (hosted online)
- [ ] Copyright text

### App Store Connect Setup
- [ ] Create new app in App Store Connect
- [ ] Set Bundle ID: `com.e1rm.calculator`
- [ ] Select primary category: Health & Fitness
- [ ] Select secondary category: Utilities
- [ ] Set age rating: 4+
- [ ] Configure pricing (Free)

### Privacy & Legal
- [ ] Host privacy policy HTML file online
- [ ] Update privacy policy with your contact email
- [ ] Update privacy policy with current date
- [ ] Fill in App Privacy questionnaire in App Store Connect
  - Select "Data Not Collected"

### Xcode Preparation
- [ ] Set version number (1.0)
- [ ] Set build number (1)
- [ ] Verify Bundle Identifier matches App Store Connect
- [ ] Select "Any iOS Device" as build target
- [ ] Archive the app (Product > Archive)
- [ ] Validate the archive
- [ ] Upload to App Store Connect

### Final Review
- [ ] Test app on real device
- [ ] Verify all features work correctly
- [ ] Check app launches without issues
- [ ] Review all screenshots are accurate
- [ ] Proofread all text content

## Screenshot Guidelines

App Store requires these screenshot sizes for iPhone:

| Display Size | Resolution | Required |
|-------------|------------|----------|
| 6.7" | 1290 x 2796 | Yes |
| 6.5" | 1284 x 2778 | Yes (or 6.7") |
| 5.5" | 1242 x 2208 | Yes |

### Recommended Screenshots:
1. **Input Screen** - Clean UI showing weight/reps/RPE inputs
2. **Results View** - Calculated 1RM prominently displayed
3. **Training Percentages** - The percentage table feature
4. **Custom Calculator** - Custom percentage feature
5. **RPE Info** - Educational content about RPE

## Quick Commands

```bash
# Run screenshot capture
./AppStoreAssets/capture_screenshots.sh

# Archive app in Xcode
xcodebuild -project E1RMCalculator.xcodeproj -scheme E1RMCalculator -archivePath build/E1RMCalculator.xcarchive archive

# Validate archive
xcrun altool --validate-app -f build/E1RMCalculator.ipa -t ios
```

## Useful Links

- [App Store Connect](https://appstoreconnect.apple.com)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Screenshot Specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
