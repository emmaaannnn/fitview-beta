import Foundation

public enum UserDTOs {
    
    // Sent from a client to create a user
    public struct Create: Codable {
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
    public struct Public: Codable {
        public let id: UUID
        public let username: String
        public let heightCm: Int?
        public let weightKg: Int?
        public let bodyBuild: BodyBuildType?
        public let stylePreference: StylePreference?
        public let marketRegion: MarketRegion
        public let profileImageKey: String?
        public let isVerified: Bool

        public init(id: UUID, username: String, heightCm: Int?, weightKg: Int?, bodyBuild: BodyBuildType?, stylePreference: StylePreference?, marketRegion: MarketRegion, profileImageKey: String?, isVerified: Bool) {
            self.id = id
            self.username = username
            self.heightCm = heightCm
            self.weightKg = weightKg
            self.bodyBuild = bodyBuild
            self.stylePreference = stylePreference
            self.marketRegion = marketRegion
            self.profileImageKey = profileImageKey
            self.isVerified = isVerified
        }
    }
    
    // Sent from a client to update a user's profile
    public struct Update: Codable {
        public let username: String?
        public let heightCm: Int?
        public let weightKg: Int?
        public let bodyBuild: BodyBuildType?
        public let stylePreference: StylePreference?
        public let marketRegion: MarketRegion?

        public init(username: String?, heightCm: Int?, weightKg: Int?, bodyBuild: BodyBuildType?, stylePreference: StylePreference?, marketRegion: MarketRegion?) {
            self.username = username
            self.heightCm = heightCm
            self.weightKg = weightKg
            self.bodyBuild = bodyBuild
            self.stylePreference = stylePreference
            self.marketRegion = marketRegion
        }
    }

    // Added for MVP Login
    public struct Login: Codable {
        public let email: String
        public let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}
