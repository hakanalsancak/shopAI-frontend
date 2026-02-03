//
//  AppViewModel.swift
//  Zokey
//
//  Main app state management
//

import Foundation
import Combine
import SwiftUI

@MainActor
class AppViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isLoading: Bool = true
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    @Published var userStatus: UserStatusResponse?
    @Published var categories: [Category] = []
    
    // Navigation state
    @Published var selectedCategory: Category?
    @Published var selectedSubcategory: Subcategory?
    @Published var showPaywall: Bool = false
    
    // Region settings
    @Published var region: String = "UK"
    @Published var currency: String = "GBP"
    
    // MARK: - Services
    
    private let apiService = APIService.shared
    private let storeKitService = StoreKitService.shared
    
    // MARK: - Computed Properties
    
    var freeSearchesRemaining: Int {
        userStatus?.freeSearchesRemaining ?? 3
    }
    
    var hasActiveSubscription: Bool {
        userStatus?.subscriptionStatus == .active || storeKitService.hasActiveSubscription
    }
    
    var canSearch: Bool {
        hasActiveSubscription || freeSearchesRemaining > 0
    }
    
    var currencySymbol: String {
        currency == "GBP" ? "£" : "$"
    }
    
    // MARK: - Initialization
    
    init() {
        detectRegion()
        apiService.loadAuthToken()
    }
    
    // MARK: - Region Detection
    
    private func detectRegion() {
        let locale = Locale.current
        
        // Detect region from locale
        if let regionCode = locale.region?.identifier {
            switch regionCode {
            case "US":
                region = "US"
                currency = "USD"
            case "GB", "UK":
                region = "UK"
                currency = "GBP"
            default:
                // Default to UK for unsupported regions
                region = "UK"
                currency = "GBP"
            }
        }
    }
    
    // MARK: - App Initialization
    
    func initializeApp() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Check if we have a token
            if apiService.authToken != nil {
                // Try to get user status
                do {
                    userStatus = try await apiService.getUserStatus()
                    isAuthenticated = true
                } catch APIServiceError.unauthorized {
                    // Token expired, re-register
                    try await registerDevice()
                }
            } else {
                // First time - register
                try await registerDevice()
            }
            
            // Load categories
            categories = try await apiService.getCategories(currency: currency)
            
        } catch {
            errorMessage = error.localizedDescription
            print("Initialization error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Authentication
    
    private func registerDevice() async throws {
        let deviceId = getDeviceId()
        let response = try await apiService.register(
            deviceId: deviceId,
            region: region,
            currency: currency
        )
        
        apiService.setAuthToken(response.token)
        
        userStatus = UserStatusResponse(
            userId: response.user.id,
            freeSearchesRemaining: response.user.freeSearchesRemaining,
            subscriptionStatus: response.user.subscriptionStatus,
            subscriptionExpiresAt: response.user.subscriptionExpiresAt,
            canSearch: response.user.freeSearchesRemaining > 0 || response.user.subscriptionStatus == .active
        )
        
        isAuthenticated = true
    }
    
    private func getDeviceId() -> String {
        // Use stored device ID or create new one
        if let storedId = UserDefaults.standard.string(forKey: "deviceId") {
            return storedId
        }
        
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: "deviceId")
        return newId
    }
    
    // MARK: - Refresh User Status
    
    func refreshUserStatus() async {
        do {
            userStatus = try await apiService.getUserStatus()
        } catch {
            print("Failed to refresh user status: \(error)")
        }
    }
    
    // Reset free searches (TESTING ONLY)
    func resetFreeSearches() async {
        do {
            userStatus = try await apiService.resetFreeSearches()
        } catch {
            print("Failed to reset free searches: \(error)")
        }
    }
    
    // MARK: - Category Selection
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func selectSubcategory(_ subcategory: Subcategory) {
        // Check if user can search
        if !canSearch {
            showPaywall = true
            return
        }
        
        selectedSubcategory = subcategory
    }
    
    func resetSelection() {
        selectedCategory = nil
        selectedSubcategory = nil
    }
    
    // MARK: - Error Handling
    
    func clearError() {
        errorMessage = nil
    }
}
