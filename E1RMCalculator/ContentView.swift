import SwiftUI

struct ContentView: View {
    // MARK: - State Properties
    @State private var weight: String = ""
    @State private var reps: String = ""
    @State private var selectedRPE: Double = 8.0
    @State private var calculatedMax: Double? = nil
    @State private var customPercentage: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Header Section
                VStack(spacing: 8) {
                    Text("E1RM Calculator")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)

                    Text("One Rep Max Estimator")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)

                // MARK: - Input Section
                InputFieldsView(weight: $weight, reps: $reps)

                RPEPickerView(selectedRPE: $selectedRPE)

                // MARK: - Calculate Button
                Button(action: {
                    if let w = Double(weight), let r = Int(reps) {
                        calculatedMax = OneRepMaxCalculator.calculateOneRepMax(
                            weight: w,
                            reps: r,
                            rpe: selectedRPE
                        )
                        // Dismiss keyboard
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }) {
                    Text("Calculate 1RM")
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(weight.isEmpty || reps.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(weight.isEmpty || reps.isEmpty)

                // MARK: - Result Section
                if let max = calculatedMax {
                    ResultCardView(oneRepMax: max)
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    ContentView()
}
