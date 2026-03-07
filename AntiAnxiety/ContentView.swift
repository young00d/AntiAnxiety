import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentSkin: SkinType = .threeBody
    @State private var showSkinPicker = false
    @State private var showStats = false
    @State private var showDailyQuote = false
    @State private var tapManager: TapManager?
    @State private var quoteManager: DailyQuoteManager?

    private var iconColor: Color {
        switch currentSkin {
        case .threeBody: return Color(red: 0.41, green: 0.39, blue: 0.36).opacity(0.6)
        case .woodenFish: return Color(red: 0.243, green: 0.176, blue: 0.122) // #3e2d1f
        case .cat: return Color(red: 0.282, green: 0.224, blue: 0.169) // #48392b
        }
    }

    private var iconFont: Font {
        switch currentSkin {
        case .threeBody: return .system(size: 20, weight: .light)
        case .woodenFish: return .system(size: 18, weight: .bold)
        case .cat: return .system(size: 18, weight: .bold)
        }
    }

    private var iconPadding: CGFloat {
        switch currentSkin {
        case .threeBody: return 24
        case .woodenFish, .cat: return 32
        }
    }

    var body: some View {
        ZStack {
            // Background
            backgroundForSkin(currentSkin)
                .ignoresSafeArea()

            if let tapManager {
                // Main content area
                VStack(spacing: 0) {
                    Spacer()

                    switch currentSkin {
                    case .threeBody:
                        ThreeBodyView(tapManager: tapManager)
                    case .woodenFish:
                        WoodenFishView(tapManager: tapManager)
                    case .cat:
                        CatView(tapManager: tapManager)
                    }

                    // Cat paw extends behind the tab bar — no bottom spacer
                    if currentSkin != .cat {
                        Spacer()
                    }
                }

                // Bottom bar — transparent overlay, floats on top of content
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            showDailyQuote = true
                        } label: {
                            Image(systemName: "quote.opening")
                                .font(iconFont)
                                .foregroundStyle(iconColor)
                        }
                        .padding(.leading, iconPadding)

                        Spacer()

                        Button {
                            showStats = true
                        } label: {
                            Image(systemName: "chart.bar.fill")
                                .font(iconFont)
                                .foregroundStyle(iconColor)
                        }

                        Spacer()

                        Button {
                            showSkinPicker = true
                        } label: {
                            Image(systemName: "tshirt.fill")
                                .font(iconFont)
                                .foregroundStyle(iconColor)
                        }
                        .padding(.trailing, iconPadding)
                    }
                    .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            if tapManager == nil {
                tapManager = TapManager(modelContext: modelContext)
            }
            if quoteManager == nil {
                quoteManager = DailyQuoteManager(skin: currentSkin)
            }
        }
        .onChange(of: currentSkin) { _, newSkin in
            quoteManager?.updateSkin(newSkin)
        }
        .sheet(isPresented: $showSkinPicker) {
            SkinPickerSheet(currentSkin: $currentSkin)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showStats) {
            if let tapManager {
                StatsView(tapManager: tapManager, skin: currentSkin)
                    .presentationDetents([.large])
            }
        }
        .sheet(isPresented: $showDailyQuote) {
            if let quoteManager {
                DailyQuoteView(quote: quoteManager.currentQuote, skin: currentSkin)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    @ViewBuilder
    func backgroundForSkin(_ skin: SkinType) -> some View {
        switch skin {
        case .threeBody:
            Color(red: 0.96, green: 0.93, blue: 0.90) // #f4ede5
        case .woodenFish:
            Color(red: 0.749, green: 0.690, blue: 0.612) // #bfb09c
        case .cat:
            Color(red: 0.843, green: 0.737, blue: 0.639) // #d7bca3
        }
    }
}

// MARK: - Skin Picker Sheet
struct SkinPickerSheet: View {
    @Binding var currentSkin: SkinType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("选择皮肤")
                .font(.title3.bold())
                .padding(.top, 8)

            HStack(spacing: 16) {
                ForEach(SkinType.allCases) { skin in
                    skinCard(skin)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    func skinCard(_ skin: SkinType) -> some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardBackground(for: skin))
                    .frame(height: 110)

                cardIcon(for: skin)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(currentSkin == skin ? Color.accentColor : Color.clear, lineWidth: 3)
            )

            Text(skin.displayName)
                .font(.caption)
                .foregroundStyle(currentSkin == skin ? .primary : .secondary)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentSkin = skin
            }
            HapticManager.lightTap()
            dismiss()
        }
    }

    private func cardBackground(for skin: SkinType) -> Color {
        switch skin {
        case .threeBody: return Color(red: 0.96, green: 0.93, blue: 0.90) // #f4ede5
        case .woodenFish: return Color(red: 0.749, green: 0.690, blue: 0.612) // #bfb09c
        case .cat: return Color(red: 0.843, green: 0.737, blue: 0.639) // #d7bca3
        }
    }

    @ViewBuilder
    private func cardIcon(for skin: SkinType) -> some View {
        switch skin {
        case .threeBody:
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 32))
                .foregroundStyle(Color(red: 0.87, green: 0.255, blue: 0.255))
        case .woodenFish:
            Text("\u{1FAB5}")
                .font(.system(size: 36))
        case .cat:
            Image(systemName: "cat.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color(red: 0.80, green: 0.45, blue: 0.42))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DailyTapRecord.self, inMemory: true)
}
