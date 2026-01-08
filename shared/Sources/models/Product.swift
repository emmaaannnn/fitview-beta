import Foundation

public enum GenderCategory: String, Codable, CaseIterable, Sendable {
    case mens = "Men"
    case womens = "Women"
    case unisex = "Unisex"
    case unknown = "Unknown"
}

public struct Product: Codable, Identifiable, Equatable {
    // 1. Internal System ID
    public let id: UUID
    
    // 2. THE ANCHORS (Identity Verification)
    public let brandName: String // The manufacturer (e.g., "Nike", "Uniqlo")
    public let sku: String // The unique manufacturer ID (e.g., "HV0950-234"). Required for version tracking.

    // 3. CONTEXTUAL METADATA (Ease of use for consumer)
    public let storeName: String
    public let name: String
    public let genderCategory: GenderCategory
    public let originRegion: MarketRegion 
    public let originalURL: URL
    
    // 4. TIMELINE
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        brandName: String,
        sku: String, // Now required
        storeName: String,
        name: String,
        genderCategory: GenderCategory = .unknown,
        originRegion: MarketRegion,
        originalURL: URL,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.brandName = brandName
        self.sku = sku
        self.storeName = storeName
        self.name = name
        self.genderCategory = genderCategory
        self.originRegion = originRegion
        self.originalURL = originalURL
        self.createdAt = createdAt
    }
}