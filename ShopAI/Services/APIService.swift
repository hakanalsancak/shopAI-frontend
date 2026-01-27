//
//  APIService.swift
//  ShopAI
//
//  Network layer for backend API communication
//

import Foundation
import Combine

// MARK: - API Configuration

enum APIConfig {
    // Change this to your Vercel deployment URL in production
    // For local testing, use your computer's IP (not localhost for simulator)
    #if DEBUG
    static let baseURL = "http://localhost:3000/api"
    #else
    static let baseURL = "https://your-app.vercel.app/api"
    #endif
    
    static let timeout: TimeInterval = 30
}

// MARK: - API Errors

enum APIServiceError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(String)
    case networkError(Error)
    case unauthorized
    case limitReached
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Data error: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Please sign in again"
        case .limitReached:
            return "Free search limit reached"
        }
    }
}

// MARK: - API Service

@MainActor
class APIService: ObservableObject {
    static let shared = APIService()
    
    @Published var authToken: String?
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.timeout
        config.timeoutIntervalForResource = APIConfig.timeout
        self.session = URLSession(configuration: config)
        
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    
    // MARK: - Token Management
    
    func setAuthToken(_ token: String) {
        self.authToken = token
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    func loadAuthToken() {
        self.authToken = UserDefaults.standard.string(forKey: "authToken")
    }
    
    func clearAuthToken() {
        self.authToken = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    // MARK: - Request Building
    
    private func buildRequest(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        authenticated: Bool = false
    ) throws -> URLRequest {
        guard let url = URL(string: "\(APIConfig.baseURL)\(endpoint)") else {
            throw APIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if authenticated, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    // MARK: - Generic Request
    
    private func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIServiceError.noData
            }
            
            // Handle HTTP errors
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw APIServiceError.unauthorized
            case 403:
                // Check if it's a limit reached error
                if let apiResponse = try? decoder.decode(APIResponse<EmptyResponse>.self, from: data),
                   apiResponse.error?.code == "LIMIT_REACHED" {
                    throw APIServiceError.limitReached
                }
                throw APIServiceError.serverError("Access denied")
            case 429:
                throw APIServiceError.serverError("Too many requests. Please try again later.")
            default:
                if let apiResponse = try? decoder.decode(APIResponse<EmptyResponse>.self, from: data),
                   let error = apiResponse.error {
                    throw APIServiceError.serverError(error.message)
                }
                throw APIServiceError.serverError("Server error: \(httpResponse.statusCode)")
            }
            
            // Decode response
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
            
            if let error = apiResponse.error {
                throw APIServiceError.serverError(error.message)
            }
            
            guard let responseData = apiResponse.data else {
                throw APIServiceError.noData
            }
            
            return responseData
            
        } catch let error as APIServiceError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIServiceError.decodingError(error)
        } catch {
            throw APIServiceError.networkError(error)
        }
    }
    
    // MARK: - Auth Endpoints
    
    func register(deviceId: String, region: String, currency: String) async throws -> RegisterResponse {
        let requestBody = RegisterRequest(deviceId: deviceId, region: region, currency: currency)
        let body = try encoder.encode(requestBody)
        let request = try buildRequest(endpoint: "/auth/register", method: "POST", body: body)
        return try await performRequest(request)
    }
    
    func getUserStatus() async throws -> UserStatusResponse {
        let request = try buildRequest(endpoint: "/auth/status", authenticated: true)
        return try await performRequest(request)
    }
    
    // MARK: - Category Endpoints
    
    func getCategories(currency: String = "GBP") async throws -> [Category] {
        let request = try buildRequest(endpoint: "/categories?currency=\(currency)")
        return try await performRequest(request)
    }
    
    func getQuestions(subcategoryId: String, currency: String = "GBP") async throws -> QuestionsResponse {
        let request = try buildRequest(endpoint: "/categories/\(subcategoryId)/questions?currency=\(currency)")
        return try await performRequest(request)
    }
    
    // MARK: - Search Endpoints
    
    func search(subcategoryId: String, answers: [SearchAnswer]) async throws -> RecommendationResponse {
        let requestBody = SearchRequest(subcategoryId: subcategoryId, answers: answers)
        let body = try encoder.encode(requestBody)
        let request = try buildRequest(endpoint: "/search", method: "POST", body: body, authenticated: true)
        return try await performRequest(request)
    }
    
    // MARK: - Subscription Endpoints
    
    func getSubscriptionPlans(currency: String = "GBP") async throws -> [SubscriptionPlan] {
        let request = try buildRequest(endpoint: "/subscriptions/plans?currency=\(currency)")
        return try await performRequest(request)
    }
    
    func validateReceipt(receiptData: String) async throws -> ReceiptValidationResponse {
        let requestBody = ReceiptValidationRequest(receiptData: receiptData)
        let body = try encoder.encode(requestBody)
        let request = try buildRequest(endpoint: "/subscriptions/validate", method: "POST", body: body, authenticated: true)
        return try await performRequest(request)
    }
    
    func restorePurchases(receiptData: String) async throws -> ReceiptValidationResponse {
        let requestBody = ReceiptValidationRequest(receiptData: receiptData)
        let body = try encoder.encode(requestBody)
        let request = try buildRequest(endpoint: "/subscriptions/restore", method: "POST", body: body, authenticated: true)
        return try await performRequest(request)
    }
}

// MARK: - Empty Response Helper

private struct EmptyResponse: Codable {}
