import SwiftUI

struct TimePickerView: View {
    @Binding var time: Date
    let label: String
    
    private let hours = Array(5...22)
    private let minutes = stride(from: 0, to: 60, by: 5).map { $0 }
    
    private var selectedHour: Int {
        Calendar.current.component(.hour, from: time)
    }
    
    private var selectedMinute: Int {
        Calendar.current.component(.minute, from: time)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 0) {
                    Picker("Часы", selection: Binding(
                        get: { selectedHour },
                        set: { setHour($0) }
                    )) {
                        ForEach(hours, id: \.self) { hour in
                            Text(String(format: "%02d", hour)).tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    
                    Text(":")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Picker("Минуты", selection: Binding(
                        get: { selectedMinute },
                        set: { setMinute($0) }
                    )) {
                        ForEach(minutes, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    func setHour(_ hour: Int) {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: time)
        time = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: time) ?? time
    }
    
    func setMinute(_ minute: Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        time = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: time) ?? time
    }
}
