import Fluent
import Vapor
import Models

final class FitReviewModel: Model, Content {
    static let schema = "fit_reviews"

    @ID(key: .id) var id: UUID?

    @Parent(key: "author_id") var author: UserModel
    @Parent(key: "product_id") var product: ProductModel

    @Field(key: "author_height_cm") var authorHeightCm: Int
    @Field(key: "author_body_build") var authorBodyBuildRaw: String

    @Field(key: "size_value") var sizeValue: String
    @Field(key: "gender_category") var genderCategoryRaw: String
    @Field(key: "size_region") var sizeRegionRaw: String

    @Field(key: "width_fit") var widthFit: Double
    @Field(key: "length_fit") var lengthFit: Double
    @Field(key: "fit_intent") var fitIntentRaw: String

    var authorBodyBuild: BodyBuildType {
        get { BodyBuildType(rawValue: authorBodyBuildRaw) ?? .average }
        set { authorBodyBuildRaw = newValue.rawValue }
    }

    var genderCategory: GenderCategory {
        get { GenderCategory(rawValue: genderCategoryRaw) ?? .unknown }
        set { genderCategoryRaw = newValue.rawValue }
    }

    var sizeRegion: MarketRegion {
        get { MarketRegion(rawValue: sizeRegionRaw) ?? .us }
        set { sizeRegionRaw = newValue.rawValue }
    }

    var fitIntent: FitIntent {
        get { FitIntent(rawValue: fitIntentRaw) ?? .intended }
        set { fitIntentRaw = newValue.rawValue }
    }
    @Field(key: "image_keys") var imageKeys: [String]
    @Field(key: "created_at") var createdAt: Date

    init() {}

    init(
        id: UUID? = nil,
        authorId: UUID,
        productId: UUID,
        authorHeightCm: Int,
        authorBodyBuild: BodyBuildType,
        sizeValue: String,
        genderCategory: GenderCategory,
        sizeRegion: MarketRegion,
        widthFit: Double,
        lengthFit: Double,
        fitIntent: FitIntent,
        imageKeys: [String],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.$author.id = authorId
        self.$product.id = productId
        self.authorHeightCm = authorHeightCm
        self.authorBodyBuildRaw = authorBodyBuild.rawValue
        self.sizeValue = sizeValue
        self.genderCategoryRaw = genderCategory.rawValue
        self.sizeRegionRaw = sizeRegion.rawValue
        self.widthFit = widthFit
        self.lengthFit = lengthFit
        self.fitIntentRaw = fitIntent.rawValue
        self.imageKeys = imageKeys
        self.createdAt = createdAt
    }

    func toPublicDTO(authorPublic: UserDTOs.Public) throws -> FitReviewDTOs.Public {
        guard let id = self.id else { throw Abort(.internalServerError) }
        return FitReviewDTOs.Public(
            id: id,
            author: authorPublic,
            productID: self.$product.id,
            authorHeightCm: authorHeightCm,
            authorBodyBuild: authorBodyBuild,
            sizeValue: sizeValue,
            genderCategory: genderCategory,
            sizeRegion: sizeRegion,
            widthFit: widthFit,
            lengthFit: lengthFit,
            fitIntent: fitIntent,
            imageKeys: imageKeys,
            createdAt: createdAt,
            widthDescription: self.widthDescription,
            lengthDescription: self.lengthDescription,
            compassVerdict: self.compassVerdict
        )
    }
}

extension FitReviewModel: @unchecked Sendable {}

// Reuse the computed descriptions from shared FitReview
extension FitReviewModel {
    var widthDescription: String {
        switch widthFit {
        case ..<(-0.7): return "Very Tight"
        case -0.7..<(-0.2): return "Slim"
        case -0.2...0.2: return "True to Size"
        case 0.2..<0.7: return "Relaxed"
        default: return "Oversized / Baggy"
        }
    }

    var lengthDescription: String {
        switch lengthFit {
        case ..<(-0.7): return "Very Cropped"
        case -0.7..<(-0.2): return "Short"
        case -0.2...0.2: return "Standard Length"
        case 0.2..<0.7: return "Long"
        default: return "Extra Long / Tall"
        }
    }

    var compassVerdict: String {
        if widthFit > 0.3 && lengthFit < -0.3 {
            return "Boxy & Cropped"
        } else if widthFit > 0.5 && lengthFit > 0.5 {
            return "Super Oversized"
        } else if widthFit < -0.3 && lengthFit < -0.3 {
            return "Small & Short"
        } else {
            return "\(widthDescription) / \(lengthDescription)"
        }
    }
}
