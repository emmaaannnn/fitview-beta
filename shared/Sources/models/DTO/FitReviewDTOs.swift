import Foundation

public enum FitReviewDTOs {
    
    // Sent from client to create a new FitReview
    public struct Create: Codable, Sendable {
        public let productId: UUID
        public let sizeValue: String
        public let widthFit: Double
        public let lengthFit: Double
        public let fitIntent: FitIntent
        public let imageKeys: [String]

        public init(productId: UUID, sizeValue: String, widthFit: Double, lengthFit: Double, fitIntent: FitIntent, imageKeys: [String]) {
            self.productId = productId
            self.sizeValue = sizeValue
            self.widthFit = widthFit
            self.lengthFit = lengthFit
            self.fitIntent = fitIntent
            self.imageKeys = imageKeys
        }
    }
    
    // Public representation of a FitReview, sent from server to client
    public struct Public: Codable, Sendable {
        public let id: UUID
        public let author: UserDTOs.Public // Embed the author's public profile
        public let productID: UUID
        
        // Author's stats at time of review
        public let authorHeightCm: Int
        public let authorBodyBuild: BodyBuildType
        
        // Item specifics
        public let sizeValue: String
        public let genderCategory: GenderCategory
        public let sizeRegion: MarketRegion
        
        // The fit compass
        public let widthFit: Double
        public let lengthFit: Double
        public let fitIntent: FitIntent
        
        // Content
        public let imageKeys: [String]
        public let createdAt: Date
        
        // Descriptions
        public let widthDescription: String
        public let lengthDescription: String
        public let compassVerdict: String

        public init(id: UUID, author: UserDTOs.Public, productID: UUID, authorHeightCm: Int, authorBodyBuild: BodyBuildType, sizeValue: String, genderCategory: GenderCategory, sizeRegion: MarketRegion, widthFit: Double, lengthFit: Double, fitIntent: FitIntent, imageKeys: [String], createdAt: Date, widthDescription: String, lengthDescription: String, compassVerdict: String) {
            self.id = id
            self.author = author
            self.productID = productID
            self.authorHeightCm = authorHeightCm
            self.authorBodyBuild = authorBodyBuild
            self.sizeValue = sizeValue
            self.genderCategory = genderCategory
            self.sizeRegion = sizeRegion
            self.widthFit = widthFit
            self.lengthFit = lengthFit
            self.fitIntent = fitIntent
            self.imageKeys = imageKeys
            self.createdAt = createdAt
            self.widthDescription = widthDescription
            self.lengthDescription = lengthDescription
            self.compassVerdict = compassVerdict
        }
    }
}
