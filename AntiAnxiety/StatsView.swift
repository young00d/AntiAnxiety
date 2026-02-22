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
                    Text(skin == .threeBody ? "发送信号统计" : "功德统计")
                        .font(skin == .threeBody
                              ? .system(size: 18, weight: .medium, design: .monospaced)
                              : .system(size: 18, weight: .medium, design: .serif))
                        .foregroundStyle(skin == .threeBody ? .cyan : .brown.opacity(0.8))
                        .padding(.top, 24)

                    TrendChartView(tapManager: tapManager, skin: skin)
                }
            }
        }
        .presentationDragIndicator(.visible)
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
        }
    }
}

#Preview {
    StatsView(tapManager: .preview, skin: .threeBody)
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
