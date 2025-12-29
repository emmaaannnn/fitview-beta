import Foundation

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
}