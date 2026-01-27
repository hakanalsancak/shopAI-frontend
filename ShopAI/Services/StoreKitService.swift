//
//  StoreKitService.swift
//  ShopAI
//
//  Handles Apple StoreKit subscriptions
//

import Foundation
import Combine
import StoreKit

// Type alias to avoid conflict with our Product model
typealias StoreProduct = StoreKit.Product

// MARK: - Product IDs (must match App Store Connect)

enum StoreKitProductID: String, CaseIterable {
    case weekly = "com.shopai.subscription.weekly"
    case yearly = "com.shopai.subscription.yearly"
}

// MARK: - StoreKit Service

@MainActor
class StoreKitService: ObservableObject {
    static let shared = StoreKitService()
    
    @Published var products: [StoreProduct] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        // Start listening for transactions
        updateListenerTask = listenForTransactions()
        
        // Load products
        Task {
            await loadProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Transaction Listener
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Load Products
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let productIDs = StoreKitProductID.allCases.map { $0.rawValue }
            let storeProducts = try await StoreProduct.products(for: productIDs)
            
            // Sort: yearly first (best value)
            products = storeProducts.sorted { product1, product2 in
                if product1.id.contains("yearly") { return true }
                if product2.id.contains("yearly") { return false }
                return product1.price < product2.price
            }
            
            await updatePurchasedProducts()
            
        } catch {
            errorMessage = "Failed to load subscription options"
            print("Failed to load products: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Update Purchased Products
    
    func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil {
                    purchased.insert(transaction.productID)
                }
            } catch {
                print("Failed to verify transaction: \(error)")
            }
        }
        
        purchasedProductIDs = purchased
    }
    
    // MARK: - Purchase
    
    func purchase(_ product: StoreProduct) async throws -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                // Validate with backend
                await validateWithBackend()
                
                await updatePurchasedProducts()
                await transaction.finish()
                
                return true
                
            case .userCancelled:
                return false
                
            case .pending:
                errorMessage = "Purchase is pending approval"
                return false
                
            @unknown default:
                errorMessage = "Unknown purchase result"
                return false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            throw error
        }
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async throws {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            
            // Validate with backend
            await validateWithBackend()
            
            if purchasedProductIDs.isEmpty {
                errorMessage = "No purchases to restore"
            }
        } catch {
            errorMessage = "Failed to restore purchases"
            throw error
        }
    }
    
    // MARK: - Backend Validation
    
    private func validateWithBackend() async {
        // Note: appStoreReceiptURL is deprecated in iOS 18+
        // For iOS 18+, use Transaction.currentEntitlements instead
        // This is kept for backward compatibility
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            print("No receipt found")
            return
        }
        
        let receiptString = receiptData.base64EncodedString()
        
        do {
            let _ = try await APIService.shared.validateReceipt(receiptData: receiptString)
        } catch {
            print("Backend validation failed: \(error)")
        }
    }
    
    // MARK: - Check Subscription Status
    
    var hasActiveSubscription: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    func getActiveSubscription() async -> StoreProduct? {
        for product in products {
            if purchasedProductIDs.contains(product.id) {
                return product
            }
        }
        return nil
    }
    
    // MARK: - Verification
    
    // nonisolated to allow calling from detached tasks
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitServiceError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - StoreKit Errors

enum StoreKitServiceError: Error, LocalizedError {
    case failedVerification
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed"
        case .purchaseFailed:
            return "Purchase failed"
        }
    }
}

// MARK: - StoreProduct Extensions

extension StoreProduct {
    var periodLabel: String {
        guard let subscription = self.subscription else { return "" }
        
        switch subscription.subscriptionPeriod.unit {
        case .week:
            return "/week"
        case .month:
            return "/month"
        case .year:
            return "/year"
        case .day:
            return "/day"
        @unknown default:
            return ""
        }
    }
    
    var isYearly: Bool {
        id.contains("yearly")
    }
}
