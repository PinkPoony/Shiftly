import SwiftUI

struct EditEmployeeView: View {
    @Environment(\.dismiss) var dismiss
    
    @Bindable var employee: Employee
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Имя") {
                    TextField("Введите имя", text: $employee.name)
                }
                
                Section("Роль") {
                    Picker("Роль", selection: $employee.role) {
                        ForEach(Role.allCases, id: \.self) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
        }
    }
}
