import SwiftUI

struct TrainingPercentagesView: View {
    let oneRepMax: Double

    private let percentages = [95, 90, 85, 80, 75, 70, 65, 60]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("Training Percentages")
                .font(.system(size: 18, weight: .bold))

            // Percentage Table
            VStack(spacing: 0) {
                ForEach(percentages, id: \.self) { percentage in
                    HStack {
                        Text("\(percentage)%")
                            .font(.system(size: 16, weight: .medium))

                        Spacer()

                        Text("\(calculatedWeight(for: percentage)) lbs/kg")
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

    private func calculatedWeight(for percentage: Int) -> Int {
        Int((oneRepMax * Double(percentage) / 100.0).rounded())
    }
}

#Preview {
    TrainingPercentagesView(oneRepMax: 388.4)
        .padding()
}
