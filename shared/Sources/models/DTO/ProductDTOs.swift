import Foundation

public enum ProductDTOs {
    
    // Public representation of a Product, sent from server to client
    public struct Public: Codable, Sendable {
        public let id: UUID
        // Anchors
        public let brandName: String
        public let sku: String // Now non-optional for verification
        
        // Metadata
        public let storeName: String // Added: for retailers like ASOS
        public let name: String
        public let genderCategory: GenderCategory
        public let originRegion: MarketRegion
        public let originalURL: URL
        public let createdAt: Date // Added: for version relevancy

        public init(
            id: UUID, 
            brandName: String, 
            sku: String, 
            storeName: String,
            name: String, 
            genderCategory: GenderCategory, 
            originRegion: MarketRegion, 
            originalURL: URL,
            createdAt: Date
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

    // Sent from client to server to trigger a new scrape/addition
    public struct Create: Codable, Sendable {
        public let url: URL

        public init(url: URL) {
            self.url = url
        }
    }
}