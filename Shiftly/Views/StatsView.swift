import SwiftUI
import SwiftData

struct StatsView: View {
    @Query var employees: [Employee]
    @Query var shifts: [Shift]
    
    var weekShifts: [Shift] {
        let calendar = Calendar.current
        let now = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else { return [] }
        return shifts.filter { weekInterval.contains($0.date) }
    }
    
    func hoursFor(employee: Employee) -> Double {
        weekShifts
            .filter { $0.employee?.id == employee.id }
            .reduce(0) { $0 + $1.endTime.timeIntervalSince($1.startTime) / 3600 }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Часы за эту неделю") {
                    ForEach(employees) { employee in
                        HStack {
                            Circle()
                                .fill(Color(hex: employee.role.colorHex))
                                .frame(width: 10, height: 10)
                            
                            Text(employee.name)
                            
                            Spacer()
                            
                            Text(String(format: "%.1f ч", hoursFor(employee: employee)))
                                .foregroundStyle(.secondary)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Section("Смен на этой неделе") {
                    HStack {
                        Text("Всего смен")
                        Spacer()
                        Text("\(weekShifts.count)")
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                    }
                }
            }
            .navigationTitle("Статистика")
        }
    }
}
