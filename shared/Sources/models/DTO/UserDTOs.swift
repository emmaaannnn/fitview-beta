import Foundation

public enum UserDTOs {
    
    // Sent from a client to create a user
    public struct Create: Codable, Sendable {
        public let username: String
        public let email: String
        public let password: String
        public let marketRegion: MarketRegion

        public init(username: String, email: String, password: String, marketRegion: MarketRegion) {
            self.username = username
            self.email = email
            self.password = password
            self.marketRegion = marketRegion
        }
    }
    
    // Sent from a server to a client for public display
    public struct Public: Codable, Sendable {
        public let id: UUID
        public let username: String
        public let heightCm: Int?
        public let weightKg: Int?
        public let bodyBuild: BodyBuildType?
        public let marketRegion: MarketRegion
        public let profileImageKey: String?
        public let isVerified: Bool

        public init(id: UUID, username: String, heightCm: Int?, weightKg: Int?, bodyBuild: BodyBuildType?, marketRegion: MarketRegion, profileImageKey: String?, isVerified: Bool) {
            self.id = id
            self.username = username
            self.heightCm = heightCm
            self.weightKg = weightKg
            self.bodyBuild = bodyBuild
            self.marketRegion = marketRegion
            self.profileImageKey = profileImageKey
            self.isVerified = isVerified
        }
    }
    
    // Sent from a client to update a user's profile
    public struct Update: Codable, Sendable {
        public let username: String?
        public let heightCm: Int?
        public let weightKg: Int?
        public let bodyBuild: BodyBuildType?
        public let marketRegion: MarketRegion?

        public init(username: String?, heightCm: Int?, weightKg: Int?, bodyBuild: BodyBuildType?, marketRegion: MarketRegion?) {
            self.username = username
            self.heightCm = heightCm
            self.weightKg = weightKg
            self.bodyBuild = bodyBuild
            self.marketRegion = marketRegion
        }
    }

    // Added for MVP Login
    public struct Login: Codable, Sendable {
        public let email: String
        public let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}
