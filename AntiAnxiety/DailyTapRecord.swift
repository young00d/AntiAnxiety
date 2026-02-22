import Foundation
import SwiftData

@Model
final class DailyTapRecord {
    @Attribute(.unique) var dateString: String
    var tapCount: Int
    var date: Date

    init(date: Date, tapCount: Int = 0) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        self.date = Calendar.current.startOfDay(for: date)
        self.tapCount = tapCount
    }
}
