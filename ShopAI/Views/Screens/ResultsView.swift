//
//  ResultsView.swift
//  ShopAI
//
//  Displays AI-ranked product recommendations
//

import SwiftUI
import SafariServices

struct ResultsView: View {
    let results: RecommendationResponse
    
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var animateCards = false
    @State private var showSafari = false
    @State private var selectedURL: URL?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.shopaiBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Summary Card
                        summaryCard
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: animateCards)
                        
                        // Products
                        ForEach(Array(results.products.enumerated()), id: \.element.id) { index, product in
                            ProductCard(product: product) {
                                openProduct(product)
                            }
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 30)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.8)
                                .delay(Double(index + 1) * 0.1),
                                value: animateCards
                            )
                        }
                        
                        // Affiliate Disclosure
                        AffiliateDisclosureBanner()
                            .padding(.horizontal)
                        
                        Spacer(minLength: Spacing.xxl)
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark")
                            Text("Close")
                        }
                        .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Recommendations")
                            .font(.shopaiHeadline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                            Text("AI Ranked")
                                .font(.caption2)
                        }
                        .foregroundColor(.white.opacity(0.85))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Start new search
                        dismiss()
                        Task {
                            await appViewModel.refreshUserStatus()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showSafari) {
                if let url = selectedURL {
                    SafariView(url: url)
                        .ignoresSafeArea()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateCards = true
                }
            }
        }
    }
    
    // MARK: - Summary Card
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(.shopaiPrimary)
                
                Text("AI Summary")
                    .font(.shopaiHeadline)
                    .foregroundColor(.shopaiCardTextPrimary)
                
                Spacer()
                
                Text("\(results.products.count) products")
                    .font(.shopaiCaption)
                    .foregroundColor(.shopaiCardTextSecondary)
            }
            
            // Summary text
            Text(results.summary)
                .font(.shopaiBody)
                .foregroundColor(.shopaiCardTextPrimary)
                .lineSpacing(4)
            
            Divider()
            
            // Search criteria
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Your preferences")
                    .font(.shopaiCaption)
                    .foregroundColor(.shopaiCardTextSecondary)
                
                HStack(spacing: Spacing.sm) {
                    CriteriaTag(icon: "folder", text: results.searchCriteria.subcategory)
                    CriteriaTag(icon: "creditcard", text: results.searchCriteria.budget)
                }
                
                if !results.searchCriteria.priorities.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.sm) {
                            ForEach(results.searchCriteria.priorities, id: \.self) { priority in
                                CriteriaTag(icon: "checkmark.circle", text: priority)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .shopaiCard()
        .padding(.horizontal)
    }
    
    // MARK: - Actions
    
    private func openProduct(_ product: RankedProduct) {
        guard let url = URL(string: product.amazonUrl) else { return }
        
        // Try to open Amazon app first
        let amazonAppURL = URL(string: "com.amazon.mobile.shopping://www.amazon.com/dp/\(product.asin)")
        
        if let amazonURL = amazonAppURL, UIApplication.shared.canOpenURL(amazonURL) {
            UIApplication.shared.open(amazonURL)
        } else {
            // Fall back to Safari
            selectedURL = url
            showSafari = true
        }
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let product: RankedProduct
    let onTap: () -> Void
    
    @State private var imageLoaded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Rank badge
            HStack {
                RankBadge(rank: product.rank, score: product.matchScore)
                
                Spacer()
                
                if product.isPrime {
                    PrimeBadge()
                }
                
                if let discount = product.discountPercentage, discount > 0 {
                    DiscountBadge(percentage: discount)
                }
            }
            
            HStack(alignment: .top, spacing: Spacing.md) {
                // Product image
                AsyncImage(url: URL(string: product.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        SkeletonView(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .transition(.opacity)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 100, height: 100)
                .cornerRadius(CornerRadius.medium)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
                
                // Product info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(product.title)
                        .font(.shopaiCallout)
                        .foregroundColor(.shopaiCardTextPrimary)
                        .lineLimit(3)
                    
                    // Rating
                    HStack(spacing: Spacing.xs) {
                        RatingStarsView(rating: product.rating)
                        
                        Text("(\(formatReviewCount(product.reviewCount)))")
                            .font(.shopaiCaption)
                            .foregroundColor(.shopaiCardTextSecondary)
                    }
                    
                    // Price
                    HStack(alignment: .firstTextBaseline, spacing: Spacing.xs) {
                        Text(product.formattedPrice)
                            .font(.shopaiTitle3)
                            .foregroundColor(.shopaiPrimary)
                        
                        if let original = product.formattedOriginalPrice {
                            Text(original)
                                .font(.shopaiSubheadline)
                                .foregroundColor(.shopaiCardTextSecondary)
                                .strikethrough()
                        }
                    }
                }
            }
            
            // AI Explanation
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.shopaiPrimary)
                    
                    Text("Why we recommend this")
                        .font(.shopaiCaption.weight(.semibold))
                        .foregroundColor(.shopaiCardTextSecondary)
                }
                
                Text(product.explanation)
                    .font(.shopaiSubheadline)
                    .foregroundColor(.shopaiCardTextPrimary)
                    .lineSpacing(2)
            }
            
            // Pros and Cons
            HStack(alignment: .top, spacing: Spacing.lg) {
                // Pros
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(product.pros.prefix(3), id: \.self) { pro in
                        HStack(alignment: .top, spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption2)
                                .foregroundColor(.shopaiSuccess)
                            
                            Text(pro)
                                .font(.shopaiCaption)
                                .foregroundColor(.shopaiCardTextPrimary)
                        }
                    }
                }
                
                Spacer()
                
                // Cons
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(product.cons.prefix(2), id: \.self) { con in
                        HStack(alignment: .top, spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.caption2)
                                .foregroundColor(.shopaiWarning)
                            
                            Text(con)
                                .font(.shopaiCaption)
                                .foregroundColor(.shopaiCardTextPrimary)
                        }
                    }
                }
            }
            
            // View on Amazon button
            Button(action: onTap) {
                HStack {
                    Text("View on Amazon")
                        .font(.shopaiHeadline)
                    
                    Image(systemName: "arrow.up.right")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.sm)
                .background(Color.amazonPrime)
                .cornerRadius(CornerRadius.medium)
            }
        }
        .padding()
        .shopaiCard()
        .padding(.horizontal)
    }
    
    private func formatReviewCount(_ count: Int) -> String {
        if count >= 1000 {
            return "\(String(format: "%.1f", Double(count) / 1000))k"
        }
        return "\(count)"
    }
}

// MARK: - Rank Badge

struct RankBadge: View {
    let rank: Int
    let score: Int
    
    var badgeColor: Color {
        switch rank {
        case 1: return .shopaiPrimary
        case 2: return .shopaiSuccess
        case 3: return .shopaiWarning
        default: return .shopaiCardTextSecondary
        }
    }
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Rank number
            ZStack {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 28, height: 28)
                
                Text("#\(rank)")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
            }
            
            // Match score
            VStack(alignment: .leading, spacing: 0) {
                Text("\(score)% match")
                    .font(.shopaiCaption.weight(.semibold))
                    .foregroundColor(.shopaiCardTextPrimary)
                
                Text(rank == 1 ? "Best overall" : rank <= 3 ? "Great choice" : "Good option")
                    .font(.caption2)
                    .foregroundColor(.shopaiCardTextSecondary)
            }
        }
    }
}

// MARK: - Criteria Tag

struct CriteriaTag: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            
            Text(text)
                .font(.shopaiCaption)
        }
        .foregroundColor(.shopaiCardTextSecondary)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 4)
        .background(Color.shopaiPrimary.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Safari View

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        
        let safari = SFSafariViewController(url: url, configuration: config)
        safari.preferredControlTintColor = UIColor(Color.shopaiPrimary)
        return safari
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    ResultsView(
        results: RecommendationResponse(
            searchId: "test",
            products: [
                RankedProduct(
                    asin: "TEST001",
                    title: "Apple iPhone 15 Pro Max 256GB - Natural Titanium",
                    price: 1199.00,
                    currency: "GBP",
                    originalPrice: 1299.00,
                    imageUrl: "https://picsum.photos/200",
                    rating: 4.8,
                    reviewCount: 12453,
                    amazonUrl: "https://amazon.co.uk",
                    isPrime: true,
                    availability: "In Stock",
                    features: ["A17 Pro chip"],
                    rank: 1,
                    matchScore: 95,
                    explanation: "This is the best match for your needs based on camera quality and performance priorities.",
                    pros: ["Excellent camera", "Great performance", "Premium build"],
                    cons: ["High price"]
                )
            ],
            summary: "Based on your preferences for a smartphone with great camera and performance, here are our top picks.",
            searchCriteria: SearchCriteria(
                category: "Electronics",
                subcategory: "Smartphones",
                budget: "£800 - £1500",
                priorities: ["Camera", "Performance"]
            ),
            disclaimer: "Prices may vary",
            timestamp: "2026-01-27"
        )
    )
    .environmentObject(AppViewModel())
}
