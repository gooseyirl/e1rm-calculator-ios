import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("E1RM Calculator")
                .font(.largeTitle)
                .bold()

            Text("One Rep Max Estimator")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
