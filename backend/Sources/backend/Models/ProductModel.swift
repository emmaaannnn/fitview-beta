import Fluent
import Vapor
import Models

final class ProductModel: Model, Content {
    static let schema = "products"

    @ID(key: .id) var id: UUID?

    @Field(key: "brand_name") var brandName: String
    @Field(key: "sku") var sku: String

    @Field(key: "store_name") var storeName: String
    @Field(key: "name") var name: String
    // Enums stored as raw strings (safer for concurrency); computed props expose Swift enums
    @Field(key: "gender_category") var genderCategoryRaw: String
    @Field(key: "origin_region") var originRegionRaw: String
    @Field(key: "original_url") var originalURL: String

    var genderCategory: GenderCategory {
        get { GenderCategory(rawValue: genderCategoryRaw) ?? .unknown }
        set { genderCategoryRaw = newValue.rawValue }
    }

    var originRegion: MarketRegion {
        get { MarketRegion(rawValue: originRegionRaw) ?? .us }
        set { originRegionRaw = newValue.rawValue }
    }
    @Field(key: "created_at") var createdAt: Date

    init() {}

    init(
        id: UUID? = nil,
        brandName: String,
        sku: String,
        storeName: String,
        name: String,
        genderCategory: GenderCategory = .unknown,
        originRegion: MarketRegion,
        originalURL: URL,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.brandName = brandName
        self.sku = sku
        self.storeName = storeName
        self.name = name
        self.genderCategoryRaw = genderCategory.rawValue
        self.originRegionRaw = originRegion.rawValue
        self.originalURL = originalURL.absoluteString
        self.createdAt = createdAt
    }

    func toPublicDTO() throws -> ProductDTOs.Public {
        guard let id = self.id else { throw Abort(.internalServerError) }
        guard let url = URL(string: originalURL) else { throw Abort(.internalServerError) }
        return ProductDTOs.Public(
            id: id,
            brandName: brandName,
            sku: sku,
            storeName: storeName,
            name: name,
            genderCategory: genderCategory,
            originRegion: originRegion,
            originalURL: url,
            createdAt: createdAt
        )
    }
}

// Allow unchecked Sendable conformance in this skeleton module
extension ProductModel: @unchecked Sendable {}
