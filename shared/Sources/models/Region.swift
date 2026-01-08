import Foundation

public enum MarketRegion: String, Codable, CaseIterable, Sendable {
    case au = "AU"
    case us = "US"
    case uk = "UK"
    case eu = "EU"
    case jp = "JP"
    case kr = "KR"
    
    public var displayName: String {
        switch self {
        case .au: return "Australia"
        case .us: return "United States"
        case .uk: return "United Kingdom"
        case .eu: return "Europe"
        case .jp: return "Japan"
        case .kr: return "Korea"
        }
    }
    
    /// Helper to group regions with similar physical sizing standards
    public var sizingGroup: String {
        switch self {
        case .jp, .kr: return "asia"
        case .us: return "us"
        case .au, .uk, .eu: return "western"
        }
    }

    public var preferredSystem: MeasurementSystem {
        switch self {
        case .us, .uk: return .imperial
        default: return .metric
        }
    }
}