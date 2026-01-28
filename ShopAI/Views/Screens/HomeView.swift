//
//  HomeView.swift
//  Zokey
//
//  Category selection screen
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showSubcategories = false
    @State private var animateCards = false
    @State private var searchText = ""
    @State private var showProfile = false
    
    // Filtered subcategories based on search
    private var filteredSubcategories: [Subcategory] {
        guard let subcategories = appViewModel.selectedCategory?.subcategories else { return [] }
        if searchText.isEmpty {
            return subcategories
        }
        return subcategories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
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
            .sheet(isPresented: $showProfile) {
                ProfileView()
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
                // Profile button at top right
                HStack {
                    Spacer()
                    
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: appViewModel.hasActiveSubscription ? "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                
                // Main header - centered with shadow
                VStack(spacing: Spacing.sm) {
                    VStack(spacing: Spacing.xs) {
                        Text("Find Your")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Perfect Product")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                    
                    // Slogan
                    Text("Powered by AI")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(1.5)
                }
                .frame(maxWidth: .infinity)
                
            } else {
                // Subcategory header with back button
                HStack {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            appViewModel.selectedCategory = nil
                            searchText = ""
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
                
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(appViewModel.selectedCategory?.name ?? "")
                        .font(.shopaiTitle2)
                        .foregroundColor(.shopaiTextPrimary)
                    
                    // Search bar
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.shopaiCardTextSecondary)
                        
                        TextField("Search subcategories...", text: $searchText)
                            .font(.shopaiBody)
                            .foregroundColor(.shopaiCardTextPrimary)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.shopaiCardTextSecondary)
                            }
                        }
                    }
                    .padding(Spacing.sm)
                    .background(Color.white)
                    .cornerRadius(CornerRadius.medium)
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
        
        let isOddCount = filteredSubcategories.count % 2 == 1
        let lastIndex = filteredSubcategories.count - 1
        
        return VStack(spacing: Spacing.md) {
            if filteredSubcategories.isEmpty && !searchText.isEmpty {
                // No results found
                VStack(spacing: Spacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("No subcategories found")
                        .font(.shopaiBody)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Try a different search term")
                        .font(.shopaiCaption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, Spacing.xl)
            } else {
                // Main grid (all items except last if odd count)
                LazyVGrid(columns: columns, spacing: Spacing.md) {
                    ForEach(Array(filteredSubcategories.enumerated()), id: \.element.id) { index, subcategory in
                        // Skip last item if odd count (will be centered below)
                        if !(isOddCount && index == lastIndex) {
                            SubcategoryCard(subcategory: subcategory) {
                                searchText = ""
                                appViewModel.selectSubcategory(subcategory)
                            }
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(Double(index) * 0.03),
                                value: animateCards
                            )
                        }
                    }
                }
                
                // Centered last item if odd count
                if isOddCount && !filteredSubcategories.isEmpty {
                    HStack {
                        Spacer()
                        SubcategoryCard(subcategory: filteredSubcategories[lastIndex]) {
                            searchText = ""
                            appViewModel.selectSubcategory(filteredSubcategories[lastIndex])
                        }
                        .frame(maxWidth: (UIScreen.main.bounds.width - Spacing.md * 3) / 2)
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 20)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(Double(lastIndex) * 0.03),
                            value: animateCards
                        )
                        Spacer()
                    }
                }
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
