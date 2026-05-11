import Foundation

struct ExportHelper {
    static func weekScheduleText(shifts: [Shift]) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE, d MMM"
        dayFormatter.locale = Locale(identifier: "ru_RU")
        
        let grouped = Dictionary(grouping: shifts) { shift in
            calendar.startOfDay(for: shift.date)
        }
        
        let sortedDays = grouped.keys.sorted()
        
        var result = "📅 Расписание Shiftly\n\n"
        
        for day in sortedDays {
            let dayShifts = grouped[day]!.sorted { $0.startTime < $1.startTime }
            result += "📆 \(dayFormatter.string(from: day))\n"
            
            for shift in dayShifts {
                let name = shift.employee?.name ?? "Неизвестно"
                let role = shift.employee?.role.rawValue ?? ""
                let start = formatter.string(from: shift.startTime)
                let end = formatter.string(from: shift.endTime)
                result += "  • \(name) (\(role)) — \(start)-\(end)\n"
            }
            result += "\n"
        }
        
        return result
    }
}
