import Foundation

public struct Post: Codable, Identifiable {
    public let id: UUID
    public let authorId: UUID
    
    // The Snapshot (The "What")
    public let brandName: String
    public let productName: String
    public let sizeWorn: String
    public let productURL: URL?
    
    // The Fit Compass (The "How")
    // x: -1.0 (Tight) to 1.0 (Baggy)
    // y: -1.0 (Short/Cropped) to 1.0 (Long)
    public let fitWidth: Double
    public let fitLength: Double
    
    // The Soul (The "Vibe")
    public let weight: MaterialWeight
    public let feel: MaterialFeel
    
    // Assets
    public let imageKey: String // S3 path for the user's photo
    public let timestamp: Date

    public init(
        id: UUID = UUID(),
        authorId: UUID,
        brandName: String,
        productName: String,
        sizeWorn: String,
        productURL: URL? = nil,
        fitWidth: Double,
        fitLength: Double,
        weight: MaterialWeight,
        feel: MaterialFeel,
        imageKey: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.authorId = authorId
        self.brandName = brandName
        self.productName = productName
        self.sizeWorn = sizeWorn
        self.productURL = productURL
        self.fitWidth = fitWidth
        self.fitLength = fitLength
        self.weight = weight
        self.feel = feel
        self.imageKey = imageKey
        self.timestamp = timestamp
    }
}

public enum MaterialWeight: String, Codable, CaseIterable {
    case light = "Lightweight"
    case mid = "Mid-weight"
    case heavy = "Heavyweight"
}

public enum MaterialFeel: String, Codable, CaseIterable {
    case crisp = "Crisp"
    case soft = "Soft"
    case fluid = "Fluid"
    case stiff = "Stiff"
    case technical = "Technical"
}