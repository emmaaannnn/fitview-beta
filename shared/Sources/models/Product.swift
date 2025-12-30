import Foundation

public enum GenderCategory: String, Codable, CaseIterable {
    case mens = "Men"
    case womens = "Women"
    case unisex = "Unisex"
    case unknown = "Unknown"
}

public struct Product: Codable, Identifiable, Equatable {
    public let id: UUID
    public let brandName: String
    public let name: String
    public let sku: String? // Added: The manufacturer's unique ID

    public let genderCategory: GenderCategory
    public let originRegion: MarketRegion 
    public let originalURL: URL
    
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        brandName: String,
        name: String,
        sku: String? = nil,
        genderCategory: GenderCategory = .unknown,
        originRegion: MarketRegion,
        originalURL: URL,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.brandName = brandName
        self.name = name
        self.sku = sku
        self.genderCategory = genderCategory
        self.originRegion = originRegion
        self.originalURL = originalURL
        self.createdAt = createdAt
    }
}