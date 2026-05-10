import SwiftUI
import SwiftData

struct AddShiftView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var employees: [Employee]
    
    @State private var selectedEmployee: Employee?
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var hasConflict: Bool {
        guard let employee = selectedEmployee else { return false }
        return employee.shifts.contains { shift in
            shift.date == date &&
            startTime < shift.endTime &&
            endTime > shift.startTime
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Сотрудник") {
                    Picker("Выберите сотрудника", selection: $selectedEmployee) {
                        Text("Не выбран").tag(Optional<Employee>.none)
                        ForEach(employees) { employee in
                            Text(employee.name).tag(Optional(employee))
                        }
                    }
                }
                
                Section("Дата и время") {
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                    DatePicker("Начало", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Конец", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                if hasConflict {
                    Section {
                        Label("Конфликт смен у этого сотрудника", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Новая смена")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        addShift()
                    }
                    .disabled(selectedEmployee == nil || endTime <= startTime || hasConflict)
                }
            }
        }
    }
    
    func addShift() {
        guard let employee = selectedEmployee else { return }
        let shift = Shift(date: date, startTime: startTime, endTime: endTime, employee: employee)
        modelContext.insert(shift)
        dismiss()
    }
}
