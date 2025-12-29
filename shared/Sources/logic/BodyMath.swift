import Foundation
import Models

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
}