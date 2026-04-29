import Foundation
import SwiftData

@Model
class Employee {
    var id: UUID
    var name: String
    var role: Role
    
    @Relationship(deleteRule: .cascade, inverse: \Shift.employee)
    var shifts: [Shift]
    
    init(name: String, role: Role) {
        self.id = UUID()
        self.name = name
        self.role = role
        self.shifts = []
    }
}
