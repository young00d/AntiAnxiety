import SwiftUI

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
            Text("\(tapManager.todayCount)")
                .font(.custom("CormorantInfant-Bold", size: 120))
                .foregroundStyle(textColor)
                .contentTransition(.numericText())

            Spacer()

            // ===== Bottom: Wooden fish with mallet =====
            woodenFishSection

            Spacer().frame(height: 12)
        }
    }

    private var woodenFishSection: some View {
        ZStack {
            // Floating texts
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

            // Wooden fish image (single composite with mallet)
            Image(isPressed ? "muyu_pressed" : "muyu_normal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 280)
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .animation(.spring(response: 0.15, dampingFraction: 0.6), value: isPressed)
        }
        .frame(height: 340)
        .clipped()
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

        // Strike animation
        withAnimation(.easeInOut(duration: 0.06)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = false
            }
        }

        // Floating text — random position wrapping around the item
        let word = wisdomWords.randomElement() ?? "Peace"
        let isLeft = Bool.random()
        let xOffset = CGFloat.random(in: 70...120) * (isLeft ? -1 : 1)
        let angle = Double.random(in: 10...25) * (isLeft ? -1 : 1)
        let ft = FloatingText(text: word, offsetX: xOffset, rotation: angle)
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
