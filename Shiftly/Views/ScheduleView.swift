import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Query var shifts: [Shift]
    @State private var weekOffset = 0
    @State private var showingAddShift = false
    
    var currentWeekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)!.start
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0 + weekOffset * 7, to: startOfWeek)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                weekSwitcher
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(currentWeekDates, id: \.self) { date in
                            DayView(date: date, shifts: shiftsFor(date: date))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Расписание")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddShift = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    ShareLink(
                        item: ExportHelper.weekScheduleText(shifts: shiftsForCurrentWeek)
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingAddShift) {
                AddShiftView()
            }
        }
    }
    
    var shiftsForCurrentWeek: [Shift] {
        currentWeekDates.flatMap { date in
            shiftsFor(date: date)
        }
    }
    
    var weekSwitcher: some View {
        HStack {
            Button {
                weekOffset -= 1
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(weekRangeText)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Button {
                weekOffset += 1
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let start = currentWeekDates.first!
        let end = currentWeekDates.last!
        return "\(formatter.string(from: start)) — \(formatter.string(from: end))"
    }
    
    func shiftsFor(date: Date) -> [Shift] {
        let calendar = Calendar.current
        return shifts.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
