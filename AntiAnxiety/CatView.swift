import SwiftUI

// MARK: - Cat Head Shape (Bezier)
struct CatHeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Start from left ear base
        path.move(to: CGPoint(x: w * 0.18, y: h * 0.32))

        // Left ear — pointed triangle with slight curve
        path.addCurve(
            to: CGPoint(x: w * 0.12, y: h * 0.0),
            control1: CGPoint(x: w * 0.12, y: h * 0.20),
            control2: CGPoint(x: w * 0.08, y: h * 0.05)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.35, y: h * 0.18),
            control1: CGPoint(x: w * 0.18, y: h * 0.0),
            control2: CGPoint(x: w * 0.28, y: h * 0.10)
        )

        // Top of head
        path.addCurve(
            to: CGPoint(x: w * 0.65, y: h * 0.18),
            control1: CGPoint(x: w * 0.42, y: h * 0.12),
            control2: CGPoint(x: w * 0.58, y: h * 0.12)
        )

        // Right ear
        path.addCurve(
            to: CGPoint(x: w * 0.88, y: h * 0.0),
            control1: CGPoint(x: w * 0.72, y: h * 0.10),
            control2: CGPoint(x: w * 0.82, y: h * 0.0)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.82, y: h * 0.32),
            control1: CGPoint(x: w * 0.92, y: h * 0.05),
            control2: CGPoint(x: w * 0.88, y: h * 0.20)
        )

        // Right cheek — plump
        path.addCurve(
            to: CGPoint(x: w * 0.88, y: h * 0.60),
            control1: CGPoint(x: w * 0.96, y: h * 0.40),
            control2: CGPoint(x: w * 0.98, y: h * 0.52)
        )

        // Right lower cheek to chin
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.92),
            control1: CGPoint(x: w * 0.85, y: h * 0.78),
            control2: CGPoint(x: w * 0.68, y: h * 0.90)
        )

        // Chin to left lower cheek
        path.addCurve(
            to: CGPoint(x: w * 0.12, y: h * 0.60),
            control1: CGPoint(x: w * 0.32, y: h * 0.90),
            control2: CGPoint(x: w * 0.15, y: h * 0.78)
        )

        // Left cheek back up to start
        path.addCurve(
            to: CGPoint(x: w * 0.18, y: h * 0.32),
            control1: CGPoint(x: w * 0.02, y: h * 0.52),
            control2: CGPoint(x: w * 0.04, y: h * 0.40)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Cat Face Details
struct CatFaceView: View {
    var body: some View {
        ZStack {
            // Eyes
            HStack(spacing: 32) {
                catEye
                catEye
            }
            .offset(y: -8)

            // Nose — small inverted triangle
            Triangle()
                .fill(Color(red: 0.90, green: 0.65, blue: 0.62))
                .frame(width: 10, height: 7)
                .rotationEffect(.degrees(180))
                .offset(y: 8)

            // Mouth — simple W shape
            CatMouthShape()
                .stroke(Color(red: 0.75, green: 0.50, blue: 0.48).opacity(0.4), lineWidth: 1.2)
                .frame(width: 20, height: 8)
                .offset(y: 16)

            // Whiskers
            HStack(spacing: 50) {
                whiskers(flipped: false)
                whiskers(flipped: true)
            }
            .offset(y: 10)
        }
    }

    private var catEye: some View {
        ZStack {
            // Outer eye
            Ellipse()
                .fill(Color(red: 0.35, green: 0.30, blue: 0.25))
                .frame(width: 16, height: 18)

            // Pupil
            Ellipse()
                .fill(Color.black)
                .frame(width: 8, height: 14)

            // Highlight
            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: 5, height: 5)
                .offset(x: 2, y: -3)
        }
    }

    private func whiskers(flipped: Bool) -> some View {
        VStack(spacing: 5) {
            whiskerLine(angle: -8)
            whiskerLine(angle: 0)
            whiskerLine(angle: 8)
        }
        .scaleEffect(x: flipped ? -1 : 1)
    }

    private func whiskerLine(angle: Double) -> some View {
        Rectangle()
            .fill(Color(red: 0.60, green: 0.45, blue: 0.35).opacity(0.3))
            .frame(width: 22, height: 1)
            .rotationEffect(.degrees(angle))
    }
}

// MARK: - Helper Shapes
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CatMouthShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // W shape mouth
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control: CGPoint(x: w * 0.25, y: h * 0.6)
        )
        path.addQuadCurve(
            to: CGPoint(x: w, y: 0),
            control: CGPoint(x: w * 0.75, y: h * 0.6)
        )
        return path
    }
}

// MARK: - Paw Print Shape
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

            // ===== Lower half: Cat button =====
            catButton
                .padding(.bottom, 16)

            // Status text
            Text(floatingTexts.last?.text ?? "来撸猫吧~")
                .font(.system(size: 13, design: .rounded))
                .foregroundStyle(Color(red: 0.75, green: 0.50, blue: 0.48).opacity(0.4))
                .animation(.easeInOut(duration: 0.3), value: floatingTexts.count)
                .padding(.bottom, 8)
        }
    }

    private var catButton: some View {
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

            // Cat head body
            ZStack {
                // Main cat shape fill
                CatHeadShape()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.95, green: 0.82, blue: 0.58),
                                Color(red: 0.88, green: 0.72, blue: 0.48),
                                Color(red: 0.78, green: 0.60, blue: 0.35)
                            ],
                            center: .init(x: 0.45, y: 0.35),
                            startRadius: 0,
                            endRadius: 85
                        )
                    )
                    .frame(width: 155, height: 155)
                    .shadow(color: Color(red: 0.75, green: 0.55, blue: 0.35).opacity(0.35), radius: 10, y: 5)

                // Edge highlight
                CatHeadShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.clear,
                                Color(red: 0.65, green: 0.45, blue: 0.25).opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 155, height: 155)

                // Inner ear color (pink triangles)
                CatHeadShape()
                    .fill(Color(red: 0.95, green: 0.75, blue: 0.72).opacity(0.3))
                    .frame(width: 155, height: 155)
                    .mask(
                        VStack {
                            HStack(spacing: 60) {
                                Ellipse()
                                    .frame(width: 20, height: 28)
                                    .rotationEffect(.degrees(-10))
                                Ellipse()
                                    .frame(width: 20, height: 28)
                                    .rotationEffect(.degrees(10))
                            }
                            .offset(y: 8)
                            Spacer()
                        }
                        .frame(width: 155, height: 155)
                    )

                // Face details
                CatFaceView()
                    .frame(width: 80, height: 60)
                    .offset(y: 12)
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
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
