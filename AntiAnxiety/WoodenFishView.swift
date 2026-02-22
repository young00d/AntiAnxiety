import SwiftUI

// MARK: - Wooden Fish Shape (Bezier)
struct WoodenFishShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        let topKnob = CGPoint(x: w * 0.5, y: h * 0.02)
        path.move(to: topKnob)

        path.addCurve(
            to: CGPoint(x: w * 0.85, y: h * 0.28),
            control1: CGPoint(x: w * 0.62, y: h * 0.02),
            control2: CGPoint(x: w * 0.82, y: h * 0.12)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.92, y: h * 0.55),
            control1: CGPoint(x: w * 0.92, y: h * 0.35),
            control2: CGPoint(x: w * 0.96, y: h * 0.45)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.95),
            control1: CGPoint(x: w * 0.90, y: h * 0.72),
            control2: CGPoint(x: w * 0.72, y: h * 0.92)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.08, y: h * 0.55),
            control1: CGPoint(x: w * 0.28, y: h * 0.92),
            control2: CGPoint(x: w * 0.10, y: h * 0.72)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.28),
            control1: CGPoint(x: w * 0.04, y: h * 0.45),
            control2: CGPoint(x: w * 0.08, y: h * 0.35)
        )

        path.addCurve(
            to: topKnob,
            control1: CGPoint(x: w * 0.18, y: h * 0.12),
            control2: CGPoint(x: w * 0.38, y: h * 0.02)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Fish Scale Pattern
struct FishScaleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        for i in 0..<5 {
            let y = h * (0.35 + CGFloat(i) * 0.09)
            let indent = CGFloat(i) * 6
            path.move(to: CGPoint(x: w * 0.25 + indent, y: y))
            path.addQuadCurve(
                to: CGPoint(x: w * 0.75 - indent, y: y),
                control: CGPoint(x: w * 0.5, y: y + 8)
            )
        }
        return path
    }
}

// MARK: - Shrine Roof Shape (佛龛屋檐)
struct ShrineRoofShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Traditional curved eave — upturned at tips
        path.move(to: CGPoint(x: 0, y: h * 0.85))

        // Left upturned tip
        path.addCurve(
            to: CGPoint(x: w * 0.08, y: h * 0.55),
            control1: CGPoint(x: w * 0.01, y: h * 0.72),
            control2: CGPoint(x: w * 0.03, y: h * 0.55)
        )

        // Left side of roof curving up to peak
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.0),
            control1: CGPoint(x: w * 0.15, y: h * 0.55),
            control2: CGPoint(x: w * 0.32, y: h * 0.08)
        )

        // Peak to right side
        path.addCurve(
            to: CGPoint(x: w * 0.92, y: h * 0.55),
            control1: CGPoint(x: w * 0.68, y: h * 0.08),
            control2: CGPoint(x: w * 0.85, y: h * 0.55)
        )

        // Right upturned tip
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.85),
            control1: CGPoint(x: w * 0.97, y: h * 0.55),
            control2: CGPoint(x: w * 0.99, y: h * 0.72)
        )

        // Bottom beam
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()

        return path
    }
}

// MARK: - Shrine View (神龛 — upper half)
struct ShrineView: View {
    var todayCount: Int
    @State private var incenseGlow = false

    var body: some View {
        VStack(spacing: 0) {
            // Roof
            shrineRoof

            // Shrine body
            shrineBody
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                incenseGlow = true
            }
        }
    }

    private var shrineRoof: some View {
        ShrineRoofShape()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.45, green: 0.28, blue: 0.15),
                        Color(red: 0.38, green: 0.22, blue: 0.10),
                        Color(red: 0.30, green: 0.18, blue: 0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 50)
            .overlay(
                ShrineRoofShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .brown.opacity(0.3), radius: 6, y: 3)
            .padding(.horizontal, 32)
    }

    private var shrineBody: some View {
        ZStack {
            // Wooden background panel
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.52, green: 0.35, blue: 0.20),
                            Color(red: 0.45, green: 0.28, blue: 0.14),
                            Color(red: 0.40, green: 0.24, blue: 0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .brown.opacity(0.2), radius: 4, y: 2)

            // Inner shadow frame
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.black.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )

            // Content
            VStack(spacing: 12) {
                // Incense smoke effect (subtle glow dots)
                HStack(spacing: 24) {
                    incenseDot
                    incenseDot
                    incenseDot
                }

                // Plaque / 牌匾
                plaqueView

                // Subtitle
                Text("今 日 修 行")
                    .font(.system(size: 11, design: .serif))
                    .foregroundStyle(.white.opacity(0.4))
                    .tracking(3)
            }
            .padding(.vertical, 16)
        }
        .frame(height: 160)
        .padding(.horizontal, 44)
    }

    private var incenseDot: some View {
        Circle()
            .fill(.orange.opacity(incenseGlow ? 0.5 : 0.2))
            .frame(width: 4, height: 4)
            .blur(radius: incenseGlow ? 3 : 1)
    }

    private var plaqueView: some View {
        ZStack {
            // Plaque background
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.60, green: 0.40, blue: 0.22),
                            Color(red: 0.50, green: 0.32, blue: 0.16)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 160, height: 72)
                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

            // Gold border
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.70, blue: 0.35),
                            Color(red: 0.70, green: 0.55, blue: 0.25),
                            Color(red: 0.85, green: 0.70, blue: 0.35)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 160, height: 72)

            // Merit count
            VStack(spacing: 2) {
                Text("功德")
                    .font(.system(size: 11, design: .serif))
                    .foregroundStyle(Color(red: 0.85, green: 0.70, blue: 0.35).opacity(0.7))

                Text("\(todayCount)")
                    .font(.system(size: 36, weight: .light, design: .serif))
                    .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.40))
                    .contentTransition(.numericText())
            }
        }
    }
}

// MARK: - Wooden Fish View (Main)
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
        VStack(spacing: 0) {
            // ===== Upper half: Shrine =====
            ShrineView(todayCount: tapManager.todayCount)
                .padding(.bottom, 24)

            Spacer()

            // ===== Lower half: Wooden Fish Button =====
            woodenFishButton
                .padding(.bottom, 16)

            // Wisdom text
            Text(floatingTexts.last?.text ?? "心静自然凉")
                .font(.system(size: 13, design: .serif))
                .foregroundStyle(.brown.opacity(0.4))
                .animation(.easeInOut(duration: 0.3), value: floatingTexts.count)
                .padding(.bottom, 8)
        }
    }

    private var woodenFishButton: some View {
        ZStack {
            // Floating merit texts
            ForEach(floatingTexts) { ft in
                Text(ft.text)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundStyle(.brown.opacity(ft.opacity))
                    .offset(y: ft.offsetY)
            }

            // Shadow on the ground
            Ellipse()
                .fill(.brown.opacity(isPressed ? 0.06 : 0.12))
                .frame(width: isPressed ? 130 : 150, height: isPressed ? 16 : 22)
                .offset(y: 88)
                .animation(.easeInOut(duration: 0.1), value: isPressed)

            // Wooden fish body
            ZStack {
                WoodenFishShape()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.58, green: 0.38, blue: 0.20),
                                Color(red: 0.48, green: 0.30, blue: 0.14),
                                Color(red: 0.35, green: 0.20, blue: 0.08)
                            ],
                            center: .init(x: 0.4, y: 0.35),
                            startRadius: 0,
                            endRadius: 90
                        )
                    )
                    .frame(width: 155, height: 155)
                    .shadow(color: .brown.opacity(0.4), radius: 10, y: 5)

                WoodenFishShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.clear,
                                Color.black.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 155, height: 155)

                FishScaleShape()
                    .stroke(.white.opacity(0.06), lineWidth: 1.2)
                    .frame(width: 155, height: 155)

                // Center striking point
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.50, green: 0.32, blue: 0.16),
                                Color(red: 0.40, green: 0.24, blue: 0.10)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 22
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .offset(y: 8)
            }
            .scaleEffect(isPressed ? 0.93 : 1.0)
        }
        .frame(height: 210)
        .onTapGesture {
            performTap()
        }
    }

    private func performTap() {
        HapticManager.woodenFishTap()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        withAnimation(.easeInOut(duration: 0.06)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = false
            }
        }

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
