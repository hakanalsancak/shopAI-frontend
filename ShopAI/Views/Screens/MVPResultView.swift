//
//  MVPResultView.swift
//  Zokey
//
//  Simple product recommendation view for MVP demo
//

import SwiftUI

struct MVPResultView: View {
    let product: MVPProduct?
    let subcategoryName: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var animateIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.shopaiBackground
                    .ignoresSafeArea()

                if let product = product {
                    productFoundView(product)
                } else {
                    noProductView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        animateIn = true
                    }
                }
            }
        }
    }

    // MARK: - Product Found

    private func productFoundView(_ product: MVPProduct) -> some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Success icon
            ZStack {
                Circle()
                    .fill(Color.shopaiSuccess)
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.shopaiSuccess.opacity(0.4), radius: 20, y: 10)

                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .scaleEffect(animateIn ? 1 : 0)

            // Title
            VStack(spacing: Spacing.sm) {
                Text("Our Recommendation")
                    .font(.shopaiTitle2)
                    .foregroundColor(.shopaiTextPrimary)

                Text(subcategoryName)
                    .font(.shopaiSubheadline)
                    .foregroundColor(.shopaiTextSecondary)
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 10)

            // Product card
            VStack(spacing: Spacing.lg) {
                Image(systemName: "bag.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.shopaiPrimary)

                Text(product.name)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.shopaiCardTextPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.xl)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(CornerRadius.large)
            .shopaiCardShadow()
            .padding(.horizontal, Spacing.lg)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 20)

            // View on Amazon button
            Button {
                if let url = URL(string: product.url) {
                    openURL(url)
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Text("View on Amazon")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.shopaiPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(Color.white)
                .cornerRadius(CornerRadius.medium)
            }
            .padding(.horizontal, Spacing.lg)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 20)

            // Search again button
            Button {
                dismiss()
            } label: {
                Text("Search Again")
                    .font(.shopaiSubheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, Spacing.sm)
            .opacity(animateIn ? 1 : 0)

            Spacer()
        }
    }

    // MARK: - No Product Found

    private var noProductView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.5))

            VStack(spacing: Spacing.sm) {
                Text("Coming Soon")
                    .font(.shopaiTitle2)
                    .foregroundColor(.shopaiTextPrimary)

                Text("Custom search will be available soon.\nPlease try one of the other categories.")
                    .font(.shopaiBody)
                    .foregroundColor(.shopaiTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Go Back")
                    Image(systemName: "arrow.left")
                }
            }
            .buttonStyle(ZokeyPrimaryButtonStyle(isDisabled: false))
            .padding(.horizontal, Spacing.lg)

            Spacer()
        }
    }
}

#Preview {
    MVPResultView(
        product: MVPProduct(name: "Sony WH-1000XM5", url: "https://amzn.to/example"),
        subcategoryName: "Headphones"
    )
}
