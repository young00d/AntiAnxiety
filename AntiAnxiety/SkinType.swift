import Foundation

enum SkinType: String, CaseIterable, Identifiable {
    case threeBody = "三体"
    case woodenFish = "木鱼"
    case cat = "猫猫"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .threeBody: return "三体·红岸"
        case .woodenFish: return "木鱼·功德"
        case .cat: return "猫猫·亲密"
        }
    }
}
