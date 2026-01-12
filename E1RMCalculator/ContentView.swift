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

                // Placeholder for future content
                Text("Input fields will go here")
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    ContentView()
}
