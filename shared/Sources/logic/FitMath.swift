import Foundation
import Models

public struct FitMath {
    /// Determines how close a reviewer's height is to the searcher's height.
    /// Returns a value between 0.0 (Different) and 1.0 (Exact Match).
    public static func bodyDoubleScore(searcherHeight: Int, reviewHeight: Int) -> Double {
        let diff = abs(searcherHeight - reviewHeight)
        // If the height difference is more than 10cm, the score drops to 0
        let score = 1.0 - (Double(diff) / 10.0)
        return max(0, score)
    }

    /// Takes the raw Compass data and suggests a "Action" for the shopper.
    /// Example: If widthFit is 0.8, it suggests "Size Down for a standard fit."
    public static func sizeRecommendation(review: FitReview) -> String {
        let totalFit = (review.widthFit + review.lengthFit) / 2.0
        
        if totalFit > 0.6 {
            return "Runs Large: Consider sizing down."
        } else if totalFit < -0.6 {
            return "Runs Small: Consider sizing up."
        } else {
            return "True to size: Order your standard size."
        }
    }

    /// Provides regional sizing warnings based on user and review regions.
    /// For example, warns US users about Asian sizing differences.
    public static func regionalSizeWarning(userRegion: MarketRegion, reviewRegion: MarketRegion) -> String? {
        if userRegion == .us && reviewRegion == .asia {
            return "Note: Asian sizing runs significantly smaller than US sizing."
        }
        if userRegion == .asia && reviewRegion == .us {
            return "Note: US sizing runs significantly larger than Asian sizing."
        }
        return nil
    }

    /// Estimates the "Volume Difference" between regions.
    /// Returns a multiplier: > 1.0 means the garment is larger than the user's home region.
    public static func regionalVolumeScale(from garmentRegion: MarketRegion, to userRegion: MarketRegion) -> Double {
        switch (garmentRegion, userRegion) {
        // Japan to US: Garment will feel 2 sizes smaller
        case (.asia, .us): return 0.8 
        
        // US to Japan: Garment will feel 2 sizes larger
        case (.us, .asia): return 1.2 
        
        // AU to US: Garment will feel slightly slimmer
        case (.au, .us): return 0.95 
            
        default: return 1.0 // Same region or similar (like EU/UK/AU)
        }
    }
}