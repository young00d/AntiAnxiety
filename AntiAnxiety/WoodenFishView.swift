import SwiftUI

// MARK: - Monospace Counter (等宽数字显示，每位数字固定宽度)
struct MonospaceCounter: View {
    let count: Int
    let font: Font
    let color: Color

    /// Digits indexed by place value (0=ones, 1=tens…), displayed left-to-right
    private var indexedDigits: [(placeValue: Int, char: String)] {
        let str = String(count)
        return Array(str.reversed().enumerated())
            .reversed()
            .map { (placeValue: $0.offset, char: String($0.element)) }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(indexedDigits, id: \.placeValue) { item in
                // Hidden "8" defines the fixed width for each digit slot
                Text("8")
                    .font(font)
                    .foregroundStyle(.clear)
                    .overlay {
                        Text(item.char)
                            .font(font)
                            .foregroundStyle(color)
                            .contentTransition(.numericText())
                    }
            }
        }
    }
}

// MARK: - Styled Floating Text View
struct StyledFloatingTextView: View {
    let word: String
    let opacity: Double
    let offsetX: CGFloat
    let offsetY: CGFloat
    let rotation: Double
    let wordFont: Font
    let plusOneFont: Font
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(word.uppercased())
                .font(wordFont)
            Text("+1")
                .font(plusOneFont)
        }
        .foregroundStyle(color.opacity(opacity))
        .rotationEffect(.degrees(rotation))
        .offset(x: offsetX, y: offsetY)
    }
}

// MARK: - Wooden Fish View (Main)
struct WoodenFishView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var floatingTexts: [FloatingText] = []

    private let textColor = Color(red: 0.251, green: 0.200, blue: 0.137) // ~#403323

    private let wisdomWords = [
        "Peace", "Comfort", "Serenity", "Calm",
        "Harmony", "Bliss", "Grace", "Zen",
        "Tranquil", "Stillness",
    ]

    /// Image width scales with screen — 1.2× original (84% of screen width, cap 408pt)
    private var imageWidth: CGFloat {
        min(UIScreen.main.bounds.width * 0.84, 408)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // ===== Top: "MINDFULNESS COUNT" label =====
            Text("MINDFULNESS COUNT")
                .font(.custom("CormorantInfant-Bold", size: 16))
                .foregroundStyle(textColor.opacity(0.5))
                .tracking(2)
                .padding(.bottom, 8)

            // ===== Middle: Large tap count =====
            MonospaceCounter(
                count: tapManager.todayCount,
                font: .custom("CormorantInfant-Bold", size: 120),
                color: textColor
            )

            Spacer()

            // ===== Bottom: Wooden fish with mallet =====
            woodenFishSection

            Spacer().frame(height: 12)
        }
    }

    private var woodenFishSection: some View {
        ZStack {
            // Wooden fish image (single composite with mallet)
            Image(isPressed ? "muyu_pressed" : "muyu_normal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageWidth)
                .scaleEffect(isPressed ? 0.97 * 1.15 : 1.15)

            // Floating texts — rendered ABOVE the image
            ForEach(floatingTexts) { ft in
                StyledFloatingTextView(
                    word: ft.text,
                    opacity: ft.opacity,
                    offsetX: ft.offsetX,
                    offsetY: ft.offsetY,
                    rotation: ft.rotation,
                    wordFont: .custom("CormorantInfant-Bold", size: 14),
                    plusOneFont: .custom("Devonshire-Regular", size: 32),
                    color: textColor
                )
            }
        }
        .frame(height: imageWidth * 1.15)
        .onTapGesture {
            performTap()
        }
    }

    // MARK: - Tap Action
    private func performTap() {
        HapticManager.woodenFishTap()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        // Instant press — no easing
        isPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            isPressed = false
        }

        // Floating text — random position wrapping around the item
        let word = wisdomWords.randomElement() ?? "Peace"
        let isLeft = Bool.random()
        let halfW = imageWidth / 2
        let xOffset = CGFloat.random(in: (halfW * 0.55)...(halfW * 0.95)) * (isLeft ? -1 : 1)
        let angle = Double.random(in: 10...25) * (isLeft ? -1 : 1)
        // Start from above the image top edge
        let startY = -(imageWidth * 0.45)
        let ft = FloatingText(text: word, offsetX: xOffset, offsetY: startY, rotation: angle)
        floatingTexts.append(ft)

        withAnimation(.easeOut(duration: 1.8)) {
            if let index = floatingTexts.firstIndex(where: { $0.id == ft.id }) {
                floatingTexts[index].offsetY = startY - 100
                floatingTexts[index].opacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            floatingTexts.removeAll { $0.id == ft.id }
        }
    }
}

// MARK: - FloatingText Model
struct FloatingText: Identifiable {
    let id = UUID()
    let text: String
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = -20
    var opacity: Double = 1.0
    var rotation: Double = 0
}

#Preview {
    ZStack {
        Color(red: 0.749, green: 0.690, blue: 0.612) // #bfb09c
            .ignoresSafeArea()
        WoodenFishView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
