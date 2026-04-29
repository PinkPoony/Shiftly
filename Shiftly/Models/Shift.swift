import Foundation
import SwiftData

@Model
class Shift {
    var id: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var employee: Employee?
    
    init(date: Date, startTime: Date, endTime: Date, employee: Employee? = nil) {
        self.id = UUID()
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.employee = employee
    }
}
