import Foundation

public enum FitIntent: String, Codable, CaseIterable {
    case intended    // "Fits exactly how the designer meant it to"
    case sizeUp      // "I wanted it baggier, so I went up"
    case sizeDown    // "It runs huge, so I went down"
    case disappointed // "It fits poorly / not as described"
}

public struct FitReview: Codable, Identifiable, Equatable {
    public let id: UUID
    public let authorId: UUID
    
    // 1. The Anchor (Frozen at time of post)
    public let authorHeightCm: Int
    public let authorBodyBuild: BodyBuildType 
    
    // 2. The Product Snapshot
    public let brandName: String
    public let productName: String
    public let sizeValue: String         // e.g., "32", "S", "40"
    public let sizeCategory: StylePreference // mens, womens, unisex (defines the 'cut')
    public let productURL: URL?
    
    // 3. The Fit Compass (The ONLY data we require)
    // -1.0 (Tight/Short) | 0.0 (True) | 1.0 (Baggy/Long)
    public let widthFit: Double  // OBJECTIVE: How it actually fits the body
    public let lengthFit: Double // OBJECTIVE: Where it hits the limbs
    
    public let fitIntent: FitIntent // SUBJECTIVE: Was this the look you wanted?
    
    // 4. Multi-Image Content
    // An array of S3 keys. First one is the 'Hero' image.
    public let imageKeys: [String] 
    
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        authorId: UUID,
        authorHeightCm: Int,
        authorBodyBuild: BodyBuildType,
        brandName: String,
        productName: String,
        sizeValue: String,
        sizeCategory: StylePreference,
        productURL: URL? = nil,
        widthFit: Double,
        lengthFit: Double,
        fitIntent: FitIntent,
        imageKeys: [String],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.authorId = authorId
        self.authorHeightCm = authorHeightCm
        self.authorBodyBuild = authorBodyBuild
        self.brandName = brandName
        self.productName = productName
        self.sizeValue = sizeValue
        self.sizeCategory = sizeCategory
        self.productURL = productURL
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