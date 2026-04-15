# E1RM Calculator - iOS

> **⚠️ This repository is no longer maintained.**
> The iOS app has moved to the unified [e1rm-calculator](https://github.com/gooseyirl/e1rm-calculator) repository alongside the Android app. All future development happens there.

One Rep Max Calculator using RPE (Rate of Perceived Exertion) for iOS.

## Overview

This iOS app is a port of the Android E1RM Calculator, providing accurate one rep max estimates using the RPE-based calculation method popularised by Barbell Medicine and Mike Tuchscherer.

## Features

- **RPE-Based Calculation**: Uses scientifically-backed RPE-to-percentage tables
- **Support for 1-10 Reps**: Works with any rep range from 1 to 10
- **9 RPE Values**: From RPE 6.0 to 10.0 (in 0.5 increments)
- **Training Percentages**: Displays reference percentages from 95% down to 60%
- **Custom Percentage Calculator**: Calculate weight for any percentage (1-100%)
- **Sets Planner**: Plan your full training session — configure a first set and any number of additional sets using RPE targets, percentage reductions/increases, or specific weights. Generate and copy to clipboard
- **Units of Measurement**: Choose between kg and lbs — applied throughout the app
- **Weight Rounding**: Configure rounding increment (0.5 or 2.5) and direction (nearest, always up, always down)
- **Support Developer**: One-time in-app purchase to support development via the App Store
- **Motivational Quotes**: A star and motivational quote shown after donating, using shuffle-bag selection (all 50 quotes shown before any repeat)
- **iOS Native Design**: SwiftUI with iOS system colours and components

## Technical Details

- **Platform**: iOS 17.0+
- **Language**: Swift
- **Framework**: SwiftUI
- **In-App Purchases**: StoreKit 2
- **Orientation**: Portrait only
- **Architecture**: MVVM-lite with SwiftUI state management and `@EnvironmentObject` for shared settings

## Building the App

### Requirements

- Xcode 15.0 or later
- iOS 17.0 SDK or later
- macOS with Apple Silicon or Intel processor

### Steps

1. Clone the repository
2. Open `E1RMCalculator.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run (⌘R)

### Debug Flags

`Store/StoreManager.swift` contains a `debugForceDonated` flag. Set it to `true` to simulate a completed donation for UI testing without making a real purchase.

## How It Works

### RPE Scale

RPE (Rate of Perceived Exertion) is a scale from 1-10 that describes how hard a set feels:

- **RPE 10.0**: Maximum effort - no reps left
- **RPE 9.5**: Could do 1 more rep, maybe
- **RPE 9.0**: Could definitely do 1 more rep
- **RPE 8.5**: Could do 1-2 more reps
- **RPE 8.0**: Could definitely do 2 more reps
- **RPE 7.5**: Could do 2-3 more reps
- **RPE 7.0**: Could definitely do 3 more reps
- **RPE 6.5**: Could do 3-4 more reps
- **RPE 6.0**: Could definitely do 4 more reps

### Calculation Method

The calculator uses a lookup table that maps [RPE value] → [number of reps] → [percentage of 1RM]. For example:

- If you lift 315 lbs for 5 reps at RPE 8.0:
  - RPE 8.0, 5 reps = 81.1% of your 1RM
  - Estimated 1RM = 315 / 0.811 = **388 lbs**

## Usage

1. **Enter Weight**: The weight you lifted
2. **Enter Reps**: Number of repetitions you performed (1-10)
3. **Select RPE**: How hard the set felt (6.0-10.0)
4. **Calculate**: Tap the button to get your estimated 1RM
5. **View Results**: See your 1RM and training percentages
6. **Custom Percentage**: Optionally calculate any percentage of your 1RM
7. **Sets Planner**: Tap the menu (⋯) and select "Sets Planner" to plan a full session
8. **Settings**: Tap the menu (⋯) and select "Settings" to configure units and rounding

## Sets Planner

The Sets Planner lets you configure a complete training session:

1. **First Set**: Enter weight, reps, and RPE for your opening set
2. **Additional Sets**: Add any number of follow-up sets, each configured as:
   - **RPE**: Target RPE and reps — weight calculated from your estimated 1RM
   - **% -/+**: Percentage reduction or increase relative to the previous set's weight
   - **Weight**: A specific weight in your chosen units
3. **Generate**: Tap Generate to compute all weights. Consecutive sets with identical weight and reps are grouped (e.g. "3×5")
4. **Copy**: Copy the full session to clipboard in a clean text format

## Project Structure

```
E1RMCalculator/
├── E1RMCalculatorApp.swift       # App entry point, injects environment objects
├── ContentView.swift              # Main screen with NavigationStack and toolbar menu
├── Models/
│   ├── OneRepMaxCalculator.swift # Core RPE-based calculation logic
│   ├── AppSettings.swift         # ObservableObject for units and rounding settings
│   ├── WeightRounder.swift       # Weight rounding utility (increment + direction)
│   └── MotivationalQuotes.swift  # 50 motivational quotes with shuffle-bag selection
├── Store/
│   └── StoreManager.swift        # StoreKit 2 in-app purchase manager
└── Views/
    ├── SettingsView.swift         # Settings screen (units, rounding increment, direction)
    ├── SetsPlannerView.swift      # Session planning screen
    └── Components/
        ├── InputFieldsView.swift          # Weight/Reps inputs
        ├── RPEPickerView.swift            # RPE selector
        ├── ResultCardView.swift           # 1RM result display
        ├── TrainingPercentagesView.swift  # Percentage table
        └── InfoCardView.swift             # About section
```

## Privacy

This app stores the following data locally on the device using `UserDefaults`:

- **Settings**: Your chosen units (kg/lbs) and rounding preferences
- **Quote state**: Which motivational quotes have been shown (shuffle-bag index)
- **Donation state**: Whether you have completed the "Support Developer" in-app purchase

No data is transmitted off-device. No analytics are collected. No permissions are required beyond StoreKit for the optional in-app purchase.

## Credits

- **Algorithm**: Based on Mike Tuchscherer's RPE chart and Barbell Medicine approach
- **Platform**: iOS port of the Android E1RM Calculator
- **Development**: Built with SwiftUI for iOS

## License

This project is provided as-is for personal use.

## Version History

- **2.0** - Major feature update
  - Sets Planner for full session planning
  - Units of measurement setting (kg/lbs)
  - Weight rounding settings (increment + direction)
  - "Support Developer" one-time in-app purchase via StoreKit 2
  - Motivational quote footer shown after donation (shuffle-bag, 50 quotes)
  - Navigation redesigned with NavigationStack and toolbar menu
- **1.0** - Initial iOS release
  - RPE-based 1RM calculation
  - Training percentages table
  - Custom percentage calculator
  - iOS native design
