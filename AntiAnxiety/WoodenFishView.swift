import SwiftUI

struct WoodenFishView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var floatingTexts: [FloatingText] = []

    private let wisdomTexts = [
        "功德 +1",
        "善哉善哉",
        "阿弥陀佛",
        "心无挂碍",
        "一念清净",
        "放下执着",
        "心如止水",
        "万法皆空",
        "随缘自在",
        "静心安神",
    ]

    var body: some View {
        VStack(spacing: 32) {
            // Merit counter
            VStack(spacing: 8) {
                Text("功德")
                    .font(.system(size: 14))
                    .foregroundStyle(.brown.opacity(0.5))

                Text("今日修行")
                    .font(.system(size: 13))
                    .foregroundStyle(.brown.opacity(0.4))
            }

            // Wooden fish button
            ZStack {
                // Floating merit texts
                ForEach(floatingTexts) { ft in
                    Text(ft.text)
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundStyle(.brown.opacity(ft.opacity))
                        .offset(y: ft.offsetY)
                }

                // Wooden fish body
                ZStack {
                    // Shadow
                    Ellipse()
                        .fill(.brown.opacity(0.1))
                        .frame(width: 160, height: 30)
                        .offset(y: 80)

                    // Main body
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.35, blue: 0.18),
                                    Color(red: 0.45, green: 0.28, blue: 0.12),
                                    Color(red: 0.35, green: 0.20, blue: 0.08)
                                ],
                                center: .init(x: 0.4, y: 0.35),
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 150, height: 150)
                        .shadow(color: .brown.opacity(0.3), radius: 10, y: 5)
                        .scaleEffect(isPressed ? 0.93 : 1.0)

                    // Wood grain lines
                    VStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(.white.opacity(0.08))
                                .frame(width: CGFloat(80 - i * 15), height: 1.5)
                        }
                    }
                    .scaleEffect(isPressed ? 0.93 : 1.0)

                    // Center — today's count prominently
                    VStack(spacing: 2) {
                        Text("\(tapManager.todayCount)")
                            .font(.system(size: 36, weight: .light, design: .serif))
                            .foregroundStyle(.white.opacity(0.7))
                            .contentTransition(.numericText())
                        Text("功德")
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.35))
                    }
                    .scaleEffect(isPressed ? 0.93 : 1.0)
                }
            }
            .frame(height: 220)
            .onTapGesture {
                performTap()
            }

            // Wisdom text
            Text("心静自然凉")
                .font(.system(size: 13, design: .serif))
                .foregroundStyle(.brown.opacity(0.4))
        }
    }

    private func performTap() {
        // Haptic - wooden knock feel
        HapticManager.woodenFishTap()

        // Increment — persistent
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        // Press animation
        withAnimation(.easeInOut(duration: 0.08)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = false
            }
        }

        // Floating text
        let text = wisdomTexts.randomElement() ?? "功德 +1"
        let ft = FloatingText(text: text)
        floatingTexts.append(ft)

        withAnimation(.easeOut(duration: 1.8)) {
            if let index = floatingTexts.firstIndex(where: { $0.id == ft.id }) {
                floatingTexts[index].offsetY = -120
                floatingTexts[index].opacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            floatingTexts.removeAll { $0.id == ft.id }
        }
    }
}

struct FloatingText: Identifiable {
    let id = UUID()
    let text: String
    var offsetY: CGFloat = -20
    var opacity: Double = 1.0
}

#Preview {
    ZStack {
        Color(red: 0.96, green: 0.93, blue: 0.88)
            .ignoresSafeArea()
        WoodenFishView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
