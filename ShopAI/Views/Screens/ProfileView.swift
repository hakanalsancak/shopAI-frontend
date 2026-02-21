//
//  ProfileView.swift
//  Zokey
//
//  User profile and account management
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
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
                Text("Your Profile")
                    .font(.shopaiTitle3)
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, Spacing.md)
    }
    
    // MARK: - Stats Card
    
    private var statsCard: some View {
        VStack(spacing: Spacing.md) {
            Text("Your Stats")
                .font(.shopaiHeadline)
                .foregroundColor(.shopaiCardTextPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.lg) {
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
            Text("Zokey")
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
    
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
