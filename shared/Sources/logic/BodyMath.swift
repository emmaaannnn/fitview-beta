import Foundation
import Models

public enum ComparisonTier: String, Codable {
    case twin = "Body Twin"
    case similar = "Similar Build"
    case comparable = "Comparable Fit"
    case different = "Different Body Type"
}

public struct BodyComparison: Codable {
    public let tier: ComparisonTier
    public let percentage: Int // Out of 100
}


public struct BodyMath {
    /// Suggests a BodyBuildType based on Height and Weight.
    /// This is a starting point to reduce friction during onboarding.
    public static func suggestBuild(heightCm: Int, weightKg: Int) -> BodyBuildType {
        let heightMeters = Double(heightCm) / 100.0
        let bmi = Double(weightKg) / (heightMeters * heightMeters)
        
        switch bmi {
        case ..<18.5:
            return .slim
        case 18.5..<25.0:
            return .average
        case 25.0..<30.0:
            return .athletic // Often people in this range are active/toned
        case 30.0..<35.0:
            return .muscular // High mass, could be muscle or large
        default:
            return .large
        }
    }

    /// Compares two users based on their physical attributes (height, weight, body build).
    /// - Returns: A `BodyComparison` object containing a similarity tier and percentage, or `nil` if either user is missing required metrics.
    public static func compare(_ user1: User, to user2: User) -> BodyComparison? {
        guard let height1 = user1.heightCm, let weight1 = user1.weightKg, let build1 = user1.bodyBuild,
              let height2 = user2.heightCm, let weight2 = user2.weightKg, let build2 = user2.bodyBuild else {
            // Can't compare if essential data is missing
            return nil
        }
        
        // MAX SCORE: 100
        var score: Double = 0
        
        // 1. Height Score (Max 40 points)
        // Linear decay: full points for a 2cm difference, zero for 20cm+.
        let heightDifference = abs(height1 - height2)
        if heightDifference <= 2 {
            score += 40
        } else if heightDifference < 20 {
            score += 40 * (1 - (Double(heightDifference - 2) / 18.0))
        }
        
        // 2. Weight Score (Max 40 points)
        // Linear decay: full points for a 2kg difference, zero for 20kg+.
        let weightDifference = abs(weight1 - weight2)
        if weightDifference <= 2 {
            score += 40
        } else if weightDifference < 20 {
            score += 40 * (1 - (Double(weightDifference - 2) / 18.0))
        }
        
        // 3. Body Build Score (Max 20 points)
        // Ordinal comparison: exact match gets full points, adjacent gets half.
        let buildOrder: [BodyBuildType: Int] = [
            .slim: 0, .average: 1, .athletic: 2, .muscular: 3, .large: 4
        ]
        
        if let order1 = buildOrder[build1], let order2 = buildOrder[build2] {
            let buildDifference = abs(order1 - order2)
            if buildDifference == 0 {
                score += 20 // Identical build
            } else if buildDifference == 1 {
                score += 10 // Adjacent build (e.g., Slim and Average)
            }
        }
        
        let percentage = Int(score.rounded())
        
        let tier: ComparisonTier
        switch percentage {
        case 90...100:
            tier = .twin
        case 70..<90:
            tier = .similar
        case 50..<70:
            tier = .comparable
        default:
            tier = .different
        }
        
        return BodyComparison(tier: tier, percentage: percentage)
    }

    /// Finds the best matching user from a list for a given user.
    /// - Parameters:
    ///   - user: The user to find a match for.
    ///   - others: A list of other users to compare against.
    /// - Returns: A tuple containing the best matching user and their `BodyComparison`, or `nil` if no suitable matches are found.
    public static func findBestMatch(for user: User, from others: [User]) -> (user: User, comparison: BodyComparison)? {
        let comparisons = others.compactMap { otherUser -> (User, BodyComparison)? in
            // Ensure we don't compare a user to themselves
            guard user.id != otherUser.id else { return nil }
            
            if let comparison = compare(user, to: otherUser) {
                return (otherUser, comparison)
            }
            return nil
        }
        
        // Find the comparison with the highest percentage score
        return comparisons.max { $0.1.percentage < $1.1.percentage }
    }
}