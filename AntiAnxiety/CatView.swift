import SwiftUI

// MARK: - Cat Paw Pad Shape (贝塞尔曲线猫爪掌心)
struct CatPawPadShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Main palm pad — a wide heart-like / rounded trapezoid shape
        // Start from bottom center
        path.move(to: CGPoint(x: w * 0.50, y: h * 0.98))

        // Bottom center to lower-left
        path.addCurve(
            to: CGPoint(x: w * 0.08, y: h * 0.62),
            control1: CGPoint(x: w * 0.28, y: h * 0.98),
            control2: CGPoint(x: w * 0.06, y: h * 0.82)
        )

        // Left side up to top-left
        path.addCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.35),
            control1: CGPoint(x: w * 0.08, y: h * 0.48),
            control2: CGPoint(x: w * 0.14, y: h * 0.38)
        )

        // Top-left dip (between left beans and palm)
        path.addCurve(
            to: CGPoint(x: w * 0.50, y: h * 0.32),
            control1: CGPoint(x: w * 0.32, y: h * 0.30),
            control2: CGPoint(x: w * 0.40, y: h * 0.30)
        )

        // Top-right dip
        path.addCurve(
            to: CGPoint(x: w * 0.78, y: h * 0.35),
            control1: CGPoint(x: w * 0.60, y: h * 0.30),
            control2: CGPoint(x: w * 0.68, y: h * 0.30)
        )

        // Right side down
        path.addCurve(
            to: CGPoint(x: w * 0.92, y: h * 0.62),
            control1: CGPoint(x: w * 0.86, y: h * 0.38),
            control2: CGPoint(x: w * 0.92, y: h * 0.48)
        )

        // Lower-right back to bottom center
        path.addCurve(
            to: CGPoint(x: w * 0.50, y: h * 0.98),
            control1: CGPoint(x: w * 0.94, y: h * 0.82),
            control2: CGPoint(x: w * 0.72, y: h * 0.98)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Toe Bean Shape (单个肉垫豆豆)
struct ToeBeanShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Slightly elongated oval, wider at bottom
        path.move(to: CGPoint(x: w * 0.50, y: 0))

        path.addCurve(
            to: CGPoint(x: w, y: h * 0.45),
            control1: CGPoint(x: w * 0.82, y: 0),
            control2: CGPoint(x: w, y: h * 0.18)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.50, y: h),
            control1: CGPoint(x: w, y: h * 0.75),
            control2: CGPoint(x: w * 0.80, y: h)
        )

        path.addCurve(
            to: CGPoint(x: 0, y: h * 0.45),
            control1: CGPoint(x: w * 0.20, y: h),
            control2: CGPoint(x: 0, y: h * 0.75)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.50, y: 0),
            control1: CGPoint(x: 0, y: h * 0.18),
            control2: CGPoint(x: w * 0.18, y: 0)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Full Cat Paw Button (大猫爪按钮)
struct CatPawButtonView: View {
    var isPressed: Bool

    private let padColor = Color(red: 0.92, green: 0.68, blue: 0.65)
    private let padDark = Color(red: 0.82, green: 0.55, blue: 0.52)
    private let beanColor = Color(red: 0.95, green: 0.72, blue: 0.70)
    private let beanDark = Color(red: 0.85, green: 0.58, blue: 0.55)
    private let furColor = Color(red: 0.95, green: 0.88, blue: 0.80)
    private let furDark = Color(red: 0.85, green: 0.75, blue: 0.65)

    var body: some View {
        ZStack {
            // Fur background circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [furColor, furDark],
                        center: .init(x: 0.45, y: 0.4),
                        startRadius: 0,
                        endRadius: 85
                    )
                )
                .frame(width: 165, height: 165)
                .shadow(color: furDark.opacity(0.4), radius: 12, y: 6)

            // Fur edge highlight
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.clear,
                            furDark.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 165, height: 165)

            // Main palm pad
            CatPawPadShape()
                .fill(
                    RadialGradient(
                        colors: [padColor, padDark],
                        center: .init(x: 0.5, y: 0.55),
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 80, height: 72)
                .offset(y: 16)

            // Palm pad inner highlight
            CatPawPadShape()
                .stroke(Color.white.opacity(0.15), lineWidth: 0.8)
                .frame(width: 80, height: 72)
                .offset(y: 16)

            // Four toe beans
            toeBeans
        }
        .scaleEffect(isPressed ? 0.90 : 1.0)
    }

    private var toeBeans: some View {
        ZStack {
            // Left outer bean
            singleBean
                .frame(width: 24, height: 28)
                .rotationEffect(.degrees(20))
                .offset(x: -38, y: -18)

            // Left inner bean
            singleBean
                .frame(width: 26, height: 30)
                .rotationEffect(.degrees(8))
                .offset(x: -14, y: -32)

            // Right inner bean
            singleBean
                .frame(width: 26, height: 30)
                .rotationEffect(.degrees(-8))
                .offset(x: 14, y: -32)

            // Right outer bean
            singleBean
                .frame(width: 24, height: 28)
                .rotationEffect(.degrees(-20))
                .offset(x: 38, y: -18)
        }
    }

    private var singleBean: some View {
        ZStack {
            ToeBeanShape()
                .fill(
                    RadialGradient(
                        colors: [beanColor, beanDark],
                        center: .init(x: 0.5, y: 0.45),
                        startRadius: 0,
                        endRadius: 15
                    )
                )

            ToeBeanShape()
                .stroke(Color.white.opacity(0.12), lineWidth: 0.6)
        }
    }
}

// MARK: - Paw Print View (小猫爪印装饰，用于上半部分和寄语页)
struct PawPrintView: View {
    var size: CGFloat = 16
    var color: Color = Color(red: 0.80, green: 0.60, blue: 0.55)

    var body: some View {
        ZStack {
            // Main pad
            Ellipse()
                .fill(color)
                .frame(width: size * 0.7, height: size * 0.55)
                .offset(y: size * 0.15)

            // Toe beans — 3 small circles
            HStack(spacing: size * 0.08) {
                Circle().fill(color).frame(width: size * 0.25, height: size * 0.25)
                Circle().fill(color).frame(width: size * 0.28, height: size * 0.28)
                    .offset(y: -size * 0.08)
                Circle().fill(color).frame(width: size * 0.25, height: size * 0.25)
            }
            .offset(y: -size * 0.18)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Cozy Cat Display (Upper Half)
struct CozyCatDisplayView: View {
    var todayCount: Int
    @State private var heartGlow = false

    private let accentPink = Color(red: 0.80, green: 0.45, blue: 0.42)
    private let softPink = Color(red: 0.75, green: 0.50, blue: 0.48)

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.95, blue: 0.93),
                            Color(red: 0.98, green: 0.91, blue: 0.89)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: softPink.opacity(0.15), radius: 8, y: 4)

            // Soft border
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(softPink.opacity(0.12), lineWidth: 1)

            VStack(spacing: 14) {
                // Paw prints decoration
                HStack(spacing: 20) {
                    PawPrintView(size: 14, color: softPink.opacity(heartGlow ? 0.5 : 0.25))
                    PawPrintView(size: 14, color: softPink.opacity(heartGlow ? 0.4 : 0.2))
                    PawPrintView(size: 14, color: softPink.opacity(heartGlow ? 0.5 : 0.25))
                }

                // Intimacy display
                VStack(spacing: 4) {
                    Text("亲密指数")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(softPink.opacity(0.6))

                    Text("\(todayCount)")
                        .font(.system(size: 40, weight: .light, design: .rounded))
                        .foregroundStyle(accentPink)
                        .contentTransition(.numericText())
                }

                // Subtitle with heart
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(accentPink.opacity(heartGlow ? 0.7 : 0.3))
                        .scaleEffect(heartGlow ? 1.15 : 1.0)
                    Text("今 日 撸 猫")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundStyle(softPink.opacity(0.4))
                        .tracking(3)
                    Image(systemName: "heart.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(accentPink.opacity(heartGlow ? 0.7 : 0.3))
                        .scaleEffect(heartGlow ? 1.15 : 1.0)
                }
            }
            .padding(.vertical, 20)
        }
        .frame(height: 180)
        .padding(.horizontal, 40)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                heartGlow = true
            }
        }
    }
}

// MARK: - Cat View (Main)
struct CatView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var floatingTexts: [FloatingText] = []

    private let catTexts = [
        "亲密 +1",
        "喵~",
        "咕噜咕噜",
        "蹭蹭~",
        "呼噜呼噜",
        "喵呜~",
        "好舒服喵",
        "再摸摸嘛",
        "眯起眼睛了",
        "尾巴翘起来了",
    ]

    var body: some View {
        VStack(spacing: 0) {
            // ===== Upper half: Cozy display =====
            CozyCatDisplayView(todayCount: tapManager.todayCount)
                .padding(.bottom, 20)

            Spacer()

            // ===== Lower half: Cat paw button =====
            catPawButton
                .padding(.bottom, 16)

            // Status text
            Text(floatingTexts.last?.text ?? "来撸猫吧~")
                .font(.system(size: 13, design: .rounded))
                .foregroundStyle(Color(red: 0.75, green: 0.50, blue: 0.48).opacity(0.4))
                .animation(.easeInOut(duration: 0.3), value: floatingTexts.count)
                .padding(.bottom, 8)
        }
    }

    private var catPawButton: some View {
        ZStack {
            // Floating texts
            ForEach(floatingTexts) { ft in
                Text(ft.text)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(red: 0.80, green: 0.45, blue: 0.42).opacity(ft.opacity))
                    .offset(y: ft.offsetY)
            }

            // Shadow
            Ellipse()
                .fill(Color(red: 0.75, green: 0.50, blue: 0.48).opacity(isPressed ? 0.05 : 0.10))
                .frame(width: isPressed ? 120 : 140, height: isPressed ? 14 : 20)
                .offset(y: 90)
                .animation(.easeInOut(duration: 0.1), value: isPressed)

            // Cat paw
            CatPawButtonView(isPressed: isPressed)
        }
        .frame(height: 210)
        .onTapGesture {
            performTap()
        }
    }

    private func performTap() {
        HapticManager.catTap()

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

        let text = catTexts.randomElement() ?? "亲密 +1"
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

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.96, blue: 0.94),
                Color(red: 0.98, green: 0.92, blue: 0.90)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        CatView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
