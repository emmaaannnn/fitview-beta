import Foundation
import Models

public struct FitMath {
    // ... bodyDoubleScore and sizeRecommendation stay the same ...

    /// Provides regional sizing warnings based on sizing groups
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
        // Asia to US: Garment will feel 2 sizes smaller
        case ("asia", "us"): return 0.8 
        
        // US to Asia: Garment will feel 2 sizes larger
        case ("us", "asia"): return 1.2 
        
        // AU/UK to US: Garment will feel slightly slimmer
        case ("western", "us"): return 0.95 
            
        default: return 1.0 
        }
    }
}