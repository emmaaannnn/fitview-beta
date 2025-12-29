import Foundation

public enum FitIntent: String, Codable, CaseIterable {
    case intended    // "Fits exactly how the designer meant it to"
    case sizeUp      // "I wanted it baggier, so I went up"
    case sizeDown    // "It runs huge, so I went down"
    case disappointed // "It fits poorly / not as described"
}

func detectRegion(from url: URL) -> MarketRegion {
    let host = url.host() ?? ""
    if host.hasSuffix(".jp") || host.hasSuffix(".kr") { return .asia }
    if host.hasSuffix(".au") { return .au }
    if host.hasSuffix(".uk") { return .uk }
    // Default to US if it's a .com global site
    return .us
}

public struct FitReview: Codable, Identifiable, Equatable {
    public let id: UUID
    public let authorId: UUID
    public let productId: UUID // Links to Product.swift
    
    // 1. The Anchor (User's stats at time of post)
    public let authorHeightCm: Int
    public let authorBodyBuild: BodyBuildType 
    
    // 2. The Item Specifics
    public let sizeValue: String         // e.g., "S"
    public let sizeCategory: StylePreference // mens, womens, unisex
    public let sizeRegion: MarketRegion     // e.g., .asia (Detected by Scraper)
    
    // 3. The Fit Compass
    public let widthFit: Double  
    public let lengthFit: Double 
    public let fitIntent: FitIntent 
    
    // 4. Content
    public let imageKeys: [String] 
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        authorId: UUID,
        productId: UUID,
        authorHeightCm: Int,
        authorBodyBuild: BodyBuildType,
        sizeValue: String,
        sizeCategory: StylePreference,
        sizeRegion: MarketRegion,
        widthFit: Double,
        lengthFit: Double,
        fitIntent: FitIntent,
        imageKeys: [String],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.authorId = authorId
        self.productId = productId
        self.authorHeightCm = authorHeightCm
        self.authorBodyBuild = authorBodyBuild
        self.sizeValue = sizeValue
        self.sizeCategory = sizeCategory
        self.sizeRegion = sizeRegion
        self.widthFit = widthFit
        self.lengthFit = lengthFit
        self.fitIntent = fitIntent
        self.imageKeys = imageKeys
        self.createdAt = createdAt
    }
}

public extension FitReview {
    /// Translates the Width X-axis into a soulful label
    var widthDescription: String {
        switch widthFit {
        case ..<(-0.7): return "Very Tight"
        case -0.7..<(-0.2): return "Slim"
        case -0.2...0.2: return "True to Size"
        case 0.2..<0.7: return "Relaxed"
        default: return "Oversized / Baggy"
        }
    }
    
    /// Translates the Length Y-axis into a soulful label
    var lengthDescription: String {
        switch lengthFit {
        case ..<(-0.7): return "Very Cropped"
        case -0.7..<(-0.2): return "Short"
        case -0.2...0.2: return "Standard Length"
        case 0.2..<0.7: return "Long"
        default: return "Extra Long / Tall"
        }
    }
    
    /// Combines both for the "Final Verdict" (e.g., "Boxy & Cropped")
    var compassVerdict: String {
        if widthFit > 0.3 && lengthFit < -0.3 {
            return "Boxy & Cropped"
        } else if widthFit > 0.5 && lengthFit > 0.5 {
            return "Super Oversized"
        } else if widthFit < -0.3 && lengthFit < -0.3 {
            return "Small & Short"
        } else {
            return "\(widthDescription) / \(lengthDescription)"
        }
    }
}