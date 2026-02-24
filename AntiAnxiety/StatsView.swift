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
        case .threeBody: return .cyan
        case .woodenFish: return .brown.opacity(0.8)
        case .cat: return Color(red: 0.80, green: 0.45, blue: 0.42)
        }
    }

    @ViewBuilder
    func backgroundForSkin(_ skin: SkinType) -> some View {
        switch skin {
        case .threeBody:
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.02, green: 0.02, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .woodenFish:
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    Color(red: 0.92, green: 0.88, blue: 0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .cat:
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.96, blue: 0.94),
                    Color(red: 0.98, green: 0.92, blue: 0.90)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    StatsView(tapManager: .preview, skin: .threeBody)
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
