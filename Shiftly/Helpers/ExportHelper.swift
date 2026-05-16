import Foundation

struct ExportHelper {
    static func weekScheduleText(shifts: [Shift]) -> String {
        let calendar = Calendar.current
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EE dd.MM"
        dayFormatter.locale = Locale(identifier: "ru_RU")
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let rangeFormatter = DateFormatter()
        rangeFormatter.dateFormat = "d MMM"
        rangeFormatter.locale = Locale(identifier: "ru_RU")
        
        let grouped = Dictionary(grouping: shifts) { shift in
            calendar.startOfDay(for: shift.date)
        }
        
        let sortedDays = grouped.keys.sorted()
        
        guard let first = sortedDays.first, let last = sortedDays.last else {
            return "Расписание пусто"
        }
        
        var result = "Расписание \(rangeFormatter.string(from: first))–\(rangeFormatter.string(from: last))\n\n"
        
        for day in sortedDays {
            let dayShifts = grouped[day]!.sorted { $0.startTime < $1.startTime }
            result += "\(dayFormatter.string(from: day))\n"
            
            let timeGrouped = Dictionary(grouping: dayShifts) { shift in
                "\(timeFormatter.string(from: shift.startTime))–\(timeFormatter.string(from: shift.endTime))"
            }
            
            let sortedTimes = timeGrouped.keys.sorted()
            for time in sortedTimes {
                let names = timeGrouped[time]!.map { $0.employee?.name ?? "?" }.joined(separator: ", ")
                result += "\(time) \(names)\n"
            }
            result += "\n"
        }
        
        return result
    }
}
