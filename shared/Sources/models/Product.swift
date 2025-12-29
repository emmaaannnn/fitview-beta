import Foundation

public struct Product: Codable, Identifiable, Equatable {
    public let id: UUID
    public let brandName: String
    public let name: String
    
    /// The market the product was scraped from (Determines the sizing standard)
    public let originRegion: MarketRegion 
    
    // Web-Scraped Metadata
    public let globalReleaseDate: Date?
    public let originalURL: URL
    public let mainImageURL: URL?
    
    /// A snapshot of the product description to track cut changes over time
    public let descriptionSnapshot: String? 
    
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        brandName: String,
        name: String,
        originRegion: MarketRegion,
        globalReleaseDate: Date? = nil,
        originalURL: URL,
        mainImageURL: URL? = nil,
        descriptionSnapshot: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.brandName = brandName
        self.name = name
        self.originRegion = originRegion
        self.globalReleaseDate = globalReleaseDate
        self.originalURL = originalURL
        self.mainImageURL = mainImageURL
        self.descriptionSnapshot = descriptionSnapshot
        self.createdAt = createdAt
    }
}