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
        case .woodenFish: return .brown.opacity(0.6)
        case .cat: return Color(red: 0.75, green: 0.50, blue: 0.48).opacity(0.6)
        }
    }

    var body: some View {
        ZStack {
            // Background
            backgroundForSkin(currentSkin)
                .ignoresSafeArea()

            if let tapManager {
                VStack(spacing: 0) {
                    Spacer()

                    // Main content area
                    switch currentSkin {
                    case .threeBody:
                        ThreeBodyView(tapManager: tapManager)
                    case .woodenFish:
                        WoodenFishView(tapManager: tapManager)
                    case .cat:
                        CatView(tapManager: tapManager)
                    }

                    Spacer()

                    // Bottom bar
                    HStack {
                        Button {
                            showDailyQuote = true
                        } label: {
                            Image(systemName: "text.quote")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(iconColor)
                        }
                        .padding(.leading, 24)

                        Spacer()

                        Button {
                            showStats = true
                        } label: {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(iconColor)
                        }

                        Spacer()

                        Button {
                            showSkinPicker = true
                        } label: {
                            Image(systemName: "tshirt")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(iconColor)
                        }
                        .padding(.trailing, 24)
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
            Color(red: 0.96, green: 0.93, blue: 0.90)
        case .woodenFish:
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    Color(red: 0.92, green: 0.88, blue: 0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .cat:
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.96, blue: 0.94),
                    Color(red: 0.98, green: 0.92, blue: 0.90)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
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
        case .threeBody: return Color(red: 0.96, green: 0.93, blue: 0.90)
        case .woodenFish: return Color(red: 0.92, green: 0.88, blue: 0.82)
        case .cat: return Color(red: 1.0, green: 0.94, blue: 0.92)
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
