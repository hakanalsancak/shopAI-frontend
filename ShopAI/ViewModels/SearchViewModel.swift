//
//  SearchViewModel.swift
//  Zokey
//
//  Manages the search flow and results
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var answers: [String: AnswerValue] = [:]
    
    @Published var isLoadingQuestions: Bool = false
    @Published var isSearching: Bool = false
    @Published var errorMessage: String?
    
    @Published var searchResults: RecommendationResponse?
    @Published var showResults: Bool = false
    @Published var showLimitReached: Bool = false
    
    // Category info
    @Published var categoryName: String = ""
    @Published var subcategoryName: String = ""
    
    // MARK: - Services
    
    private let apiService = APIService.shared
    
    // MARK: - Computed Properties
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex >= questions.count - 1
    }
    
    var canProceed: Bool {
        guard let question = currentQuestion else { return false }
        
        if !question.required {
            return true
        }
        
        return answers[question.id] != nil
    }
    
    // MARK: - Load Questions
    
    func loadQuestions(for subcategory: Subcategory, currency: String) async {
        isLoadingQuestions = true
        errorMessage = nil
        
        // Reset state
        questions = []
        currentQuestionIndex = 0
        answers = [:]
        searchResults = nil
        showResults = false
        
        do {
            let response = try await apiService.getQuestions(
                subcategoryId: subcategory.id,
                currency: currency
            )
            
            questions = response.questions
            categoryName = response.categoryName
            subcategoryName = response.subcategoryName
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingQuestions = false
    }
    
    // MARK: - Answer Management
    
    func setAnswer(_ value: AnswerValue, for questionId: String) {
        answers[questionId] = value
    }
    
    func getAnswer(for questionId: String) -> AnswerValue? {
        return answers[questionId]
    }
    
    func getStringAnswer(for questionId: String) -> String? {
        guard let answer = answers[questionId] else { return nil }
        
        switch answer {
        case .string(let value):
            return value
        default:
            return nil
        }
    }
    
    func getStringArrayAnswer(for questionId: String) -> [String] {
        guard let answer = answers[questionId] else { return [] }
        
        switch answer {
        case .stringArray(let values):
            return values
        default:
            return []
        }
    }
    
    func getRangeAnswer(for questionId: String) -> (min: Double, max: Double)? {
        guard let answer = answers[questionId] else { return nil }
        
        switch answer {
        case .range(let min, let max):
            return (min, max)
        default:
            return nil
        }
    }
    
    // MARK: - Navigation
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentQuestionIndex += 1
            }
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentQuestionIndex -= 1
            }
        }
    }
    
    // MARK: - Search
    
    func performSearch(subcategoryId: String) async {
        isSearching = true
        errorMessage = nil
        showLimitReached = false
        
        do {
            // Convert answers to SearchAnswer array
            let searchAnswers = answers.map { key, value in
                SearchAnswer(questionId: key, value: value)
            }
            
            searchResults = try await apiService.search(
                subcategoryId: subcategoryId,
                answers: searchAnswers
            )
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showResults = true
            }
            
        } catch APIServiceError.limitReached {
            showLimitReached = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isSearching = false
    }
    
    // MARK: - Reset
    
    func reset() {
        questions = []
        currentQuestionIndex = 0
        answers = [:]
        searchResults = nil
        showResults = false
        showLimitReached = false
        errorMessage = nil
    }
}
