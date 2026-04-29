import SwiftUI
import SwiftData

@main
struct ShiftlyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Employee.self, Shift.self])
    }
}
