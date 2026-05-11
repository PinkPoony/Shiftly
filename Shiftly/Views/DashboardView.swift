import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query var shifts: [Shift]
    
    var todayShifts: [Shift] {
        let calendar = Calendar.current
        return shifts.filter { calendar.isDateInToday($0.date) }
            .sorted { $0.startTime < $1.startTime }
    }
    
    var nextShift: Shift? {
        let now = Date()
        return shifts
            .filter { $0.startTime > now }
            .sorted { $0.startTime < $1.startTime }
            .first
    }
    
    var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }
    
    var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "d MMM, HH:mm"
        f.locale = Locale(identifier: "ru_RU")
        return f
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Сегодня
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Сегодня")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        if todayShifts.isEmpty {
                            Text("Смен нет")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        } else {
                            ForEach(todayShifts) { shift in
                                HStack {
                                    Rectangle()
                                        .fill(Color(hex: shift.employee?.role.colorHex ?? "#888888"))
                                        .frame(width: 3)
                                        .cornerRadius(2)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(shift.employee?.name ?? "Неизвестно")
                                            .fontWeight(.medium)
                                        Text("\(timeFormatter.string(from: shift.startTime)) — \(timeFormatter.string(from: shift.endTime))")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(shift.employee?.role.rawValue ?? "")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(hex: shift.employee?.role.colorHex ?? "#888888").opacity(0.2))
                                        .cornerRadius(8)
                                }
                                .padding(12)
                                .background(Color(hex: shift.employee?.role.colorHex ?? "#888888").opacity(0.08))
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Ближайшая смена
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ближайшая смена")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        if let shift = nextShift {
                            HStack {
                                Rectangle()
                                    .fill(Color(hex: shift.employee?.role.colorHex ?? "#888888"))
                                    .frame(width: 3)
                                    .cornerRadius(2)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(shift.employee?.name ?? "Неизвестно")
                                        .fontWeight(.medium)
                                    Text(dateFormatter.string(from: shift.startTime))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(hex: shift.employee?.role.colorHex ?? "#888888").opacity(0.08))
                            .cornerRadius(10)
                        } else {
                            Text("Нет запланированных смен")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Shiftly")
        }
    }
}
