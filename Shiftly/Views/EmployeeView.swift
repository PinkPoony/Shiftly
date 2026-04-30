import SwiftUI
import SwiftData

struct EmployeesView: View {
    @Query var employees: [Employee]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(employees) { employee in
                    HStack {
                        Circle()
                            .fill(Color(hex: employee.role.colorHex))
                            .frame(width: 12, height: 12)
                        
                        VStack(alignment: .leading) {
                            Text(employee.name)
                                .font(.body)
                            Text(employee.role.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteEmployee)
            }
            .navigationTitle("Сотрудники")
        }
    }
    
    func deleteEmployee(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(employees[index])
        }
    }
}
