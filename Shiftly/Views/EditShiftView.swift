import SwiftUI
import SwiftData

struct EditShiftView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var shift: Shift
    @Query var employees: [Employee]
    
    @State private var showingDeleteAlert = false
    
    var hasConflict: Bool {
        guard let employee = shift.employee else { return false }
        return employee.shifts.contains { other in
            other.id != shift.id &&
            shift.date == other.date &&
            shift.startTime < other.endTime &&
            shift.endTime > other.startTime
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Сотрудник") {
                    Picker("Сотрудник", selection: $shift.employee) {
                        Text("Не выбран").tag(Optional<Employee>.none)
                        ForEach(employees) { employee in
                            Text(employee.name).tag(Optional(employee))
                        }
                    }
                }
                
                Section("Дата и время") {
                    DatePicker("Дата", selection: $shift.date, displayedComponents: .date)
                    DatePicker("Начало", selection: $shift.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Конец", selection: $shift.endTime, displayedComponents: .hourAndMinute)
                }
                
                if hasConflict {
                    Section {
                        Label("Конфликт смен у этого сотрудника", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Удалить смену")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Редактировать смену")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                        .disabled(hasConflict)
                }
            }
            .alert("Удалить смену?", isPresented: $showingDeleteAlert) {
                Button("Удалить", role: .destructive) {
                    modelContext.delete(shift)
                    dismiss()
                }
                Button("Отмена", role: .cancel) {}
            }
        }
    }
}
