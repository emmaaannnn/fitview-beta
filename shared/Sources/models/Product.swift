import Foundation

public struct Product: Codable, Identifiable, Equatable {
    public let id: UUID
    public let brandName: String
    public let name: String
    public let sku: String? // Added: The manufacturer's unique ID
    
    public let originRegion: MarketRegion 
    public let originalURL: URL
    
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        brandName: String,
        name: String,
        sku: String? = nil,
        originRegion: MarketRegion,
        originalURL: URL,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.brandName = brandName
        self.name = name
        self.sku = sku
        self.originRegion = originRegion
        self.originalURL = originalURL
        self.createdAt = createdAt
    }
}