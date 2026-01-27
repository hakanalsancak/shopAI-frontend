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
                        VStack(spacing: Spacing.xl) {
                            // Header
                            headerSection
                            
                            // Category Cards
                            if appViewModel.selectedCategory == nil {
                                categoriesSection
                            } else {
                                subcategoriesSection
                            }
                            
                            Spacer(minLength: Spacing.xxl)
                        }
                        .padding(.top, Spacing.md)
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
        VStack(spacing: Spacing.md) {
            if appViewModel.selectedCategory == nil {
                // Main header - centered with shadow
                VStack(spacing: Spacing.xs) {
                    Text("Find Your")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Perfect Product")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, Spacing.md)
                
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
                        .foregroundColor(.white)
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
        let columns = [
            GridItem(.flexible(), spacing: Spacing.md),
            GridItem(.flexible(), spacing: Spacing.md)
        ]
        
        return LazyVGrid(columns: columns, spacing: Spacing.md) {
            ForEach(Array(appViewModel.categories.enumerated()), id: \.element.id) { index, category in
                CategoryGridCard(category: category) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        appViewModel.selectCategory(category)
                    }
                }
                .opacity(animateCards ? 1 : 0)
                .offset(y: animateCards ? 0 : 20)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.8)
                    .delay(Double(index) * 0.05),
                    value: animateCards
                )
            }
        }
        .padding(.horizontal)
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
