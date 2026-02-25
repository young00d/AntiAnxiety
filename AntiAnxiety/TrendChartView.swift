import SwiftUI
import Charts

struct TrendChartView: View {
    var tapManager: TapManager
    var skin: SkinType
    @State private var chartMode: ChartMode = .monthly
    @State private var selectedMonth: Date = Date()
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())

    enum ChartMode: String, CaseIterable {
        case monthly = "月"
        case yearly = "年"
    }

    private var accentColor: Color {
        switch skin {
        case .threeBody: return Color(red: 0.87, green: 0.255, blue: 0.255) // Red Shore red
        case .woodenFish: return .brown
        case .cat: return Color(red: 0.80, green: 0.45, blue: 0.42)
        }
    }

    private var textColor: Color {
        .primary
    }

    private var secondaryTextColor: Color {
        .secondary
    }

    var body: some View {
        VStack(spacing: 20) {
            // Custom tab switcher
            chartTabSwitcher
                .padding(.horizontal, 24)

            switch chartMode {
            case .monthly:
                monthlySection
            case .yearly:
                yearlySection
            }
        }
    }

    // MARK: - Monthly Chart

    private var monthlySection: some View {
        VStack(spacing: 16) {
            // Month nav
            HStack {
                Button {
                    selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(accentColor)
                }

                Spacer()

                Text(monthString(selectedMonth))
                    .font(.headline)
                    .foregroundStyle(textColor)

                Spacer()

                Button {
                    selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(accentColor)
                }
            }
            .padding(.horizontal, 24)

            let data = monthlyData()

            if data.isEmpty || data.allSatisfy({ $0.count == 0 }) {
                emptyChartPlaceholder
            } else {
                Chart(data, id: \.day) { item in
                    LineMark(
                        x: .value("日", item.day),
                        y: .value("次数", item.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(accentColor)

                    AreaMark(
                        x: .value("日", item.day),
                        y: .value("次数", item.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [accentColor.opacity(0.3), accentColor.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .chartXAxisLabel("日期")
                .chartYAxisLabel("次数")
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .foregroundStyle(secondaryTextColor)
                        AxisGridLine()
                            .foregroundStyle(secondaryTextColor.opacity(0.3))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .foregroundStyle(secondaryTextColor)
                        AxisGridLine()
                            .foregroundStyle(secondaryTextColor.opacity(0.3))
                    }
                }
                .frame(height: 220)
                .padding(.horizontal, 16)
            }

            // Monthly summary
            let total = data.reduce(0) { $0 + $1.count }
            let avg = data.isEmpty ? 0 : total / data.count
            HStack(spacing: 32) {
                statBadge(label: "总计", value: "\(total)")
                statBadge(label: "日均", value: "\(avg)")
                statBadge(label: "最高", value: "\(data.map(\.count).max() ?? 0)")
            }
        }
    }

    // MARK: - Yearly Chart

    private var yearlySection: some View {
        VStack(spacing: 16) {
            // Year nav
            HStack {
                Button {
                    selectedYear -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(accentColor)
                }

                Spacer()

                Text("\(String(selectedYear))年")
                    .font(.headline)
                    .foregroundStyle(textColor)

                Spacer()

                Button {
                    selectedYear += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(accentColor)
                }
            }
            .padding(.horizontal, 24)

            let data = yearlyData()

            if data.isEmpty || data.allSatisfy({ $0.count == 0 }) {
                emptyChartPlaceholder
            } else {
                Chart(data, id: \.month) { item in
                    LineMark(
                        x: .value("月", item.month),
                        y: .value("次数", item.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(accentColor)

                    AreaMark(
                        x: .value("月", item.month),
                        y: .value("次数", item.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [accentColor.opacity(0.3), accentColor.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    PointMark(
                        x: .value("月", item.month),
                        y: .value("次数", item.count)
                    )
                    .foregroundStyle(accentColor)
                }
                .chartXAxisLabel("月份")
                .chartYAxisLabel("次数")
                .chartXScale(domain: 1...12)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .foregroundStyle(secondaryTextColor)
                        AxisGridLine()
                            .foregroundStyle(secondaryTextColor.opacity(0.3))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .foregroundStyle(secondaryTextColor)
                        AxisGridLine()
                            .foregroundStyle(secondaryTextColor.opacity(0.3))
                    }
                }
                .frame(height: 220)
                .padding(.horizontal, 16)
            }

            // Yearly summary
            let total = data.reduce(0) { $0 + $1.count }
            let activeDays = yearlyActiveDays()
            HStack(spacing: 32) {
                statBadge(label: "年度总计", value: "\(total)")
                statBadge(label: "活跃天数", value: "\(activeDays)")
            }
        }
    }

    // MARK: - Tab Switcher

    private var chartTabSwitcher: some View {
        let bgColor: Color = Color.black.opacity(0.06)
        return HStack(spacing: 0) {
            ForEach(ChartMode.allCases, id: \.self) { mode in
                tabButton(for: mode)
            }
        }
        .padding(3)
        .background(Capsule().fill(bgColor))
    }

    private func tabButton(for mode: ChartMode) -> some View {
        let isSelected = chartMode == mode
        let textColor: Color = isSelected ? .white : secondaryTextColor
        let bgFill: Color = isSelected ? accentColor.opacity(0.8) : Color.clear
        let weight: Font.Weight = isSelected ? .semibold : .regular

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                chartMode = mode
            }
        } label: {
            Text(mode.rawValue)
                .font(.system(size: 14, weight: weight))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Capsule().fill(bgFill))
        }
    }

    // MARK: - Helpers

    private var emptyChartPlaceholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundStyle(secondaryTextColor.opacity(0.5))
            Text("暂无数据")
                .font(.subheadline)
                .foregroundStyle(secondaryTextColor)
        }
        .frame(height: 220)
    }

    private func statBadge(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(secondaryTextColor)
        }
    }

    private func monthString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: date)
    }

    private func monthlyData() -> [DailyPoint] {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: selectedMonth)
        guard let firstDay = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }

        let records = tapManager.records(for: selectedMonth)
        var map: [Int: Int] = [:]
        for record in records {
            let day = calendar.component(.day, from: record.date)
            map[day] = record.tapCount
        }

        return range.map { day in
            DailyPoint(day: day, count: map[day] ?? 0)
        }
    }

    private func yearlyData() -> [MonthlyPoint] {
        let calendar = Calendar.current
        var result: [MonthlyPoint] = []

        for month in 1...12 {
            var comps = DateComponents()
            comps.year = selectedYear
            comps.month = month
            guard let monthDate = calendar.date(from: comps) else { continue }
            let records = tapManager.records(for: monthDate)
            let total = records.reduce(0) { $0 + $1.tapCount }
            result.append(MonthlyPoint(month: month, count: total))
        }
        return result
    }

    private func yearlyActiveDays() -> Int {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = selectedYear
        comps.month = 1
        comps.day = 1
        guard let start = calendar.date(from: comps) else { return 0 }
        comps.year = selectedYear + 1
        guard let end = calendar.date(from: comps) else { return 0 }
        let records = tapManager.records(from: start, to: end)
        return records.filter { $0.tapCount > 0 }.count
    }
}

struct DailyPoint {
    let day: Int
    let count: Int
}

struct MonthlyPoint {
    let month: Int
    let count: Int
}

#Preview {
    TrendChartView(tapManager: .preview, skin: .threeBody)
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
