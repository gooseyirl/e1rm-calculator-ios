import SwiftUI

@main
struct E1RMCalculatorApp: App {
    @StateObject private var settings = AppSettings()
    @StateObject private var storeManager = StoreManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(storeManager)
        }
    }
}
