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

public enum BodyBuildType: String, Codable, CaseIterable, Sendable {
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

public enum MeasurementSystem: String, Codable {
    case metric   // cm/kg
    case imperial // ft-in/lbs
}

public extension User {
    /// Returns height in feet/inches for US/UK users, handling the optionality safely.
    var heightDisplay: String {
        // 1. "Unwrap" the optional height. If it's nil, return a placeholder.
        guard let height = heightCm else { 
            return "---" 
        }
        
        if marketRegion.preferredSystem == .imperial {
            let inches = Double(height) / 2.54
            let feet = Int(inches) / 12
            let remainingInches = Int(inches) % 12
            return "\(feet)'\(remainingInches)\""
        } else {
            // No longer an optional, so no warning here
            return "\(height)cm"
        }
    }
}