//
//  QuestionFlowView.swift
//  ShopAI
//
//  Step-by-step question flow for product search
//

import SwiftUI

struct QuestionFlowView: View {
    let subcategory: Subcategory
    
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showResultsView = false
    
    var body: some View {
        ZStack {
            Color.shopaiBackground
                .ignoresSafeArea()
            
            if viewModel.isLoadingQuestions {
                LoadingView(message: "Preparing questions...")
            } else if viewModel.isSearching {
                SearchingView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task {
                        await viewModel.loadQuestions(for: subcategory, currency: appViewModel.currency)
                    }
                }
            } else {
                questionContent
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if viewModel.currentQuestionIndex > 0 {
                        viewModel.previousQuestion()
                    } else {
                        dismiss()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text(viewModel.currentQuestionIndex > 0 ? "Back" : "Cancel")
                    }
                    .foregroundColor(.shopaiPrimary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(viewModel.subcategoryName)
                    .font(.shopaiHeadline)
                    .foregroundColor(.shopaiTextPrimary)
            }
        }
        .fullScreenCover(isPresented: $showResultsView) {
            if let results = viewModel.searchResults {
                ResultsView(results: results)
                    .environmentObject(appViewModel)
            }
        }
        .sheet(isPresented: $viewModel.showLimitReached) {
            PaywallView()
        }
        .onAppear {
            Task {
                await viewModel.loadQuestions(for: subcategory, currency: appViewModel.currency)
            }
        }
        .onChange(of: viewModel.showResults) { _, newValue in
            if newValue {
                showResultsView = true
            }
        }
    }
    
    // MARK: - Question Content
    
    private var questionContent: some View {
        VStack(spacing: 0) {
            // Progress bar
            VStack(spacing: Spacing.sm) {
                QuestionProgressBar(progress: viewModel.progress)
                
                HStack {
                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiTextSecondary)
                    
                    Spacer()
                }
            }
            .padding()
            
            // Question
            if let question = viewModel.currentQuestion {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Question text
                        Text(question.text)
                            .font(.shopaiTitle3)
                            .foregroundColor(.shopaiTextPrimary)
                            .padding(.horizontal)
                        
                        // Answer options
                        questionView(for: question)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .id(question.id) // Forces view recreation for animation
            }
            
            Spacer()
            
            // Continue button
            VStack(spacing: Spacing.md) {
                if !viewModel.canProceed && viewModel.currentQuestion?.required == true {
                    Text("Please select an option")
                        .font(.shopaiCaption)
                        .foregroundColor(.shopaiTextSecondary)
                }
                
                Button {
                    if viewModel.isLastQuestion {
                        // Perform search
                        Task {
                            await viewModel.performSearch(subcategoryId: subcategory.id)
                        }
                    } else {
                        viewModel.nextQuestion()
                    }
                } label: {
                    HStack {
                        Text(viewModel.isLastQuestion ? "Find Products" : "Continue")
                        
                        if viewModel.isLastQuestion {
                            Image(systemName: "sparkles")
                        } else {
                            Image(systemName: "arrow.right")
                        }
                    }
                }
                .buttonStyle(ShopAIPrimaryButtonStyle(isDisabled: !viewModel.canProceed))
                .disabled(!viewModel.canProceed)
                .padding(.horizontal)
                .padding(.bottom, Spacing.lg)
            }
        }
    }
    
    // MARK: - Question Views
    
    @ViewBuilder
    private func questionView(for question: Question) -> some View {
        switch question.type {
        case .singleSelect, .brandSelect:
            singleSelectView(for: question)
            
        case .multiSelect:
            multiSelectView(for: question)
            
        case .range:
            rangeView(for: question)
        }
    }
    
    // MARK: - Single Select
    
    private func singleSelectView(for question: Question) -> some View {
        VStack(spacing: Spacing.sm) {
            ForEach(question.options ?? []) { option in
                let isSelected = viewModel.getStringAnswer(for: question.id) == option.value
                
                OptionButton(
                    option: option,
                    isSelected: isSelected
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.setAnswer(.string(option.value), for: question.id)
                    }
                }
            }
        }
    }
    
    // MARK: - Multi Select
    
    private func multiSelectView(for question: Question) -> some View {
        VStack(spacing: Spacing.sm) {
            Text("Select up to 3 options")
                .font(.shopaiCaption)
                .foregroundColor(.shopaiTextSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(question.options ?? []) { option in
                let selectedValues = viewModel.getStringArrayAnswer(for: question.id)
                let isSelected = selectedValues.contains(option.value)
                
                MultiSelectOptionButton(
                    option: option,
                    isSelected: isSelected
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        var newValues = selectedValues
                        
                        if isSelected {
                            newValues.removeAll { $0 == option.value }
                        } else if newValues.count < 3 {
                            newValues.append(option.value)
                        }
                        
                        viewModel.setAnswer(.stringArray(newValues), for: question.id)
                    }
                }
            }
        }
    }
    
    // MARK: - Range View
    
    private func rangeView(for question: Question) -> some View {
        BudgetRangeView(
            question: question,
            viewModel: viewModel,
            currency: appViewModel.currency
        )
    }
}

// MARK: - Budget Range View

struct BudgetRangeView: View {
    let question: Question
    @ObservedObject var viewModel: SearchViewModel
    let currency: String
    
    @State private var selectedPreset: BudgetPreset?
    @State private var minValue: Double = 0
    @State private var maxValue: Double = 1000
    
    var currencySymbol: String {
        currency == "GBP" ? "£" : "$"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Presets
            if let presets = question.rangeConfig?.presets {
                Text("Quick select")
                    .font(.shopaiCaption)
                    .foregroundColor(.shopaiTextSecondary)
                
                FlexibleView(data: presets, spacing: Spacing.sm, alignment: .leading) { preset in
                    BudgetPresetButton(
                        preset: preset,
                        isSelected: selectedPreset?.label == preset.label
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedPreset = preset
                            minValue = preset.min
                            maxValue = preset.max
                            viewModel.setAnswer(.range(min: preset.min, max: preset.max), for: question.id)
                        }
                    }
                }
            }
            
            // Custom range
            VStack(spacing: Spacing.md) {
                Text("Or set custom range")
                    .font(.shopaiCaption)
                    .foregroundColor(.shopaiTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Range display
                HStack {
                    Text("\(currencySymbol)\(Int(minValue))")
                        .font(.shopaiHeadline)
                        .foregroundColor(.shopaiPrimary)
                    
                    Spacer()
                    
                    Text("to")
                        .font(.shopaiBody)
                        .foregroundColor(.shopaiTextSecondary)
                    
                    Spacer()
                    
                    Text("\(currencySymbol)\(Int(maxValue))")
                        .font(.shopaiHeadline)
                        .foregroundColor(.shopaiPrimary)
                }
                .padding()
                .background(Color.shopaiPrimary.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
                
                // Sliders
                if let config = question.rangeConfig {
                    VStack(spacing: Spacing.sm) {
                        // Min slider
                        HStack {
                            Text("Min")
                                .font(.shopaiCaption)
                                .foregroundColor(.shopaiTextSecondary)
                                .frame(width: 30)
                            
                            Slider(
                                value: $minValue,
                                in: config.min...config.max,
                                step: config.step
                            )
                            .tint(.shopaiPrimary)
                            .onChange(of: minValue) { _, newValue in
                                if newValue > maxValue {
                                    maxValue = newValue
                                }
                                selectedPreset = nil
                                viewModel.setAnswer(.range(min: minValue, max: maxValue), for: question.id)
                            }
                        }
                        
                        // Max slider
                        HStack {
                            Text("Max")
                                .font(.shopaiCaption)
                                .foregroundColor(.shopaiTextSecondary)
                                .frame(width: 30)
                            
                            Slider(
                                value: $maxValue,
                                in: config.min...config.max,
                                step: config.step
                            )
                            .tint(.shopaiPrimary)
                            .onChange(of: maxValue) { _, newValue in
                                if newValue < minValue {
                                    minValue = newValue
                                }
                                selectedPreset = nil
                                viewModel.setAnswer(.range(min: minValue, max: maxValue), for: question.id)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // Set defaults
            if let config = question.rangeConfig {
                minValue = config.min
                maxValue = config.max / 2 // Start at mid-point
                
                // Pre-select first preset
                if let firstPreset = config.presets.first {
                    selectedPreset = firstPreset
                    minValue = firstPreset.min
                    maxValue = firstPreset.max
                    viewModel.setAnswer(.range(min: firstPreset.min, max: firstPreset.max), for: question.id)
                }
            }
        }
    }
}

// MARK: - Searching View

struct SearchingView: View {
    @State private var animationPhase = 0
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Animated icons
            ZStack {
                ForEach(0..<3) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: 30))
                        .foregroundColor(.shopaiPrimary)
                        .offset(
                            x: cos(Double(animationPhase + index * 120) * .pi / 180) * 40,
                            y: sin(Double(animationPhase + index * 120) * .pi / 180) * 40
                        )
                        .opacity(0.8)
                }
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 40))
                    .foregroundColor(.shopaiPrimary)
                    .scaleEffect(1 + sin(Double(animationPhase) * .pi / 90) * 0.1)
            }
            .frame(width: 120, height: 120)
            
            VStack(spacing: Spacing.sm) {
                Text("Finding Your Perfect Products")
                    .font(.shopaiTitle3)
                    .foregroundColor(.shopaiTextPrimary)
                
                Text("Our AI is analyzing your preferences...")
                    .font(.shopaiBody)
                    .foregroundColor(.shopaiTextSecondary)
            }
            
            // Progress dots
            HStack(spacing: Spacing.sm) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(Color.shopaiPrimary)
                        .frame(width: 10, height: 10)
                        .opacity((animationPhase / 30) % 4 == index ? 1 : 0.3)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.shopaiBackground)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                animationPhase = (animationPhase + 3) % 360
            }
        }
    }
}

// MARK: - Flexible View for Tags

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            FlexibleViewInner(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct FlexibleViewInner<Data: Collection, Content: View>: View where Data.Element: Identifiable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .alignmentGuide(.leading) { dimension in
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height -= dimension.height + spacing
                            }
                            let result = width
                            if index == data.count - 1 {
                                width = 0
                            } else {
                                width -= dimension.width + spacing
                            }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if index == data.count - 1 {
                                height = 0
                            }
                            return result
                        }
                }
            }
        }
        .frame(height: 80) // Adjust based on content
    }
}

// MARK: - Size Reader

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        QuestionFlowView(
            subcategory: Subcategory(
                id: "phones",
                name: "Smartphones",
                icon: "iphone",
                categoryId: "electronics",
                questionFlow: QuestionFlowConfig(questions: [])
            )
        )
        .environmentObject(AppViewModel())
    }
}
