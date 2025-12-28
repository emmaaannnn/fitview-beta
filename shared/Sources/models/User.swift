import Foundation

/// The "Anchor" of the FitView ecosystem.
/// Defines the physical proportions required for the Body Double algorithm.
public struct User: Codable, Identifiable, Equatable {
    public let id: UUID
    public let username: String
    public let email: String
    
    // The "Anchor" Metrics (Trust Layer)
    public let heightCm: Int?
    public let weightKg: Int?
    public let bodyBuild: BodyBuildType?
    public let stylePreference: StylePreference?
    
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
        heightCm: Int? = nil,
        weightKg: Int? = nil,
        bodyBuild: BodyBuildType? = nil,
        stylePreference: StylePreference? = nil,
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
        self.stylePreference = stylePreference
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
    case average = "Average"
    case muscular = "Muscular"
    case large = "Large"
    
    /// Provides a soulful description for the UI to help users choose accurately
    public var definition: String {
        switch self {
        case .slim: return "Narrow frame, lean volume."
        case .athletic: return "V-shape, toned, balanced volume."
        case .average: return "Standard frame, proportional volume."
        case .muscular: return "Broad frame, high muscle volume."
        case .large: return "Wide frame, high overall volume."
        }
    }
}

public enum MarketRegion: String, Codable, CaseIterable {
    case au = "AU"
    case us = "US"
    case uk = "UK"
    case eu = "EU"
    case jp = "JP"
    
    /// Returns the display name for the UI
    public var displayName: String {
        switch self {
        case .au: return "Australia"
        case .us: return "United States"
        case .uk: return "United Kingdom"
        case .eu: return "Europe"
        case .jp: return "Japan"
        }
    }
    
    /// Helps the app decide whether to show Metric or Imperial
    public var preferredSystem: MeasurementSystem {
        switch self {
        case .us, .uk: return .imperial
        default: return .metric
        }
    }
}

public enum MeasurementSystem: String, Codable {
    case metric   // cm/kg
    case imperial // ft-in/lbs
}

public enum StylePreference: String, Codable, CaseIterable {
    case menswear = "Menswear"     // Standard Male Sizing
    case womenswear = "Womenswear" // Standard Female Sizing
    case unisex = "Unisex"         // Gender-neutral/Oversized Sizing
    case fluid = "Fluid"           // Browses/Wears everything
}