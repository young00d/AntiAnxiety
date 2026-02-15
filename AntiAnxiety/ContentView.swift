import SwiftUI

struct ContentView: View {
    @State private var currentSkin: SkinType = .threeBody
    @State private var showSkinPicker = false

    var body: some View {
        ZStack {
            // Background
            backgroundForSkin(currentSkin)
                .ignoresSafeArea()

            VStack {
                // Top bar with skin switcher
                HStack {
                    Spacer()
                    Button {
                        showSkinPicker = true
                    } label: {
                        Image(systemName: "paintpalette")
                            .font(.title2)
                            .foregroundStyle(currentSkin == .threeBody ? .white.opacity(0.7) : .brown.opacity(0.6))
                    }
                    .padding(.trailing, 24)
                }
                .padding(.top, 8)

                Spacer()

                // Main content area
                switch currentSkin {
                case .threeBody:
                    ThreeBodyView()
                case .woodenFish:
                    WoodenFishView()
                }

                Spacer()
            }
        }
        .sheet(isPresented: $showSkinPicker) {
            SkinPickerSheet(currentSkin: $currentSkin)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    func backgroundForSkin(_ skin: SkinType) -> some View {
        switch skin {
        case .threeBody:
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.02, green: 0.02, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .woodenFish:
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    Color(red: 0.92, green: 0.88, blue: 0.82)
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

            HStack(spacing: 20) {
                ForEach(SkinType.allCases) { skin in
                    skinCard(skin)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    func skinCard(_ skin: SkinType) -> some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(skin == .threeBody
                          ? Color(red: 0.05, green: 0.05, blue: 0.15)
                          : Color(red: 0.92, green: 0.88, blue: 0.82))
                    .frame(height: 120)

                if skin == .threeBody {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 36))
                        .foregroundStyle(.cyan)
                } else {
                    Text("🪵")
                        .font(.system(size: 40))
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(currentSkin == skin ? Color.accentColor : Color.clear, lineWidth: 3)
            )

            Text(skin.displayName)
                .font(.subheadline)
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
}

#Preview {
    ContentView()
}
