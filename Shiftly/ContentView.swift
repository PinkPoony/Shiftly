import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Сегодня", systemImage: "sun.max")
                }
            ScheduleView()
                .tabItem {
                    Label("Расписание", systemImage: "calendar")
                }
            EmployeeView()
                .tabItem {
                    Label("Сотрудники", systemImage: "person.2")
                }
            StatsView()
                .tabItem {
                    Label("Статистика", systemImage: "chart.bar")
                }
            
            
        }
    }
}
