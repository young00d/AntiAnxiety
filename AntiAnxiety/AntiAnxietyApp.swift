import SwiftUI
import SwiftData

@main
struct AntiAnxietyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: DailyTapRecord.self)
    }
}
