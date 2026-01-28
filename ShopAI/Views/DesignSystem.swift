//
//  DesignSystem.swift
//  Zokey
//
//  Design tokens, colors, and reusable styles
//

import SwiftUI

// MARK: - Color Palette (Blue background with white theme)

extension Color {
    // Primary Color - #0063FF
    static let shopaiPrimary = Color(red: 0.0, green: 0.388, blue: 1.0) // #0063FF
    static let shopaiPrimaryDark = Color(red: 0.0, green: 0.30, blue: 0.85) // Darker variant
    static let shopaiPrimaryLight = Color(red: 0.3, green: 0.55, blue: 1.0) // Lighter variant
    
    // Secondary
    static let shopaiAccent = Color.white // White accent for contrast
    
    // Backgrounds
    static let shopaiBackground = Color(red: 0.0, green: 0.388, blue: 1.0) // #0063FF - Main blue background
    static let shopaiCardBackground = Color.white
    
    // Text - White for visibility on blue background
    static let shopaiTextPrimary = Color.white
    static let shopaiTextSecondary = Color.white.opacity(0.85)
    
    // Status
    static let shopaiSuccess = Color(red: 0.18, green: 0.74, blue: 0.42) // #2EBD6B
    static let shopaiWarning = Color(red: 1.0, green: 0.73, blue: 0.23) // #FFBA3B
    static let shopaiError = Color(red: 0.91, green: 0.30, blue: 0.24) // #E84D3D
    
    // Prime badge
    static let amazonPrime = Color(red: 1.0, green: 0.60, blue: 0.0) // #FF9900
    
    // Card text colors (for white card backgrounds)
    static let shopaiCardTextPrimary = Color(red: 0.12, green: 0.14, blue: 0.20) // Dark text for cards
    static let shopaiCardTextSecondary = Color(red: 0.45, green: 0.49, blue: 0.56) // Secondary text for cards
}

// MARK: - Gradients

extension LinearGradient {
    static let shopaiPrimaryGradient = LinearGradient(
        colors: [Color.shopaiPrimary, Color.shopaiPrimaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let shopaiCardGradient = LinearGradient(
        colors: [Color.shopaiCardBackground, Color.white.opacity(0.95)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let shopaiAccentGradient = LinearGradient(
        colors: [Color.white, Color.white.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Typography

extension Font {
    static let shopaiLargeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let shopaiTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let shopaiTitle2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let shopaiTitle3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let shopaiHeadline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let shopaiBody = Font.system(size: 17, weight: .regular, design: .default)
    static let shopaiCallout = Font.system(size: 16, weight: .regular, design: .default)
    static let shopaiSubheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let shopaiFootnote = Font.system(size: 13, weight: .regular, design: .default)
    static let shopaiCaption = Font.system(size: 12, weight: .regular, design: .default)
}

// MARK: - Shadows

extension View {
    func shopaiCardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
    
    func shopaiButtonShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    func shopaiSubtleShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Spacing

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius

enum CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

// MARK: - Primary Button Style

struct ZokeyPrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.shopaiHeadline)
            .foregroundColor(.shopaiPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(
                Group {
                    if isDisabled {
                        Color.white.opacity(0.3)
                    } else {
                        Color.white
                    }
                }
            )
            .cornerRadius(CornerRadius.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
            .shopaiButtonShadow()
    }
}

// MARK: - Secondary Button Style

struct ZokeySecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.shopaiHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(Color.white.opacity(0.2))
            .cornerRadius(CornerRadius.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Card Style

struct ZokeyCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.shopaiCardBackground)
            .cornerRadius(CornerRadius.large)
            .shopaiCardShadow()
    }
}

extension View {
    func shopaiCard() -> some View {
        modifier(ZokeyCardModifier())
    }
}

// MARK: - Selection Card Style

struct SelectionCardStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(isSelected ? Color.shopaiPrimary : Color.clear, lineWidth: 3)
                    )
            )
            .shopaiCardShadow()
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Loading Shimmer Effect

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.0),
                        Color.white.opacity(0.5),
                        Color.white.opacity(0.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Skeleton Loading View

struct SkeletonView: View {
    var width: CGFloat? = nil
    var height: CGFloat = 20
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.2))
            .frame(width: width, height: height)
            .shimmer()
    }
}

// MARK: - Rating Stars View

struct RatingStarsView: View {
    let rating: Double
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .foregroundColor(.shopaiWarning)
                    .font(.caption)
            }
        }
    }
    
    private func starType(for index: Int) -> String {
        let threshold = Double(index)
        if rating >= threshold {
            return "star.fill"
        } else if rating >= threshold - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

// MARK: - Prime Badge

struct PrimeBadge: View {
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption2)
            Text("Prime")
                .font(.caption2.weight(.semibold))
        }
        .foregroundColor(.amazonPrime)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color.amazonPrime.opacity(0.1))
        .cornerRadius(4)
    }
}

// MARK: - Discount Badge

struct DiscountBadge: View {
    let percentage: Int
    
    var body: some View {
        Text("-\(percentage)%")
            .font(.caption.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.shopaiError)
            .cornerRadius(4)
    }
}

// MARK: - Pulse Animation

struct PulseAnimation: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulse() -> some View {
        modifier(PulseAnimation())
    }
}
