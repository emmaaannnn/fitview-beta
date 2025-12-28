import Foundation

/// The "Anchor" of the FitView ecosystem.
/// Defines the physical proportions required for the Body Double algorithm.
public struct User: Codable, Identifiable, Equatable {
    public let id: UUID
    public let username: String
    public let email: String
    
    // The "Anchor" Metrics (Trust Layer)
    public let heightCm: Int
    public let weightKg: Int
    public let bodyBuild: BodyBuildType
    
    // Geographical Context
    public let marketRegion: MarketRegion
    
    // Profile Metadata
    public let profileImageKey: String? // S3 Key, not a full URL
    public let isVerified: Bool
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        username: String,
        email: String,
        heightCm: Int,
        weightKg: Int,
        bodyBuild: BodyBuildType,
        marketRegion: MarketRegion,
        profileImageKey: String? = nil,
        isVerified: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.bodyBuild = bodyBuild
        self.marketRegion = marketRegion
        self.profileImageKey = profileImageKey
        self.isVerified = isVerified
        self.createdAt = createdAt
    }
}

// MARK: - Supporting Types

public enum BodyBuildType: String, Codable, CaseIterable {
    case slim = "Slim"
    case athletic = "Athletic"
    case muscular = "Muscular"
    case average = "Average"
    case curvy = "Curvy"
    case large = "Large"
}

public enum MarketRegion: String, Codable, CaseIterable {
    case au = "Australia"
    case us = "United States"
    case uk = "United Kingdom"
    case eu = "Europe"
    case jp = "Japan"
}