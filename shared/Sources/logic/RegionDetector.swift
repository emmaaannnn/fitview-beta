import Foundation
import Models

public struct RegionDetector {
    
    public static func detect(from url: URL) -> MarketRegion {
        let host = url.host()?.lowercased() ?? ""
        let path = url.path.lowercased()
        
        if host.hasSuffix(".jp") || path.contains("/jp/") || path.contains("/ja_jp/") { return .jp }
        if host.hasSuffix(".kr") || path.contains("/kr/") || path.contains("/ko_kr/") { return .kr }
        if host.hasSuffix(".au") || path.contains("/au/") || path.contains("/en_au/") { return .au }
        if host.hasSuffix(".uk") || path.contains("/uk/") || path.contains("/en_gb/") || path.contains("/gb/") { return .uk }
        
        return .us
    }

    /// Provides regional sizing warnings by comparing sizing groups
    public static func regionalSizeWarning(userRegion: MarketRegion, reviewRegion: MarketRegion) -> String? {
        let userGroup = userRegion.sizingGroup
        let reviewGroup = reviewRegion.sizingGroup
        
        if userGroup == "us" && reviewGroup == "asia" {
            return "Note: \(reviewRegion.displayName) sizing runs significantly smaller than US sizing."
        }
        if userGroup == "asia" && reviewGroup == "us" {
            return "Note: US sizing runs significantly larger than \(userRegion.displayName) sizing."
        }
        return nil
    }

    /// Estimates the "Volume Difference" between regions.
    public static func regionalVolumeScale(from garmentRegion: MarketRegion, to userRegion: MarketRegion) -> Double {
        let garmentGroup = garmentRegion.sizingGroup
        let userGroup = userRegion.sizingGroup
        
        switch (garmentGroup, userGroup) {
        case ("asia", "us"): return 0.8  // Garment is 20% smaller
        case ("us", "asia"): return 1.2  // Garment is 20% larger
        case ("western", "us"): return 0.95 // Slight difference
        default: return 1.0
        }
    }
}