import SwiftUI
import SwiftData

struct AddShiftView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var employees: [Employee]
    
    @State private var selectedEmployee: Employee?
    @State private var selectedDays: Set<Date> = []
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var weekOffset = 0
    
    var currentWeekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)!.start
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0 + weekOffset * 7, to: startOfWeek)
        }
    }
    
    var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EE d"
        f.locale = Locale(identifier: "ru_RU")
        return f
    }
    
    var hasConflict: Bool {
        guard let employee = selectedEmployee else { return false }
        return selectedDays.contains { date in
            employee.shifts.contains { shift in
                shift.date == date &&
                startTime < shift.endTime &&
                endTime > shift.startTime
            }
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
                
                Section("Дни") {
                    HStack {
                        Button {
                            weekOffset -= 1
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer()
                        
                        Text(weekRangeText)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Button {
                            weekOffset += 1
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(currentWeekDates, id: \.self) { date in
                            let isSelected = selectedDays.contains(date)
                            VStack(spacing: 4) {
                                Text(dayFormatter.string(from: date))
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color.orange : Color.clear)
                            .foregroundStyle(isSelected ? .white : .primary)
                            .cornerRadius(8)
                            .onTapGesture {
                                if isSelected {
                                    selectedDays.remove(date)
                                } else {
                                    selectedDays.insert(date)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Время") {
                    DatePicker("Начало", selection: $startTime, in: timeRange, displayedComponents: .hourAndMinute)
                        .onChange(of: startTime) {
                            startTime = roundToNearest15(startTime)
                        }

                    DatePicker("Конец", selection: $endTime, in: timeRange, displayedComponents: .hourAndMinute)
                        .onChange(of: endTime) {
                            endTime = roundToNearest15(endTime)
                        }
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
                        addShifts()
                    }
                    .disabled(selectedEmployee == nil || selectedDays.isEmpty || endTime <= startTime || hasConflict)
                }
            }
        }
    }
    
    var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let start = currentWeekDates.first!
        let end = currentWeekDates.last!
        return "\(formatter.string(from: start)) — \(formatter.string(from: end))"
    }
    
    var timeRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: Date())!
        let end = calendar.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        return start...end
    }
    
    func addShifts() {
        guard let employee = selectedEmployee else { return }
        for date in selectedDays {
            let shift = Shift(date: date, startTime: startTime, endTime: endTime, employee: employee)
            modelContext.insert(shift)
        }
        dismiss()
    }
    
    func roundToNearest15(_ date: Date) -> Date {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let rounded = (minutes + 7) / 15 * 15
        return calendar.date(bySetting: .minute, value: rounded % 60, of: date) ?? date
    }
}
