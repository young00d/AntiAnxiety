import SwiftUI

// MARK: - Paw Print View (小猫爪印装饰，用于寄语页)
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

// MARK: - Cat View (Main)
struct CatView: View {
    var tapManager: TapManager
    @State private var isPressed = false
    @State private var floatingTexts: [FloatingText] = []

    private let textColor = Color(red: 0.251, green: 0.200, blue: 0.137) // #403323

    private let catWords = [
        "Meow", "Purrrr", "Mrrp", "Nyaa",
        "Chirp", "Prrrr", "Mew", "Nyan",
        "Prrrt", "Mrrow",
    ]

    /// Random keyboard-cat gibberish
    private var keyboardGibberish: String {
        let chars = Array("&@.)(#01$4)!*%^~+=?<>{}[];:'\"")
        let length = Int.random(in: 8...14)
        return String((0..<length).map { _ in chars.randomElement()! })
    }

    @State private var gibberishText = "&@.)(#01&4)$"

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // ===== Top: Keyboard-cat decorative text =====
            Text(gibberishText)
                .font(.custom("CoveredByYourGrace", size: 22))
                .foregroundStyle(textColor.opacity(0.5))
                .padding(.bottom, 8)

            // ===== Middle: Large tap count =====
            Text("\(tapManager.todayCount)")
                .font(.custom("ZenLoop-Regular", size: 160))
                .foregroundStyle(textColor)
                .contentTransition(.numericText())
                .padding(.bottom, 0)

            Spacer()

            // ===== Bottom: Real cat paw photo =====
            catPawSection

            Spacer().frame(height: 12)
        }
    }

    private var catPawSection: some View {
        ZStack {
            // Floating texts
            ForEach(floatingTexts) { ft in
                StyledFloatingTextView(
                    word: ft.text,
                    opacity: ft.opacity,
                    offsetX: ft.offsetX,
                    offsetY: ft.offsetY,
                    rotation: ft.rotation,
                    wordFont: .custom("CoveredByYourGrace", size: 18),
                    plusOneFont: .custom("ZenLoop-Regular", size: 36),
                    color: textColor
                )
            }

            // Cat paw image
            Image(isPressed ? "cat_paw_pressed" : "cat_paw_normal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 220)
                .rotationEffect(.degrees(2.8))
                .scaleEffect(isPressed ? 0.93 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .frame(height: 320)
        .clipped()
        .onTapGesture {
            performTap()
        }
    }

    private func performTap() {
        HapticManager.catTap()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        // Press animation
        withAnimation(.easeInOut(duration: 0.06)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = false
            }
        }

        // Update keyboard gibberish
        gibberishText = keyboardGibberish

        // Floating text — random position wrapping around the paw
        let word = catWords.randomElement() ?? "Meow"
        let isLeft = Bool.random()
        let xOffset = CGFloat.random(in: 60...110) * (isLeft ? -1 : 1)
        let angle = Double.random(in: 8...22) * (isLeft ? -1 : 1)
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

#Preview {
    ZStack {
        Color(red: 0.843, green: 0.737, blue: 0.639) // #d7bca3
            .ignoresSafeArea()
        CatView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
