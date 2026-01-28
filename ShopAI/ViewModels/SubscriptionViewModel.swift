//
//  SubscriptionViewModel.swift
//  Zokey
//
//  Manages subscription state and purchases
//

import Foundation
import Combine
import StoreKit
import SwiftUI

@MainActor
class SubscriptionViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var plans: [SubscriptionPlan] = []
    @Published var storeProducts: [StoreProduct] = []
    @Published var selectedPlan: SubscriptionPlan?
    
    @Published var isLoading: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    @Published var showSuccessAnimation: Bool = false
    
    // MARK: - Services
    
    private let apiService = APIService.shared
    private let storeKitService = StoreKitService.shared
    
    // MARK: - Computed Properties
    
    var hasActiveSubscription: Bool {
        storeKitService.hasActiveSubscription
    }
    
    // MARK: - Load Plans
    
    func loadPlans(currency: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load plans from backend (for display info)
            plans = try await apiService.getSubscriptionPlans(currency: currency)
            
            // Load actual StoreKit products
            await storeKitService.loadProducts()
            storeProducts = storeKitService.products
            
        } catch {
            errorMessage = "Failed to load subscription options"
            print("Load plans error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Purchase
    
    func purchase(plan: SubscriptionPlan) async {
        isPurchasing = true
        errorMessage = nil
        successMessage = nil
        
        // Find matching StoreKit product
        guard let product = storeProducts.first(where: { $0.id == plan.productId }) else {
            errorMessage = "Product not available"
            isPurchasing = false
            return
        }
        
        do {
            let success = try await storeKitService.purchase(product)
            
            if success {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showSuccessAnimation = true
                }
                successMessage = "Welcome to Zokey Premium! 🎉"
                
                // Dismiss success after delay
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                showSuccessAnimation = false
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isPurchasing = false
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            try await storeKitService.restorePurchases()
            
            if storeKitService.hasActiveSubscription {
                successMessage = "Subscription restored successfully!"
            } else {
                errorMessage = "No previous purchases found"
            }
            
        } catch {
            errorMessage = "Failed to restore purchases"
        }
        
        isLoading = false
    }
    
    // MARK: - Select Plan
    
    func selectPlan(_ plan: SubscriptionPlan) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            selectedPlan = plan
        }
    }
    
    // MARK: - Clear Messages
    
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
}
