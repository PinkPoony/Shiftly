import SwiftUI
import SwiftData
import UserNotifications

@main
struct ShiftlyApp: App {
    init() {
        NotificationHelper.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Employee.self, Shift.self])
    }
}
