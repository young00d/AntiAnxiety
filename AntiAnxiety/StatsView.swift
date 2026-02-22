import SwiftUI

struct StatsView: View {
    var tapManager: TapManager
    @State private var selectedTab: StatsTab = .calendar

    enum StatsTab: String, CaseIterable {
        case calendar = "日历"
        case trends = "趋势"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    ForEach(StatsTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)
                .padding(.top, 8)

                ScrollView {
                    switch selectedTab {
                    case .calendar:
                        CalendarView(tapManager: tapManager)
                            .padding(.top, 16)
                    case .trends:
                        TrendChartView(tapManager: tapManager)
                            .padding(.top, 16)
                    }
                }
            }
            .navigationTitle("统计")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StatsView(tapManager: .preview)
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
