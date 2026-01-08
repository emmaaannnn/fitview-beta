import Fluent
import Vapor
import Models // shared module

final class UserModel: Model, Content {
    static let schema = "users"

    @ID(key: .id) var id: UUID?
    @Field(key: "username") var username: String
    @Field(key: "email") var email: String

    @Field(key: "height_cm") var heightCm: Int?
    @Field(key: "weight_kg") var weightKg: Int?

    // Stored as raw strings for Sendable safety; computed properties expose the enums.
    @Field(key: "body_build") var bodyBuildRaw: String?

    @Field(key: "market_region") var marketRegionRaw: String
    @Field(key: "profile_image_key") var profileImageKey: String?
    @Field(key: "is_verified") var isVerified: Bool

    var bodyBuild: BodyBuildType? {
        get { bodyBuildRaw.flatMap(BodyBuildType.init(rawValue:)) }
        set { bodyBuildRaw = newValue?.rawValue }
    }

    var marketRegion: MarketRegion {
        get { MarketRegion(rawValue: marketRegionRaw) ?? .us }
        set { marketRegionRaw = newValue.rawValue }
    }

    @Field(key: "created_at") var createdAt: Date

    init() {}

    init(
        id: UUID? = nil,
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
        self.bodyBuildRaw = bodyBuild?.rawValue
        self.marketRegionRaw = marketRegion.rawValue
        self.profileImageKey = profileImageKey
        self.isVerified = isVerified
        self.createdAt = createdAt
    }

    // Convert to Public DTO
    func toPublicDTO() throws -> UserDTOs.Public {
        guard let id = self.id else { throw Abort(.internalServerError) }
        return UserDTOs.Public(
            id: id,
            username: username,
            heightCm: heightCm,
            weightKg: weightKg,
            bodyBuild: bodyBuild,
            marketRegion: marketRegion,
            profileImageKey: profileImageKey,
            isVerified: isVerified
        )
    }
}

// Sendable conformance suppressed for model storage types in this skeleton server.
extension UserModel: @unchecked Sendable {}
