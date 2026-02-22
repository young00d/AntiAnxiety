import SwiftUI

// MARK: - Mechanical Flip Digit (单个翻页数字)
struct FlipDigitView: View {
    var digit: Int
    var color: Color = .cyan

    var body: some View {
        ZStack {
            // Digit card background
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.18),
                            Color(red: 0.08, green: 0.08, blue: 0.14)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Subtle inner border
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)

            // Middle split line (mechanical counter divider)
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .frame(height: 1)

            // The digit
            Text("\(digit)")
                .font(.system(size: 32, weight: .medium, design: .monospaced))
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
        .frame(width: 34, height: 50)
    }
}

// MARK: - Mechanical Counter Display (机械翻页计数器)
struct MechanicalCounterView: View {
    var count: Int
    @State private var scanLineOffset: CGFloat = -1

    private var digits: [Int] {
        let str = String(format: "%06d", count)
        return str.compactMap { $0.wholeNumberValue }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header label
            headerLabel

            // Counter housing
            counterHousing

            // Status bar
            statusBar
        }
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                scanLineOffset = 1
            }
        }
    }

    private var headerLabel: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(.cyan.opacity(0.6))
                .frame(width: 5, height: 5)
            Text("RED COAST BASE")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(.cyan.opacity(0.4))
                .tracking(3)
            Circle()
                .fill(.cyan.opacity(0.6))
                .frame(width: 5, height: 5)
        }
    }

    private var counterHousing: some View {
        ZStack {
            // Outer housing frame
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.10, green: 0.10, blue: 0.16),
                            Color(red: 0.06, green: 0.06, blue: 0.10)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .cyan.opacity(0.1), radius: 12)

            // Metallic border
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.04),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )

            VStack(spacing: 12) {
                // Label row
                Text("SIGNAL TRANSMISSION COUNT")
                    .font(.system(size: 8, weight: .regular, design: .monospaced))
                    .foregroundStyle(.cyan.opacity(0.3))
                    .tracking(2)

                // Digit row
                HStack(spacing: 3) {
                    ForEach(0..<6, id: \.self) { index in
                        FlipDigitView(digit: digits[index])
                    }
                }

                // Unit label
                Text("今 日 发 射")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.cyan.opacity(0.35))
                    .tracking(4)
            }
            .padding(.vertical, 16)

            // CRT scan line effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            .cyan.opacity(0.03),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 30)
                .offset(y: scanLineOffset * 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(height: 150)
        .padding(.horizontal, 48)
    }

    private var statusBar: some View {
        HStack(spacing: 16) {
            statusIndicator(label: "PWR", active: true)
            statusIndicator(label: "SIG", active: true)
            statusIndicator(label: "LNK", active: false)
        }
    }

    private func statusIndicator(label: String, active: Bool) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(active ? Color.green.opacity(0.7) : Color.red.opacity(0.3))
                .frame(width: 4, height: 4)
            Text(label)
                .font(.system(size: 8, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.3))
        }
    }
}

// MARK: - Three Body View (Main)
struct ThreeBodyView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var showSignalEffect = false
    @State private var signalRings: [SignalRing] = []
    @State private var statusText = "RED COAST BASE · READY"
    @State private var buttonGlow = false

    private let messages = [
        "信号已发送至宇宙深处...",
        "坐标已锁定：银河系猎户臂",
        "发射功率：25MW 全向广播",
        "正在穿越太阳信号放大层...",
        "信号强度正常，持续发射中...",
        "宇宙背景辐射干扰已过滤",
        "红岸基地系统运行正常",
        "太阳信号反射层稳定",
        "深空监听阵列已就绪",
        "引力波通信通道已建立",
    ]

    var body: some View {
        VStack(spacing: 0) {
            // ===== Upper half: Mechanical Counter Display =====
            MechanicalCounterView(count: tapManager.todayCount)
                .padding(.bottom, 24)

            Spacer()

            // ===== Lower half: Transmission Button =====
            transmissionButton
                .padding(.bottom, 12)

            // Status message
            Text(statusText)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.cyan.opacity(0.4))
                .lineLimit(1)
                .animation(.easeInOut(duration: 0.3), value: statusText)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                buttonGlow = true
            }
        }
    }

    private var transmissionButton: some View {
        ZStack {
            // Signal rings
            ForEach(signalRings) { ring in
                Circle()
                    .stroke(.cyan.opacity(ring.opacity), lineWidth: 1.5)
                    .frame(width: ring.size, height: ring.size)
            }

            // Outer pulsing ring
            Circle()
                .stroke(.cyan.opacity(buttonGlow ? 0.15 : 0.05), lineWidth: 1)
                .frame(width: 190, height: 190)

            // Middle ring
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            .cyan.opacity(0.3),
                            .cyan.opacity(0.05),
                            .cyan.opacity(0.3),
                            .cyan.opacity(0.05),
                            .cyan.opacity(0.3)
                        ],
                        center: .center
                    ),
                    lineWidth: 2
                )
                .frame(width: 165, height: 165)

            // Outer glow disc
            Circle()
                .fill(.cyan.opacity(buttonGlow ? 0.06 : 0.02))
                .frame(width: 160, height: 160)

            // Main button
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.0, green: 0.55, blue: 0.75),
                            Color(red: 0.0, green: 0.30, blue: 0.50),
                            Color(red: 0.0, green: 0.12, blue: 0.25)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 65
                    )
                )
                .frame(width: 130, height: 130)
                .shadow(color: .cyan.opacity(isPressed ? 0.8 : 0.3), radius: isPressed ? 30 : 15)

            // Button inner ring
            Circle()
                .strokeBorder(.cyan.opacity(0.2), lineWidth: 1)
                .frame(width: 130, height: 130)

            // Button label
            VStack(spacing: 6) {
                Text("发 射")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .tracking(6)

                // Small triangle indicator
                Image(systemName: "arrowtriangle.up.fill")
                    .font(.system(size: 8))
                    .opacity(0.6)
            }
            .foregroundStyle(.white.opacity(0.85))
        }
        .scaleEffect(isPressed ? 0.94 : 1.0)
        .frame(height: 230)
        .onTapGesture {
            performTap()
        }
    }

    private func performTap() {
        HapticManager.heavyTap()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = false
            }
        }

        // Signal ring effect
        let ring = SignalRing()
        signalRings.append(ring)
        withAnimation(.easeOut(duration: 1.5)) {
            if let index = signalRings.firstIndex(where: { $0.id == ring.id }) {
                signalRings[index].size = 300
                signalRings[index].opacity = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            signalRings.removeAll { $0.id == ring.id }
        }

        statusText = messages.randomElement() ?? statusText
    }
}

struct SignalRing: Identifiable {
    let id = UUID()
    var size: CGFloat = 130
    var opacity: Double = 0.6
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.02, blue: 0.08),
                Color(red: 0.05, green: 0.05, blue: 0.15),
                Color(red: 0.02, green: 0.02, blue: 0.08)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        ThreeBodyView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
