//
//  Models.swift
//  ShopAI
//
//  Core data models matching backend API responses
//

import Foundation

// MARK: - API Response Wrapper

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: APIError?
}

struct APIError: Codable {
    let code: String
    let message: String
}

// MARK: - Auth Models

struct RegisterRequest: Codable {
    let deviceId: String
    let region: String
    let currency: String
}

struct RegisterResponse: Codable {
    let token: String
    let user: UserInfo
}

struct UserInfo: Codable {
    let id: String
    let freeSearchesRemaining: Int
    let subscriptionStatus: SubscriptionStatus
    let subscriptionExpiresAt: String?
}

struct UserStatusResponse: Codable {
    let userId: String
    let freeSearchesRemaining: Int
    let subscriptionStatus: SubscriptionStatus
    let subscriptionExpiresAt: String?
    let canSearch: Bool
}

enum SubscriptionStatus: String, Codable {
    case none
    case active
    case expired
    case graceperiod = "grace_period"
}

// MARK: - Category Models

struct Category: Codable, Identifiable {
    let id: String
    let name: String
    let icon: String
    let description: String
    let subcategories: [Subcategory]
}

struct Subcategory: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let categoryId: String
    let questionFlow: QuestionFlowConfig
    
    // Hashable conformance for NavigationStack
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Subcategory, rhs: Subcategory) -> Bool {
        lhs.id == rhs.id
    }
}

struct QuestionFlowConfig: Codable {
    let questions: [Question]
}

struct Question: Codable, Identifiable {
    let id: String
    let text: String
    let type: QuestionType
    let required: Bool
    let options: [QuestionOption]?
    let rangeConfig: RangeConfig?
    let dynamicOptions: Bool?
    let placeholder: String?
}

enum QuestionType: String, Codable {
    case singleSelect = "single_select"
    case multiSelect = "multi_select"
    case range
    case brandSelect = "brand_select"
    case textInput = "text_input"
}

struct QuestionOption: Codable, Identifiable {
    let id: String
    let label: String
    let value: String
    let icon: String?
}

struct RangeConfig: Codable {
    let min: Double
    let max: Double
    let step: Double
    let currency: String
    let presets: [BudgetPreset]
}

struct BudgetPreset: Codable, Identifiable {
    var id: String { label }
    let label: String
    let min: Double
    let max: Double
}

// MARK: - Search Models

struct SearchRequest: Codable {
    let subcategoryId: String
    let answers: [SearchAnswer]
}

struct SearchAnswer: Codable {
    let questionId: String
    let value: AnswerValue
}

enum AnswerValue: Codable {
    case string(String)
    case stringArray([String])
    case range(min: Double, max: Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        
        if let arrayValue = try? container.decode([String].self) {
            self = .stringArray(arrayValue)
            return
        }
        
        let rangeContainer = try decoder.container(keyedBy: RangeCodingKeys.self)
        let min = try rangeContainer.decode(Double.self, forKey: .min)
        let max = try rangeContainer.decode(Double.self, forKey: .max)
        self = .range(min: min, max: max)
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .string(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .stringArray(let values):
            var container = encoder.singleValueContainer()
            try container.encode(values)
        case .range(let min, let max):
            var container = encoder.container(keyedBy: RangeCodingKeys.self)
            try container.encode(min, forKey: .min)
            try container.encode(max, forKey: .max)
        }
    }
    
    private enum RangeCodingKeys: String, CodingKey {
        case min, max
    }
}

// MARK: - Product Models

struct Product: Codable, Identifiable {
    let asin: String
    let title: String
    let price: Double
    let currency: String
    let originalPrice: Double?
    let imageUrl: String
    let rating: Double
    let reviewCount: Int
    let amazonUrl: String
    let isPrime: Bool
    let availability: String
    let features: [String]
    
    var id: String { asin }
    
    var formattedPrice: String {
        let symbol = currency == "GBP" ? "£" : "$"
        return "\(symbol)\(String(format: "%.2f", price))"
    }
    
    var formattedOriginalPrice: String? {
        guard let original = originalPrice, original > price else { return nil }
        let symbol = currency == "GBP" ? "£" : "$"
        return "\(symbol)\(String(format: "%.2f", original))"
    }
    
    var discountPercentage: Int? {
        guard let original = originalPrice, original > price else { return nil }
        return Int((1 - price / original) * 100)
    }
}

struct RankedProduct: Codable, Identifiable {
    let asin: String
    let title: String
    let price: Double
    let currency: String
    let originalPrice: Double?
    let imageUrl: String
    let rating: Double
    let reviewCount: Int
    let amazonUrl: String
    let isPrime: Bool
    let availability: String
    let features: [String]
    let rank: Int
    let matchScore: Int
    let explanation: String
    let pros: [String]
    let cons: [String]
    
    var id: String { asin }
    
    var formattedPrice: String {
        let symbol = currency == "GBP" ? "£" : "$"
        return "\(symbol)\(String(format: "%.2f", price))"
    }
    
    var formattedOriginalPrice: String? {
        guard let original = originalPrice, original > price else { return nil }
        let symbol = currency == "GBP" ? "£" : "$"
        return "\(symbol)\(String(format: "%.2f", original))"
    }
    
    var discountPercentage: Int? {
        guard let original = originalPrice, original > price else { return nil }
        return Int((1 - price / original) * 100)
    }
}

// MARK: - Recommendation Response

struct RecommendationResponse: Codable {
    let searchId: String
    let products: [RankedProduct]
    let summary: String
    let searchCriteria: SearchCriteria
    let disclaimer: String
    let timestamp: String
}

struct SearchCriteria: Codable {
    let category: String
    let subcategory: String
    let budget: String
    let priorities: [String]
}

// MARK: - Subscription Models

struct SubscriptionPlan: Codable, Identifiable {
    let id: String
    let name: String
    let productId: String
    let price: Double
    let currency: String
    let period: String
    let features: [String]
    let badge: String?
    
    var formattedPrice: String {
        let symbol = currency == "GBP" ? "£" : "$"
        return "\(symbol)\(String(format: "%.2f", price))"
    }
    
    var periodLabel: String {
        switch period {
        case "weekly": return "/week"
        case "yearly": return "/year"
        default: return ""
        }
    }
}

struct ReceiptValidationRequest: Codable {
    let receiptData: String
}

struct ReceiptValidationResponse: Codable {
    let subscriptionStatus: SubscriptionStatus
    let expiresAt: String?
    let productId: String?
    let message: String?
}

// MARK: - Questions Response

struct QuestionsResponse: Codable {
    let subcategoryId: String
    let subcategoryName: String
    let categoryName: String
    let questions: [Question]
}
