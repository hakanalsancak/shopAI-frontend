//
//  ProfileView.swift
//  ShopAI
//
//  User profile and account management
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.shopaiBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Profile Header
                        profileHeader
                        
                        // Subscription Card
                        subscriptionCard
                        
                        // Stats Card
                        statsCard
                        
                        // Settings Options
                        settingsSection
                        
                        // App Info
                        appInfoSection
                        
                        Spacer(minLength: Spacing.xxl)
                    }
                    .padding(.top, Spacing.lg)
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
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeader: some View {
        VStack(spacing: Spacing.md) {
            // Profile Icon
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 90, height: 90)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.shopaiPrimary)
            }
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            // User Info
            VStack(spacing: Spacing.xs) {
                Text(appViewModel.hasActiveSubscription ? "Premium Member" : "Free User")
                    .font(.shopaiTitle3)
                    .foregroundColor(.white)
                
                if appViewModel.hasActiveSubscription {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                        Text("Unlimited Searches")
                            .font(.shopaiCaption)
                    }
                    .foregroundColor(.shopaiWarning)
                }
            }
        }
        .padding(.vertical, Spacing.md)
    }
    
    // MARK: - Subscription Card
    
    private var subscriptionCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Subscription")
                        .font(.shopaiHeadline)
                        .foregroundColor(.shopaiCardTextPrimary)
                    
                    Text(appViewModel.hasActiveSubscription ? "Premium Active" : "Free Plan")
                        .font(.shopaiSubheadline)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
                
                Spacer()
                
                if appViewModel.hasActiveSubscription {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title)
                        .foregroundColor(.shopaiSuccess)
                } else {
                    Image(systemName: "crown")
                        .font(.title)
                        .foregroundColor(.shopaiPrimary)
                }
            }
            
            if !appViewModel.hasActiveSubscription {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "crown.fill")
                        Text("Upgrade to Premium")
                    }
                    .font(.shopaiHeadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(
                        LinearGradient(
                            colors: [Color.shopaiPrimary, Color.shopaiPrimaryDark],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(CornerRadius.medium)
                }
            } else {
                // Show expiration date if available
                if let expiresAt = appViewModel.userStatus?.subscriptionExpiresAt {
                    Text("Renews: \(formatDate(expiresAt))")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.white)
        .cornerRadius(CornerRadius.large)
        .shopaiCardShadow()
        .padding(.horizontal)
    }
    
    // MARK: - Stats Card
    
    private var statsCard: some View {
        VStack(spacing: Spacing.md) {
            Text("Your Stats")
                .font(.shopaiHeadline)
                .foregroundColor(.shopaiCardTextPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.lg) {
                // Free Searches
                VStack(spacing: Spacing.xs) {
                    Text("\(appViewModel.freeSearchesRemaining)")
                        .font(.shopaiTitle)
                        .foregroundColor(.shopaiPrimary)
                    
                    Text("Free Searches")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 40)
                
                // Region
                VStack(spacing: Spacing.xs) {
                    Text(appViewModel.region)
                        .font(.shopaiTitle)
                        .foregroundColor(.shopaiPrimary)
                    
                    Text("Region")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 40)
                
                // Currency
                VStack(spacing: Spacing.xs) {
                    Text(appViewModel.currencySymbol)
                        .font(.shopaiTitle)
                        .foregroundColor(.shopaiPrimary)
                    
                    Text("Currency")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(Spacing.md)
        .background(Color.white)
        .cornerRadius(CornerRadius.large)
        .shopaiCardShadow()
        .padding(.horizontal)
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(spacing: 0) {
            settingsRow(icon: "bell.fill", title: "Notifications", showArrow: true) {
                // Handle notifications
            }
            
            Divider()
                .padding(.leading, 56)
            
            settingsRow(icon: "questionmark.circle.fill", title: "Help & Support", showArrow: true) {
                // Handle help
            }
            
            Divider()
                .padding(.leading, 56)
            
            settingsRow(icon: "doc.text.fill", title: "Terms of Service", showArrow: true) {
                // Handle terms
            }
            
            Divider()
                .padding(.leading, 56)
            
            settingsRow(icon: "hand.raised.fill", title: "Privacy Policy", showArrow: true) {
                // Handle privacy
            }
            
            if appViewModel.hasActiveSubscription {
                Divider()
                    .padding(.leading, 56)
                
                settingsRow(icon: "arrow.counterclockwise", title: "Restore Purchases", showArrow: false) {
                    // Handle restore
                    Task {
                        await appViewModel.refreshUserStatus()
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(CornerRadius.large)
        .shopaiCardShadow()
        .padding(.horizontal)
    }
    
    private func settingsRow(icon: String, title: String, showArrow: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.shopaiPrimary)
                    .frame(width: 28)
                
                Text(title)
                    .font(.shopaiBody)
                    .foregroundColor(.shopaiCardTextPrimary)
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.shopaiCardTextSecondary)
                }
            }
            .padding(Spacing.md)
        }
    }
    
    // MARK: - App Info Section
    
    private var appInfoSection: some View {
        VStack(spacing: Spacing.sm) {
            Text("ShopAI")
                .font(.shopaiHeadline)
                .foregroundColor(.white.opacity(0.7))
            
            Text("Version 1.0.0")
                .font(.shopaiCaption)
                .foregroundColor(.white.opacity(0.5))
            
            Text("Made with ❤️")
                .font(.shopaiCaption)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.top, Spacing.lg)
    }
    
    // MARK: - Helper Functions
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
