import SwiftUI
import SwiftData

struct AddEmployeeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var role = Role.baker
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Имя") {
                    TextField("Введите имя", text: $name)
                }
                
                Section("Роль") {
                    Picker("Роль", selection: $role) {
                        ForEach(Role.allCases, id: \.self) { role in
                            HStack {
                                Circle()
                                    .fill(Color(hex: role.colorHex))
                                    .frame(width: 10, height: 10)
                                Text(role.rawValue)
                            }
                            .tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Новый сотрудник")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        addEmployee()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func addEmployee() {
        let employee = Employee(name: name, role: role)
        modelContext.insert(employee)
        dismiss()
    }
}
