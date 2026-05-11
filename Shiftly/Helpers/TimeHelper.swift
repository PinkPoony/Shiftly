import Foundation

struct TimeHelper {
    static func times(step: Int = 15) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        return stride(from: 0, to: 24 * 60, by: step).compactMap { minutes in
            calendar.date(byAdding: .minute, value: minutes, to: startOfDay)
        }
    }
    
    static func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}
