import Foundation
import SwiftData

@Observable
final class TapManager {
    var todayCount: Int = 0

    private var modelContext: ModelContext
    private var todayRecord: DailyTapRecord?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadTodayRecord()
    }

    func increment() {
        // Handle day boundary: if midnight passed, reload
        if let record = todayRecord {
            let todayStart = Calendar.current.startOfDay(for: .now)
            if record.date != todayStart {
                loadTodayRecord()
            }
        }

        todayCount += 1

        if let record = todayRecord {
            record.tapCount = todayCount
        } else {
            let record = DailyTapRecord(date: .now, tapCount: todayCount)
            modelContext.insert(record)
            todayRecord = record
        }
        try? modelContext.save()
    }

    private func loadTodayRecord() {
        let today = Calendar.current.startOfDay(for: .now)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let predicate = #Predicate<DailyTapRecord> {
            $0.date >= today && $0.date < tomorrow
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        if let existing = try? modelContext.fetch(descriptor).first {
            todayRecord = existing
            todayCount = existing.tapCount
        } else {
            todayCount = 0
            todayRecord = nil
        }
    }

    // Fetch records for a given month
    func records(for month: Date) -> [DailyTapRecord] {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: month)
        guard let startOfMonth = calendar.date(from: comps),
              let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            return []
        }
        let predicate = #Predicate<DailyTapRecord> {
            $0.date >= startOfMonth && $0.date < endOfMonth
        }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.date)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    // Fetch records for a date range
    func records(from startDate: Date, to endDate: Date) -> [DailyTapRecord] {
        let predicate = #Predicate<DailyTapRecord> {
            $0.date >= startDate && $0.date < endDate
        }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.date)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    // Preview helper
    @MainActor
    static var preview: TapManager {
        let container = try! ModelContainer(for: DailyTapRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return TapManager(modelContext: container.mainContext)
    }
}
