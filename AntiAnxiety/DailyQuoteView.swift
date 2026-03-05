import SwiftUI

struct DailyQuoteView: View {
    let quote: String
    let skin: SkinType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                // Decorative top
                decorativeHeader

                // Quote text
                Text(quote)
                    .font(.system(size: 17, weight: .regular, design: fontDesign))
                    .foregroundStyle(quoteTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 36)

                // Decorative bottom
                decorativeFooter

                // Label
                Text("— 今日寄语 —")
                    .font(.system(size: 12, design: fontDesign))
                    .foregroundStyle(secondaryColor)

                Spacer()
                Spacer()
            }
        }
        .onTapGesture {
            dismiss()
        }
    }

    // MARK: - Skin Properties

    private var fontDesign: Font.Design {
        switch skin {
        case .threeBody: return .monospaced
        case .woodenFish: return .serif
        case .cat: return .rounded
        }
    }

    private var quoteTextColor: Color {
        switch skin {
        case .threeBody: return Color(red: 0.41, green: 0.39, blue: 0.36).opacity(0.9)
        case .woodenFish: return .brown.opacity(0.8)
        case .cat: return Color(red: 0.55, green: 0.35, blue: 0.32)
        }
    }

    private var secondaryColor: Color {
        switch skin {
        case .threeBody: return Color(red: 0.41, green: 0.39, blue: 0.36).opacity(0.4)
        case .woodenFish: return .brown.opacity(0.4)
        case .cat: return Color(red: 0.75, green: 0.50, blue: 0.48).opacity(0.5)
        }
    }

    private var accentColor: Color {
        switch skin {
        case .threeBody: return Color(red: 0.87, green: 0.255, blue: 0.255)
        case .woodenFish: return .brown
        case .cat: return Color(red: 0.80, green: 0.45, blue: 0.42)
        }
    }

    // MARK: - Background

    @ViewBuilder
    private var backgroundView: some View {
        switch skin {
        case .threeBody:
            Color(red: 0.96, green: 0.93, blue: 0.90) // #f4ede5
        case .woodenFish:
            Color(red: 0.749, green: 0.690, blue: 0.612) // #bfb09c
        case .cat:
            Color(red: 0.843, green: 0.737, blue: 0.639) // #d7bca3
        }
    }

    // MARK: - Decorative Elements

    @ViewBuilder
    private var decorativeHeader: some View {
        switch skin {
        case .threeBody:
            // Terminal-style brackets
            HStack(spacing: 8) {
                Rectangle().fill(secondaryColor).frame(width: 20, height: 1)
                Text("//")
                    .font(.custom("CourierPrime-Regular", size: 11))
                    .foregroundStyle(secondaryColor)
                Text("DAILY BROADCAST")
                    .font(.custom("CourierPrime-Bold", size: 10))
                    .foregroundStyle(secondaryColor)
                    .tracking(2)
                Text("//")
                    .font(.custom("CourierPrime-Regular", size: 11))
                    .foregroundStyle(secondaryColor)
                Rectangle().fill(secondaryColor).frame(width: 20, height: 1)
            }

        case .woodenFish:
            // Zen divider — line with lotus
            HStack(spacing: 12) {
                Rectangle().fill(.brown.opacity(0.2)).frame(width: 40, height: 0.5)
                Text("☸")
                    .font(.system(size: 16))
                    .foregroundStyle(.brown.opacity(0.3))
                Rectangle().fill(.brown.opacity(0.2)).frame(width: 40, height: 0.5)
            }

        case .cat:
            // Paw prints
            HStack(spacing: 16) {
                PawPrintView(size: 12, color: Color(red: 0.80, green: 0.60, blue: 0.55).opacity(0.3))
                PawPrintView(size: 14, color: Color(red: 0.80, green: 0.60, blue: 0.55).opacity(0.4))
                PawPrintView(size: 12, color: Color(red: 0.80, green: 0.60, blue: 0.55).opacity(0.3))
            }
        }
    }

    @ViewBuilder
    private var decorativeFooter: some View {
        switch skin {
        case .threeBody:
            HStack(spacing: 4) {
                Text("[")
                    .font(.custom("CourierPrime-Regular", size: 11))
                    .foregroundStyle(secondaryColor.opacity(0.6))
                Rectangle().fill(secondaryColor.opacity(0.4)).frame(width: 60, height: 1)
                Text("]")
                    .font(.custom("CourierPrime-Regular", size: 11))
                    .foregroundStyle(secondaryColor.opacity(0.6))
            }

        case .woodenFish:
            HStack(spacing: 12) {
                Rectangle().fill(.brown.opacity(0.15)).frame(width: 30, height: 0.5)
                Circle().fill(.brown.opacity(0.15)).frame(width: 4, height: 4)
                Rectangle().fill(.brown.opacity(0.15)).frame(width: 30, height: 0.5)
            }

        case .cat:
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.80, green: 0.45, blue: 0.42).opacity(0.25))
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.60, blue: 0.55).opacity(0.15))
                    .frame(width: 40, height: 0.5)
                Image(systemName: "heart.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.80, green: 0.45, blue: 0.42).opacity(0.25))
            }
        }
    }
}

#Preview {
    DailyQuoteView(quote: "一切有为法，如梦幻泡影，如露亦如电，应作如是观。", skin: .woodenFish)
}
