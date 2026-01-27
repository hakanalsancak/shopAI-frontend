//
//  PaywallView.swift
//  ShopAI
//
//  Subscription paywall with StoreKit integration
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = SubscriptionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var animateIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Blue background
                Color.shopaiBackground
                    .ignoresSafeArea()
                
                if viewModel.showSuccessAnimation {
                    successView
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.lg) {
                            // Header
                            headerSection
                            
                            // Features
                            featuresSection
                            
                            // Plans
                            plansSection
                            
                            // Purchase button
                            purchaseButton
                            
                            // Restore purchases
                            Button {
                                Task {
                                    await viewModel.restorePurchases()
                                }
                            } label: {
                                Text("Restore Purchases")
                                    .font(.shopaiSubheadline)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, Spacing.sm)
                            
                            // Legal links
                            legalSection
                            
                            Spacer(minLength: Spacing.xxl)
                        }
                        .padding(.top, Spacing.lg)
                    }
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
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearMessages()
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                Task {
                    await viewModel.loadPlans(currency: appViewModel.currency)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        animateIn = true
                    }
                }
            }
            .onChange(of: viewModel.hasActiveSubscription) { _, newValue in
                if newValue {
                    Task {
                        await appViewModel.refreshUserStatus()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: Spacing.md) {
            // Premium icon
            ZStack {
                Circle()
                    .fill(LinearGradient.shopaiPrimaryGradient)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.shopaiPrimary.opacity(0.3), radius: 20, y: 10)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            .offset(y: animateIn ? 0 : -20)
            .opacity(animateIn ? 1 : 0)
            
            VStack(spacing: Spacing.xs) {
                Text("Unlock Unlimited")
                    .font(.shopaiTitle)
                    .foregroundColor(.shopaiTextPrimary)
                
                Text("Product Research")
                    .font(.shopaiTitle)
                    .foregroundStyle(LinearGradient.shopaiPrimaryGradient)
            }
            .offset(y: animateIn ? 0 : 10)
            .opacity(animateIn ? 1 : 0)
            
            Text("Get AI-powered recommendations for any product")
                .font(.shopaiBody)
                .foregroundColor(.shopaiTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
                .offset(y: animateIn ? 0 : 10)
                .opacity(animateIn ? 1 : 0)
        }
        .padding(.top, Spacing.lg)
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(spacing: Spacing.md) {
            FeatureRow(icon: "infinity", title: "Unlimited Searches", subtitle: "Research as many products as you want")
            FeatureRow(icon: "sparkles", title: "AI Rankings", subtitle: "Smart recommendations tailored to you")
            FeatureRow(icon: "folder", title: "All Categories", subtitle: "Electronics, fashion, home & more")
            FeatureRow(icon: "arrow.clockwise", title: "Cancel Anytime", subtitle: "No commitment, cancel in Settings")
        }
        .padding()
        .background(Color.shopaiCardBackground)
        .cornerRadius(CornerRadius.large)
        .shopaiCardShadow()
        .padding(.horizontal)
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - Plans Section
    
    private var plansSection: some View {
        VStack(spacing: Spacing.md) {
            // Use StoreKit products if available, otherwise show backend plans
            if !viewModel.storeProducts.isEmpty {
                ForEach(viewModel.storeProducts, id: \.id) { product in
                    StoreKitPlanCard(
                        product: product,
                        isSelected: viewModel.selectedPlan?.productId == product.id
                    ) {
                        // Find matching plan
                        if let plan = viewModel.plans.first(where: { $0.productId == product.id }) {
                            viewModel.selectPlan(plan)
                        }
                    }
                }
            } else if !viewModel.plans.isEmpty {
                ForEach(viewModel.plans) { plan in
                    PlanCard(
                        plan: plan,
                        isSelected: viewModel.selectedPlan?.id == plan.id
                    ) {
                        viewModel.selectPlan(plan)
                    }
                }
            } else if viewModel.isLoading {
                VStack(spacing: Spacing.sm) {
                    SkeletonView(height: 80)
                    SkeletonView(height: 80)
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .offset(y: animateIn ? 0 : 30)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: animateIn)
    }
    
    // MARK: - Purchase Button
    
    private var purchaseButton: some View {
        Button {
            guard let plan = viewModel.selectedPlan else { return }
            
            Task {
                await viewModel.purchase(plan: plan)
            }
        } label: {
            HStack {
                if viewModel.isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Continue")
                    Image(systemName: "arrow.right")
                }
            }
        }
        .buttonStyle(ShopAIPrimaryButtonStyle(isDisabled: viewModel.selectedPlan == nil || viewModel.isPurchasing))
        .disabled(viewModel.selectedPlan == nil || viewModel.isPurchasing)
        .padding(.horizontal)
        .offset(y: animateIn ? 0 : 30)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: animateIn)
    }
    
    // MARK: - Legal Section
    
    private var legalSection: some View {
        VStack(spacing: Spacing.xs) {
            Text("Subscriptions auto-renew. Cancel anytime in Settings.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: Spacing.md) {
                Button("Terms of Service") {
                    // Open terms
                }
                .font(.caption)
                .foregroundColor(.white)
                
                Text("•")
                    .foregroundColor(.white.opacity(0.7))
                
                Button("Privacy Policy") {
                    // Open privacy
                }
                .font(.caption)
                .foregroundColor(.white)
            }
        }
        .padding(.top, Spacing.md)
    }
    
    // MARK: - Success View
    
    private var successView: some View {
        VStack(spacing: Spacing.xl) {
            ZStack {
                Circle()
                    .fill(Color.shopaiSuccess)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(viewModel.showSuccessAnimation ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.showSuccessAnimation)
            
            VStack(spacing: Spacing.sm) {
                Text("Welcome to Premium!")
                    .font(.shopaiTitle2)
                    .foregroundColor(.shopaiTextPrimary)
                
                Text("You now have unlimited searches")
                    .font(.shopaiBody)
                    .foregroundColor(.shopaiTextSecondary)
            }
            .opacity(viewModel.showSuccessAnimation ? 1 : 0)
            .animation(.easeIn.delay(0.3), value: viewModel.showSuccessAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.shopaiPrimary)
                .frame(width: 44, height: 44)
                .background(Color.shopaiPrimary.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.shopaiHeadline)
                    .foregroundColor(.shopaiCardTextPrimary)
                
                Text(subtitle)
                    .font(.shopaiCaption)
                    .foregroundColor(.shopaiCardTextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundColor(.shopaiSuccess)
        }
    }
}

// MARK: - Plan Card

struct PlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(plan.name)
                            .font(.shopaiHeadline)
                            .foregroundColor(.shopaiCardTextPrimary)
                        
                        if let badge = plan.badge {
                            Text(badge)
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.shopaiSuccess)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(plan.period == "yearly" ? "Save 90% vs weekly" : "Flexible weekly billing")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(plan.formattedPrice)
                        .font(.shopaiTitle3)
                        .foregroundColor(.shopaiPrimary)
                    
                    Text(plan.periodLabel)
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(isSelected ? Color.shopaiPrimary : Color.clear, lineWidth: 3)
                    )
            )
            .shopaiSubtleShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - StoreKit Plan Card

struct StoreKitPlanCard: View {
    let product: StoreProduct
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(product.displayName)
                            .font(.shopaiHeadline)
                            .foregroundColor(.shopaiCardTextPrimary)
                        
                        if product.isYearly {
                            Text("Best Value")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.shopaiSuccess)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(product.description)
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(product.displayPrice)
                        .font(.shopaiTitle3)
                        .foregroundColor(.shopaiPrimary)
                    
                    Text(product.periodLabel)
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(isSelected ? Color.shopaiPrimary : Color.clear, lineWidth: 3)
                    )
            )
            .shopaiSubtleShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    PaywallView()
        .environmentObject(AppViewModel())
}
