import SwiftUI

struct StatsView: View {
    var tapManager: TapManager
    var skin: SkinType

    var body: some View {
        ZStack {
            // Match the skin background
            backgroundForSkin(skin)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text(statsTitle)
                        .font(.system(size: 18, weight: .medium, design: statsFontDesign))
                        .foregroundStyle(statsColor)
                        .padding(.top, 24)

                    TrendChartView(tapManager: tapManager, skin: skin)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    private var statsTitle: String {
        switch skin {
        case .threeBody: return "发送信号统计"
        case .woodenFish: return "功德统计"
        case .cat: return "撸猫统计"
        }
    }

    private var statsFontDesign: Font.Design {
        switch skin {
        case .threeBody: return .monospaced
        case .woodenFish: return .serif
        case .cat: return .rounded
        }
    }

    private var statsColor: Color {
        switch skin {
        case .threeBody: return Color(red: 0.41, green: 0.39, blue: 0.36)
        case .woodenFish: return .brown.opacity(0.8)
        case .cat: return Color(red: 0.80, green: 0.45, blue: 0.42)
        }
    }

    @ViewBuilder
    func backgroundForSkin(_ skin: SkinType) -> some View {
        switch skin {
        case .threeBody:
            Color(red: 0.96, green: 0.93, blue: 0.90) // #f4ede5
        case .woodenFish:
            Color(red: 0.749, green: 0.690, blue: 0.612) // #bfb09c
        case .cat:
            Color(red: 0.843, green: 0.737, blue: 0.639) // #d7bca3
        }
    }
}

#Preview {
    StatsView(tapManager: .preview, skin: .threeBody)
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
