import SwiftUI
import SwiftData

struct EmployeeView: View {
    @Query var employees: [Employee]
    @Environment(\.modelContext) var modelContext
    
    @State private var showingAddEmployee = false
    @State private var selectedEmployee: Employee?
    
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
                        .onTapGesture {
                            selectedEmployee = employee
                        }
                    }
                }
                .onDelete(perform: deleteEmployee)
            }
            .navigationTitle("Сотрудники")
            .toolbar {
                Button {
                    showingAddEmployee = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddEmployee) {
                AddEmployeeView()
            }
            .sheet(item: $selectedEmployee) { employee in
                EditEmployeeView(employee: employee)
            }
        }
    }
    
    func deleteEmployee(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(employees[index])
        }
    }
}
