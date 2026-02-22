import SwiftUI

struct CalendarView: View {
    var tapManager: TapManager
    @State private var displayedMonth: Date = Date()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdays = ["日", "一", "二", "三", "四", "五", "六"]

    var body: some View {
        VStack(spacing: 16) {
            // Month navigation
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }

                Spacer()

                Text(monthYearString(displayedMonth))
                    .font(.headline)

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
            }
            .padding(.horizontal, 24)

            // Weekday headers
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(height: 30)
                }
            }
            .padding(.horizontal, 12)

            // Day cells
            let days = daysInMonth()
            let dataMap = dataForMonth()
            let maxCount = dataMap.values.max() ?? 1

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(days, id: \.self) { day in
                    if day == 0 {
                        // Empty spacer for alignment
                        Color.clear
                            .frame(height: 52)
                    } else {
                        let count = dataMap[day] ?? 0
                        dayCellView(day: day, count: count, maxCount: maxCount)
                    }
                }
            }
            .padding(.horizontal, 12)

            // Monthly total
            let totalThisMonth = dataMap.values.reduce(0, +)
            if totalThisMonth > 0 {
                Text("本月共 \(totalThisMonth) 次")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }

    @ViewBuilder
    func dayCellView(day: Int, count: Int, maxCount: Int) -> some View {
        let isToday = isTodayDay(day)
        let intensity = maxCount > 0 ? Double(count) / Double(maxCount) : 0

        VStack(spacing: 2) {
            Text("\(day)")
                .font(.system(size: 14, weight: isToday ? .bold : .regular))
                .foregroundStyle(isToday ? Color.accentColor : .primary)

            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            } else {
                Text(" ")
                    .font(.system(size: 10))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 52)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(count > 0
                      ? Color.accentColor.opacity(0.08 + intensity * 0.2)
                      : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday ? Color.accentColor.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
    }

    // MARK: - Helpers

    private func changeMonth(by value: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            displayedMonth = Calendar.current.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
        }
    }

    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: date)
    }

    private func daysInMonth() -> [Int] {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstDay = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }

        let weekday = calendar.component(.weekday, from: firstDay)
        // weekday: 1=Sun, 2=Mon, ...
        let leadingBlanks = weekday - 1

        var days: [Int] = Array(repeating: 0, count: leadingBlanks)
        days += Array(range)
        return days
    }

    private func dataForMonth() -> [Int: Int] {
        let records = tapManager.records(for: displayedMonth)
        var map: [Int: Int] = [:]
        let calendar = Calendar.current
        for record in records {
            let day = calendar.component(.day, from: record.date)
            map[day] = record.tapCount
        }
        return map
    }

    private func isTodayDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentComps = calendar.dateComponents([.year, .month], from: now)
        let displayedComps = calendar.dateComponents([.year, .month], from: displayedMonth)
        return currentComps.year == displayedComps.year
            && currentComps.month == displayedComps.month
            && calendar.component(.day, from: now) == day
    }
}

#Preview {
    CalendarView(tapManager: .preview)
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
