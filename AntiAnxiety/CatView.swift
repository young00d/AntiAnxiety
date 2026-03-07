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

    /// Image width: 77% of screen width (Figma: 303pt / 393pt)
    private var imageWidth: CGFloat {
        UIScreen.main.bounds.width * 0.77
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // ===== Top: Keyboard-cat decorative text =====

            Text(gibberishText)
                .font(.custom("CoveredByYourGrace", size: 18))
                .foregroundStyle(textColor)
                .tracking(2)
                .padding(.bottom, 8)

            // ===== Middle: Large tap count =====
            MonospaceCounter(
                count: tapManager.todayCount,
                font: .custom("ZenLoop-Regular", size: 200),
                color: textColor
            )

            Spacer()

            // ===== Bottom: Real cat paw photo =====
            catPawSection
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private var catPawSection: some View {
        ZStack {
            // Cat paw image — top-aligned, arm overflows far below screen bottom
            // Image aspect ratio ≈ 1:1.34, so real height ≈ imageWidth × 1.34
            // Frame only shows the top portion (paw pads), arm goes off-screen
            Image(isPressed ? "cat_paw_pressed" : "cat_paw_normal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageWidth)
                .fixedSize()  // 锁定完整尺寸，阻止外层 frame 缩小
                .scaleEffect(1.0, anchor: .top)
                // 图片实际高度 ≈ imageWidth × 1.337 ≈ 405pt
                // VStack 已 ignoresSafeArea(.bottom)，直接延伸到屏幕底部
                // frame = imageWidth × 1.27 ≈ 384pt，溢出 ≈ 21pt（图底超出屏幕约 20pt）
                .frame(height: imageWidth * 1.27, alignment: .top)

            // Floating texts — rendered ABOVE the image
            ForEach(floatingTexts) { ft in
                StyledFloatingTextView(
                    word: ft.text,
                    opacity: ft.opacity,
                    offsetX: ft.offsetX,
                    offsetY: ft.offsetY,
                    rotation: ft.rotation,
                    wordFont: .custom("CoveredByYourGrace", size: 18),
                    plusOneFont: .custom("Devonshire-Regular", size: 32),
                    color: textColor
                )
            }
        }
        .frame(height: imageWidth * 1.27)
        .contentShape(Rectangle())
        .onTapGesture {
            performTap()
        }
    }

    private func performTap() {
        HapticManager.catTap()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tapManager.increment()
        }

        // Instant press — no easing
        isPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPressed = false
        }

        // Update keyboard gibberish
        gibberishText = keyboardGibberish

        // Floating text — random position wrapping around the paw
        let word = catWords.randomElement() ?? "Meow"
        let isLeft = Bool.random()
        let halfW = imageWidth / 2
        let xOffset = CGFloat.random(in: (halfW * 0.5)...(halfW * 0.9)) * (isLeft ? -1 : 1)
        let angle = Double.random(in: 8...22) * (isLeft ? -1 : 1)
        // Start near the paw pads (ZStack center is at frame/2 ≈ 0.635×imageWidth)
        let startY = -(imageWidth * 0.50)
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

#Preview {
    ZStack {
        Color(red: 0.843, green: 0.737, blue: 0.639) // #d7bca3
            .ignoresSafeArea()
        CatView(tapManager: .preview)
    }
    .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
