import SwiftUI

struct TrainingPercentagesView: View {
    let oneRepMax: Double
    @EnvironmentObject var settings: AppSettings
    @State private var customPercentage: String = ""

    private let percentages = [95, 90, 85, 80, 75, 70, 65, 60]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("Training Percentages")
                .font(.system(size: 18, weight: .bold))

            // Custom Percentage Calculator
            HStack(spacing: 8) {
                TextField("Custom %", text: $customPercentage)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)

                if let percentage = Int(customPercentage),
                   percentage >= 1 && percentage <= 100 {
                    VStack(spacing: 4) {
                        Text("\(percentage)%")
                            .font(.system(size: 16, weight: .bold))
                        Text("\(formattedWeight(for: percentage)) \(settings.units)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.teal.opacity(0.1))
                    .cornerRadius(8)
                }
            }

            // Percentage Table
            VStack(spacing: 0) {
                ForEach(percentages, id: \.self) { percentage in
                    HStack {
                        Text("\(percentage)%")
                            .font(.system(size: 16, weight: .medium))

                        Spacer()

                        Text("\(formattedWeight(for: percentage)) \(settings.units)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)

                    if percentage != percentages.last {
                        Divider()
                    }
                }
            }
        }
    }

    private func formattedWeight(for percentage: Int) -> String {
        let raw = oneRepMax * Double(percentage) / 100.0
        return WeightRounder.format(raw, rounding: settings.rounding)
    }
}

#Preview {
    TrainingPercentagesView(oneRepMax: 388.4)
        .environmentObject(AppSettings())
        .padding()
}
