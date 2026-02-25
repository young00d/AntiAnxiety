import SwiftUI

// MARK: - Color Constants
private enum RedShoreColors {
    static let chassis = Color(red: 0.96, green: 0.93, blue: 0.90) // #F4EDE5
    static let engraved = Color(red: 0.41, green: 0.39, blue: 0.36) // #68635d
    static let counterBg = Color(red: 0.067, green: 0.067, blue: 0.067) // #111
    static let ledRed = Color(red: 0.87, green: 0.255, blue: 0.255) // #df4141
    static let monitorFrame = Color(red: 0.16, green: 0.16, blue: 0.16) // #292929
    static let monitorScreen = Color(red: 0.078, green: 0.102, blue: 0.078) // #141a14
    static let phosphor = Color(red: 0.69, green: 1.0, blue: 0.46) // #b1ff76
    static let coolantBg = Color(red: 0.133, green: 0.133, blue: 0.133) // #222
    static let coolantBorder = Color(red: 0.69, green: 0.67, blue: 0.63) // #b0aba0
    static let btnRed = Color(red: 0.80, green: 0.30, blue: 0.28)
    static let btnRedLight = Color(red: 0.92, green: 0.48, blue: 0.42)
    static let btnRedDark = Color(red: 0.60, green: 0.20, blue: 0.18)
    static let housingHighlight = Color(red: 0.95, green: 0.93, blue: 0.91)
    static let housingShadow = Color(red: 0.54, green: 0.52, blue: 0.48) // #8a857b
}

// MARK: - Signal Counter (顶部数字计数器)
struct SignalCounterView: View {
    var count: Int

    private var displayText: String {
        String(format: "%04d", min(count, 9999))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label
            Text("SIGNAL COUNT")
                .font(.custom("CourierPrime-Bold", size: 10))
                .foregroundStyle(RedShoreColors.engraved)
                .tracking(1)
                .shadow(color: .white.opacity(0.4), radius: 0, x: 1, y: 1)
                .shadow(color: .black.opacity(0.2), radius: 0, x: -1, y: -1)

            HStack(spacing: 0) {
                // Counter display
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(RedShoreColors.counterBg)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

                    // Scan line overlay
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: Array(repeating: [Color.black.opacity(0.3), Color.clear], count: 30).flatMap { $0 },
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .opacity(0.3)

                    // LED digits
                    Text(displayText)
                        .font(.custom("DigitalNumbers-Regular", size: 44))
                        .foregroundStyle(RedShoreColors.ledRed)
                        .shadow(color: RedShoreColors.ledRed.opacity(0.6), radius: 8)
                        .contentTransition(.numericText())
                }
                .frame(height: 72)

                Spacer().frame(width: 12)

                // Coolant tube
                CoolantTubeView()
                    .frame(width: 65, height: 72)
            }

            // Subtitle
            Text("RED SHORE BASE // TS-03")
                .font(.custom("CourierPrime-Bold", size: 10))
                .foregroundStyle(RedShoreColors.engraved)
                .tracking(1)
                .shadow(color: .white.opacity(0.4), radius: 0, x: 1, y: 1)
                .shadow(color: .black.opacity(0.2), radius: 0, x: -1, y: -1)
        }
        .padding(.horizontal, 32)
    }
}

// MARK: - Coolant Tube (冷却液管)
struct CoolantTubeView: View {
    @State private var bubbleOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Outer housing
            Capsule()
                .fill(Color(red: 0.12, green: 0.12, blue: 0.12))
                .overlay(
                    Capsule()
                        .strokeBorder(RedShoreColors.coolantBorder, lineWidth: 2)
                )

            // Glass tube
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.05),
                            .white.opacity(0.15),
                            .white.opacity(0.05)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(5)

            // Liquid
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                    Capsule()
                        .fill(RedShoreColors.phosphor.opacity(0.7))
                        .shadow(color: RedShoreColors.phosphor.opacity(0.5), radius: 8)
                        .frame(height: geo.size.height * 0.75)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                }

                // Bubbles
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(.white.opacity(0.4))
                        .frame(width: CGFloat(4 + i * 2), height: CGFloat(4 + i * 2))
                        .offset(
                            x: geo.size.width * CGFloat([0.3, 0.5, 0.6][i]),
                            y: geo.size.height * 0.7 - bubbleOffset * CGFloat(20 + i * 10)
                        )
                        .opacity(1.0 - Double(bubbleOffset) * 0.3)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                bubbleOffset = 1
            }
        }
    }
}

// MARK: - Signal Monitor (信号监视器)
struct SignalMonitorView: View {
    var isTransmitting: Bool
    @State private var scanLineY: CGFloat = 0

    var body: some View {
        ZStack {
            // Monitor frame
            RoundedRectangle(cornerRadius: 16)
                .fill(RedShoreColors.monitorFrame)
                .shadow(color: Color(red: 0.65, green: 0.59, blue: 0.51).opacity(0.6), radius: 8, x: 4, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.08), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )

            // Screen area
            ZStack {
                // Screen background
                RoundedRectangle(cornerRadius: 4)
                    .fill(RedShoreColors.monitorScreen)

                // Radar circles
                radarCircles

                // Cross hair
                crossHair

                // Sun bodies
                sunBodies

                // Waveform (Canvas)
                WaveformCanvasView(isTransmitting: isTransmitting)

                // CRT scan line effect
                crtOverlay

                // Floating scan line
                floatingScanLine

                // HUD text overlay
                hudOverlay

                // Vignette
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        RadialGradient(
                            colors: [.clear, .black.opacity(0.4)],
                            center: .center,
                            startRadius: 50,
                            endRadius: 180
                        )
                    )
            }
            .padding(12)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .padding(.horizontal, 32)
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                scanLineY = 1
            }
        }
    }

    private var radarCircles: some View {
        ZStack {
            ForEach([1.0, 0.84, 0.68], id: \.self) { scale in
                Circle()
                    .strokeBorder(RedShoreColors.phosphor.opacity(0.15), lineWidth: 0.5)
                    .scaleEffect(scale)
            }
        }
    }

    private var crossHair: some View {
        GeometryReader { geo in
            Path { path in
                // Vertical
                path.move(to: CGPoint(x: geo.size.width / 2, y: 0))
                path.addLine(to: CGPoint(x: geo.size.width / 2, y: geo.size.height))
                // Horizontal
                path.move(to: CGPoint(x: 0, y: geo.size.height / 2))
                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height / 2))
            }
            .stroke(RedShoreColors.phosphor.opacity(0.1), lineWidth: 0.5)
        }
    }

    private var sunBodies: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // Sun 1 - small
                sunBody(radius: 12)
                    .position(x: w * 0.42, y: h * 0.73)

                // Sun 2 - medium, with glow rings
                sunBody(radius: 20)
                    .position(x: w * 0.67, y: h * 0.35)

                // Sun 3 - medium
                sunBody(radius: 15)
                    .position(x: w * 0.35, y: h * 0.45)
            }
        }
    }

    private func sunBody(radius: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(RedShoreColors.phosphor.opacity(0.08))
                .frame(width: radius * 2, height: radius * 2)
            Circle()
                .strokeBorder(RedShoreColors.phosphor.opacity(0.25), lineWidth: 0.5)
                .frame(width: radius * 2, height: radius * 2)
            Circle()
                .fill(RedShoreColors.phosphor.opacity(0.15))
                .frame(width: radius, height: radius)
        }
    }

    private var crtOverlay: some View {
        Canvas { context, size in
            // Horizontal scan lines
            let lineSpacing: CGFloat = 2
            var y: CGFloat = 0
            while y < size.height {
                let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                context.fill(Path(rect), with: .color(.black.opacity(0.15)))
                y += lineSpacing
            }
        }
        .allowsHitTesting(false)
    }

    private var floatingScanLine: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, RedShoreColors.phosphor.opacity(0.06), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 40)
                .offset(y: scanLineY * geo.size.height - 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var hudOverlay: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("SYSTEM IDLE")
                .opacity(0.8)
            Text("FREQ: 34.02 GHZ")
            Text("AZIMUTH: 120.5")
            Text("SOLAR AMP: ACTIVE")
                .opacity(0.5)
            Spacer()
        }
        .font(.custom("CourierPrime-Regular", size: 10))
        .foregroundStyle(RedShoreColors.phosphor.opacity(0.5))
        .shadow(color: RedShoreColors.phosphor.opacity(0.4), radius: 4)
        .tracking(1)
        .textCase(.uppercase)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .allowsHitTesting(false)
    }
}

// MARK: - Waveform Canvas (信号波形动画)
struct WaveformCanvasView: View {
    var isTransmitting: Bool
    @State private var phase: Double = 0
    @State private var amplitude: Double = 10

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { context, size in
                let midY = size.height / 2
                let width = size.width

                // Trail effect: semi-transparent background
                var bgRect = Path()
                bgRect.addRect(CGRect(origin: .zero, size: size))
                context.fill(bgRect, with: .color(RedShoreColors.monitorScreen.opacity(0.3)))

                // Draw waveform
                var path = Path()
                path.move(to: CGPoint(x: 0, y: midY))

                for x in stride(from: 0, through: width, by: 1) {
                    let normalizedX = x / width
                    let y = midY +
                        sin(normalizedX * 10 + phase) * amplitude +
                        sin(normalizedX * 20 - phase * 2) * (amplitude * 0.5)
                    path.addLine(to: CGPoint(x: x, y: y))
                }

                // Glow layer
                context.stroke(path, with: .color(RedShoreColors.phosphor.opacity(0.3)), lineWidth: 6)
                // Main line
                context.stroke(path, with: .color(RedShoreColors.phosphor.opacity(0.9)), lineWidth: 2)
            }
            .onChange(of: timeline.date) {
                phase += 0.15
                let target: Double = isTransmitting ? 60 : 10
                amplitude += (target - amplitude) * 0.1
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Neumorphic Transmit Button (拟态发射按钮)
struct NeumorphicTransmitButton: View {
    var isPressed: Bool
    var action: () -> Void

    var body: some View {
        ZStack {
            // Outer housing (neumorphic base)
            Circle()
                .fill(RedShoreColors.chassis)
                .frame(width: 218, height: 218)
                .shadow(color: RedShoreColors.housingHighlight, radius: 10, x: -6, y: -6)
                .shadow(color: RedShoreColors.housingShadow.opacity(0.5), radius: 10, x: 6, y: 6)

            // Inner ring decoration
            Circle()
                .strokeBorder(
                    Color.gray.opacity(0.15),
                    style: StrokeStyle(lineWidth: 1, dash: [3, 3])
                )
                .frame(width: 200, height: 200)

            // The red button
            Circle()
                .fill(
                    RadialGradient(
                        colors: isPressed
                            ? [RedShoreColors.btnRedDark, RedShoreColors.btnRed.opacity(0.8)]
                            : [RedShoreColors.btnRedLight, RedShoreColors.btnRed, RedShoreColors.btnRedDark],
                        center: isPressed ? .center : UnitPoint(x: 0.35, y: 0.35),
                        startRadius: isPressed ? 10 : 0,
                        endRadius: 90
                    )
                )
                .frame(width: 180, height: 180)
                .shadow(
                    color: isPressed ? .clear : .black.opacity(0.25),
                    radius: isPressed ? 2 : 12,
                    x: 0,
                    y: isPressed ? 2 : 8
                )
                .overlay(
                    // Inner highlight (top-left shine)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(isPressed ? 0.05 : 0.25),
                                    .clear
                                ],
                                center: UnitPoint(x: 0.3, y: 0.25),
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 180, height: 180)
                )
                .overlay(
                    // Inner shadow for pressed state
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: isPressed
                                    ? [.black.opacity(0.2), .clear]
                                    : [.clear, .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 90
                            )
                        )
                        .frame(width: 180, height: 180)
                )

            // TRANSMIT text
            Text("TRANSMIT")
                .font(.custom("CourierPrime-Bold", size: 20))
                .foregroundStyle(Color(red: 1.0, green: 0.97, blue: 0.94))
                .tracking(1)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            action()
        }
    }
}

// MARK: - Three Body View (Main)
struct ThreeBodyView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var isTransmitting = false
    @State private var statusText = "RED SHORE BASE · STANDBY"

    private let messages = [
        "SIGNAL TRANSMITTED TO DEEP SPACE...",
        "COORDINATES LOCKED: ORION ARM",
        "POWER OUTPUT: 25MW OMNIDIRECTIONAL",
        "PENETRATING SOLAR AMPLIFICATION LAYER...",
        "SIGNAL STRENGTH NOMINAL",
        "COSMIC BACKGROUND FILTERED",
        "RED SHORE BASE: SYSTEMS NOMINAL",
        "SOLAR REFLECTION LAYER STABLE",
        "DEEP SPACE ARRAY READY",
        "GRAVITATIONAL WAVE CHANNEL ESTABLISHED",
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top: Signal counter
            SignalCounterView(count: tapManager.todayCount)
                .padding(.top, 8)

            Spacer().frame(height: 16)

            // Middle: Signal monitor
            SignalMonitorView(isTransmitting: isTransmitting)

            Spacer().frame(height: 20)

            // Bottom: Transmit button
            NeumorphicTransmitButton(isPressed: isPressed) {
                performTap()
            }

            Spacer().frame(height: 12)

            // Status text
            Text(statusText)
                .font(.custom("CourierPrime-Regular", size: 11))
                .foregroundStyle(RedShoreColors.engraved.opacity(0.6))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 32)
                .animation(.easeInOut(duration: 0.3), value: statusText)

            Spacer().frame(height: 8)
        }
    }

    private func performTap() {
        HapticManager.heavyTap()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        // Press animation
        withAnimation(.easeInOut(duration: 0.08)) {
            isPressed = true
            isTransmitting = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isTransmitting = false
        }

        statusText = messages.randomElement() ?? statusText
    }
}

#Preview {
    ZStack {
        Color(red: 0.96, green: 0.93, blue: 0.90)
            .ignoresSafeArea()
        ThreeBodyView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
