//
//  Components.swift
//  ShopAI
//
//  Reusable UI components
//

import SwiftUI

// MARK: - Category Card

struct CategoryCard: View {
    let category: Category
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Icon
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(.shopaiPrimary)
                    .frame(width: 50, height: 50)
                    .background(Color.shopaiPrimary.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
                
                // Content
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(category.name)
                        .font(.shopaiHeadline)
                        .foregroundColor(.shopaiTextPrimary)
                    
                    Text(category.description)
                        .font(.shopaiSubheadline)
                        .foregroundColor(.shopaiTextSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.shopaiTextSecondary)
            }
            .padding(Spacing.md)
            .shopaiCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Subcategory Card

struct SubcategoryCard: View {
    let subcategory: Subcategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.sm) {
                Image(systemName: subcategory.icon)
                    .font(.title)
                    .foregroundColor(.shopaiPrimary)
                    .frame(width: 60, height: 60)
                    .background(Color.shopaiPrimary.opacity(0.1))
                    .cornerRadius(CornerRadius.large)
                
                Text(subcategory.name)
                    .font(.shopaiCallout)
                    .foregroundColor(.shopaiTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.md)
            .shopaiCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Option Button

struct OptionButton: View {
    let option: QuestionOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? .shopaiPrimary : .shopaiTextSecondary)
                        .frame(width: 28)
                }
                
                Text(option.label)
                    .font(.shopaiBody)
                    .foregroundColor(.shopaiTextPrimary)
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.shopaiPrimary : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.shopaiPrimary)
                            .frame(width: 14, height: 14)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(isSelected ? Color.shopaiPrimary.opacity(0.08) : Color.shopaiCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(isSelected ? Color.shopaiPrimary : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Multi-Select Option Button

struct MultiSelectOptionButton: View {
    let option: QuestionOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Text(option.label)
                    .font(.shopaiBody)
                    .foregroundColor(.shopaiTextPrimary)
                
                Spacer()
                
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isSelected ? Color.shopaiPrimary : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.shopaiPrimary)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(isSelected ? Color.shopaiPrimary.opacity(0.08) : Color.shopaiCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(isSelected ? Color.shopaiPrimary : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Budget Preset Button

struct BudgetPresetButton: View {
    let preset: BudgetPreset
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(preset.label)
                .font(.shopaiCallout)
                .foregroundColor(isSelected ? .white : .shopaiTextPrimary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .fill(isSelected ? Color.shopaiPrimary : Color.shopaiPrimary.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Progress Bar

struct QuestionProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                
                // Progress
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient.shopaiPrimaryGradient)
                    .frame(width: geometry.size.width * progress, height: 6)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 6)
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.shopaiPrimary)
            
            Text(message)
                .font(.shopaiCallout)
                .foregroundColor(.shopaiTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.shopaiBackground)
    }
}

// MARK: - Error View

struct ErrorView: View {
    let message: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.shopaiWarning)
            
            Text(message)
                .font(.shopaiBody)
                .foregroundColor(.shopaiTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let retryAction = retryAction {
                Button("Try Again") {
                    retryAction()
                }
                .buttonStyle(ShopAIPrimaryButtonStyle())
                .frame(width: 150)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.shopaiBackground)
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.shopaiTextSecondary.opacity(0.5))
            
            Text(title)
                .font(.shopaiTitle3)
                .foregroundColor(.shopaiTextPrimary)
            
            Text(message)
                .font(.shopaiBody)
                .foregroundColor(.shopaiTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
        }
    }
}

// MARK: - Search Status Badge

struct SearchStatusBadge: View {
    let remainingSearches: Int
    let hasSubscription: Bool
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: hasSubscription ? "infinity" : "magnifyingglass")
                .font(.caption)
            
            if hasSubscription {
                Text("Unlimited")
                    .font(.shopaiCaption.weight(.semibold))
            } else {
                Text("\(remainingSearches) free left")
                    .font(.shopaiCaption.weight(.semibold))
            }
        }
        .foregroundColor(hasSubscription ? .shopaiSuccess : .shopaiPrimary)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(
            (hasSubscription ? Color.shopaiSuccess : Color.shopaiPrimary).opacity(0.1)
        )
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Affiliate Disclosure Banner

struct AffiliateDisclosureBanner: View {
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "info.circle.fill")
                .font(.caption)
            
            Text("We earn a commission from qualifying Amazon purchases")
                .font(.shopaiCaption)
        }
        .foregroundColor(.shopaiTextSecondary)
        .padding(Spacing.sm)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}
