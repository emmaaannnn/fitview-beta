import Foundation

public enum ProductDTOs {
    
    // Public representation of a Product, sent from server to client
    public struct Public: Codable {
        public let id: UUID
        public let brandName: String
        public let name: String
        public let sku: String?
        public let genderCategory: GenderCategory
        public let originRegion: MarketRegion
        public let originalURL: URL

        public init(id: UUID, brandName: String, name: String, sku: String?, genderCategory: GenderCategory, originRegion: MarketRegion, originalURL: URL) {
            self.id = id
            self.brandName = brandName
            self.name = name
            self.sku = sku
            self.genderCategory = genderCategory
            self.originRegion = originRegion
            self.originalURL = originalURL
        }
    }

    // Sent from client to server to trigger a new scrape/addition
    public struct Create: Codable {
        public let url: URL

        public init(url: URL) {
            self.url = url
        }
    }
}
