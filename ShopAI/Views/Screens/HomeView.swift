//
//  HomeView.swift
//  ShopAI
//
//  Category selection screen
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showSubcategories = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.shopaiBackground
                    .ignoresSafeArea()
                
                if appViewModel.isLoading {
                    LoadingView(message: "Loading categories...")
                } else if let error = appViewModel.errorMessage {
                    ErrorView(message: error) {
                        Task {
                            await appViewModel.initializeApp()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.lg) {
                            // Header
                            headerSection
                            
                            // Status Badge
                            HStack {
                                SearchStatusBadge(
                                    remainingSearches: appViewModel.freeSearchesRemaining,
                                    hasSubscription: appViewModel.hasActiveSubscription
                                )
                                
                                Spacer()
                                
                                Button {
                                    appViewModel.showPaywall = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "crown.fill")
                                            .font(.caption)
                                        Text("Upgrade")
                                            .font(.shopaiCaption.weight(.semibold))
                                    }
                                    .foregroundColor(.shopaiPrimary)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Category Cards
                            if appViewModel.selectedCategory == nil {
                                categoriesSection
                            } else {
                                subcategoriesSection
                            }
                            
                            Spacer(minLength: Spacing.xxl)
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationDestination(item: $appViewModel.selectedSubcategory) { subcategory in
                QuestionFlowView(subcategory: subcategory)
            }
            .sheet(isPresented: $appViewModel.showPaywall) {
                PaywallView()
            }
            .onAppear {
                if appViewModel.categories.isEmpty {
                    Task {
                        await appViewModel.initializeApp()
                    }
                }
                animateCards = true
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: Spacing.sm) {
            if appViewModel.selectedCategory == nil {
                // Main header
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Find Your")
                            .font(.shopaiTitle)
                            .foregroundColor(.shopaiTextPrimary)
                        
                        Text("Perfect Product")
                            .font(.shopaiTitle)
                            .foregroundStyle(LinearGradient.shopaiPrimaryGradient)
                    }
                    
                    Spacer()
                    
                    // AI Badge
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("AI")
                    }
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(LinearGradient.shopaiPrimaryGradient)
                    .cornerRadius(CornerRadius.small)
                }
                .padding(.horizontal)
                
                Text("Get personalized recommendations powered by AI")
                    .font(.shopaiSubheadline)
                    .foregroundColor(.shopaiTextSecondary)
                    .padding(.horizontal)
                
            } else {
                // Subcategory header with back button
                HStack {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            appViewModel.selectedCategory = nil
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.shopaiCallout)
                        .foregroundColor(.shopaiPrimary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(appViewModel.selectedCategory?.name ?? "")
                        .font(.shopaiTitle2)
                        .foregroundColor(.shopaiTextPrimary)
                    
                    Text("Choose a subcategory")
                        .font(.shopaiSubheadline)
                        .foregroundColor(.shopaiTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Categories Section
    
    private var categoriesSection: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(Array(appViewModel.categories.enumerated()), id: \.element.id) { index, category in
                CategoryCard(category: category) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        appViewModel.selectCategory(category)
                    }
                }
                .padding(.horizontal)
                .opacity(animateCards ? 1 : 0)
                .offset(y: animateCards ? 0 : 20)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.8)
                    .delay(Double(index) * 0.05),
                    value: animateCards
                )
            }
        }
    }
    
    // MARK: - Subcategories Section
    
    private var subcategoriesSection: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: Spacing.md) {
            ForEach(Array((appViewModel.selectedCategory?.subcategories ?? []).enumerated()), id: \.element.id) { index, subcategory in
                SubcategoryCard(subcategory: subcategory) {
                    appViewModel.selectSubcategory(subcategory)
                }
                .opacity(animateCards ? 1 : 0)
                .offset(y: animateCards ? 0 : 20)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.8)
                    .delay(Double(index) * 0.05),
                    value: animateCards
                )
            }
        }
        .padding(.horizontal)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .environmentObject(AppViewModel())
}
