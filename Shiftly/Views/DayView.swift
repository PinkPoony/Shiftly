import SwiftUI

struct DayView: View {
    @State private var selectedShift: Shift?
    let date: Date
    let shifts: [Shift]
    
    var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMM"
        f.locale = Locale(identifier: "ru_RU")
        return f
    }
    
    var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dayFormatter.string(from: date))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            if shifts.isEmpty {
                Text("Нет смен")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.vertical, 4)
            } else {
                ForEach(shifts) { shift in
                    HStack {
                        Rectangle()
                            .fill(Color(hex: shift.employee?.role.colorHex ?? "#888888"))
                            .frame(width: 3)
                            .cornerRadius(2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(shift.employee?.name ?? "Неизвестно")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("\(timeFormatter.string(from: shift.startTime)) — \(timeFormatter.string(from: shift.endTime))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(shift.employee?.role.rawValue ?? "")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: shift.employee?.role.colorHex ?? "#888888").opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(10)
                    .background(Color(hex: shift.employee?.role.colorHex ?? "#888888").opacity(0.08))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedShift = shift
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .sheet(item: $selectedShift) { shift in
            EditShiftView(shift: shift)
        }
    }
}
