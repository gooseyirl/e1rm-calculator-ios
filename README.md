# E1RM Calculator - iOS

One Rep Max Calculator using RPE (Rate of Perceived Exertion) for iOS.

## Overview

This iOS app is a port of the Android E1RM Calculator, providing accurate one rep max estimates using the RPE-based calculation method popularized by Barbell Medicine and Mike Tuchscherer.

## Features

- **RPE-Based Calculation**: Uses scientifically-backed RPE-to-percentage tables
- **Support for 1-10 Reps**: Works with any rep range from 1 to 10
- **9 RPE Values**: From RPE 6.0 to 10.0 (in 0.5 increments)
- **Training Percentages**: Displays reference percentages from 95% down to 60%
- **Custom Percentage Calculator**: Calculate weight for any percentage (1-100%)
- **Privacy-Focused**: No data storage, all calculations in-memory only
- **iOS Native Design**: SwiftUI with iOS system colors and components

## Technical Details

- **Platform**: iOS 17.0+
- **Language**: Swift
- **Framework**: SwiftUI
- **SDK**: iOS 26.2
- **Orientation**: Portrait only
- **Architecture**: MVVM-lite with SwiftUI state management

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

1. **Enter Weight**: The weight you lifted (in lbs or kg)
2. **Enter Reps**: Number of repetitions you performed (1-10)
3. **Select RPE**: How hard the set felt (6.0-10.0)
4. **Calculate**: Tap the button to get your estimated 1RM
5. **View Results**: See your 1RM and training percentages
6. **Custom Percentage**: Optionally calculate any percentage of your 1RM

## Project Structure

```
E1RMCalculator/
├── E1RMCalculatorApp.swift       # App entry point
├── ContentView.swift              # Main screen
├── Models/
│   └── OneRepMaxCalculator.swift # Core calculation logic
└── Views/
    └── Components/
        ├── InputFieldsView.swift          # Weight/Reps inputs
        ├── RPEPickerView.swift            # RPE selector
        ├── ResultCardView.swift           # 1RM result display
        ├── TrainingPercentagesView.swift  # Percentage table
        └── InfoCardView.swift             # About section
```

## Privacy

This app does **not**:
- Store any data persistently
- Track analytics
- Require network connectivity
- Request any permissions
- Share data with third parties

All calculations happen in-memory and are discarded when the app closes.

## Credits

- **Algorithm**: Based on Mike Tuchscherer's RPE chart and Barbell Medicine approach
- **Platform**: iOS port of the Android E1RM Calculator
- **Development**: Built with SwiftUI for iOS

## License

This project is provided as-is for personal use.

## Version History

- **1.0** - Initial iOS release
  - Full feature parity with Android version
  - RPE-based 1RM calculation
  - Training percentages table
  - Custom percentage calculator
  - iOS native design
