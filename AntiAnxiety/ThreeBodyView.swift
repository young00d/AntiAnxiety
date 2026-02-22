import SwiftUI

struct ThreeBodyView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var showSignalEffect = false
    @State private var signalRings: [SignalRing] = []
    @State private var statusText = "RED COAST BASE · READY"

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
        VStack(spacing: 32) {
            // Status display
            VStack(spacing: 8) {
                Text("RED COAST BASE")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(.cyan.opacity(0.5))
                    .tracking(4)

                Text("今日发射")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.4))
            }

            // The button
            ZStack {
                // Signal rings
                ForEach(signalRings) { ring in
                    Circle()
                        .stroke(.cyan.opacity(ring.opacity), lineWidth: 1.5)
                        .frame(width: ring.size, height: ring.size)
                }

                // Outer glow
                Circle()
                    .fill(.cyan.opacity(0.05))
                    .frame(width: 200, height: 200)

                // Button ring
                Circle()
                    .stroke(.cyan.opacity(0.3), lineWidth: 2)
                    .frame(width: 160, height: 160)

                // Inner button
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.0, green: 0.6, blue: 0.8),
                                Color(red: 0.0, green: 0.3, blue: 0.5),
                                Color(red: 0.0, green: 0.15, blue: 0.3)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 70
                        )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: .cyan.opacity(isPressed ? 0.8 : 0.3), radius: isPressed ? 30 : 15)
                    .scaleEffect(isPressed ? 0.92 : 1.0)

                // Button label — today's count prominently
                VStack(spacing: 4) {
                    Text("\(tapManager.todayCount)")
                        .font(.system(size: 40, weight: .thin, design: .monospaced))
                        .contentTransition(.numericText())
                    Text("发 射")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                }
                .foregroundStyle(.white.opacity(0.9))
                .scaleEffect(isPressed ? 0.92 : 1.0)
            }
            .onTapGesture {
                performTap()
            }

            // Status message
            Text(statusText)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.cyan.opacity(0.5))
                .lineLimit(1)
                .animation(.easeInOut(duration: 0.3), value: statusText)
                .padding(.horizontal, 32)
        }
    }

    private func performTap() {
        // Haptic
        HapticManager.heavyTap()

        // Count — persistent
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        // Press animation
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

        // Random status message
        statusText = messages.randomElement() ?? statusText
    }
}

struct SignalRing: Identifiable {
    let id = UUID()
    var size: CGFloat = 140
    var opacity: Double = 0.6
}

#Preview {
    ZStack {
        Color(red: 0.02, green: 0.02, blue: 0.08)
            .ignoresSafeArea()
        ThreeBodyView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
