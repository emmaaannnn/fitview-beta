import Foundation

/// The "Soul" of FitView. 
/// Minimalist data structure designed for high-fidelity trust.
public struct FitReview: Codable, Identifiable {
    public let id: UUID
    public let userId: UUID
    
    // The "Body Double" Metrics (The Trust Layer)
    public let heightCm: Int
    public let weightKg: Int
    public let bodyBuild: BodyBuildType
    
    // The Content
    public let imageURL: URL
    public let brandName: String
    public let sizeWorn: String
    public let fitRating: Int // 1-5 Scale
    
    public init(id: UUID = UUID(), userId: UUID, heightCm: Int, weightKg: Int, bodyBuild: BodyBuildType, imageURL: URL, brandName: String, sizeWorn: String, fitRating: Int) {
        self.id = id
        self.userId = userId
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.bodyBuild = bodyBuild
        self.imageURL = imageURL
        self.brandName = brandName
        self.sizeWorn = sizeWorn
        self.fitRating = fitRating
    }
}

public enum BodyBuildType: String, Codable, CaseIterable {
    case slim, athletic, muscular, husky, oversized
}