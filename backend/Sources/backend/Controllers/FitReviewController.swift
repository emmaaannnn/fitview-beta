import Vapor
import Fluent
import Models

struct FitReviewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let reviews = routes.grouped("reviews")
        reviews.get(use: index)
        reviews.post(use: create)
        reviews.group(":reviewID") { r in
            r.get(use: getByID)
        }
    }

    func index(req: Request) async throws -> [FitReviewDTOs.Public] {
        let items = try await FitReviewModel.query(on: req.db).with(\.$author).all()
        var out: [FitReviewDTOs.Public] = []
        for item in items {
            let authorPublic = try item.author.toPublicDTO()
            try out.append(item.toPublicDTO(authorPublic: authorPublic))
        }
        return out
    }

    func getByID(req: Request) async throws -> FitReviewDTOs.Public {
        guard let id = req.parameters.get("reviewID", as: UUID.self), let review = try await FitReviewModel.query(on: req.db).filter(\.$id == id).with(\.$author).first() else { throw Abort(.notFound) }
        let authorPublic = try review.author.toPublicDTO()
        return try review.toPublicDTO(authorPublic: authorPublic)
    }

    func create(req: Request) async throws -> FitReviewDTOs.Public {
        // We expect an "X-Author-Id" header until auth is implemented
        guard let authorHeader = req.headers.first(name: "X-Author-Id"), let authorId = UUID(authorHeader) else {
            throw Abort(.badRequest, reason: "Missing X-Author-Id header")
        }

        let dto = try req.content.decode(FitReviewDTOs.Create.self)

        // Validate referenced resources
        guard let author = try await UserModel.find(authorId, on: req.db) else { throw Abort(.notFound, reason: "Author not found") }
        guard let product = try await ProductModel.find(dto.productId, on: req.db) else { throw Abort(.notFound, reason: "Product not found") }

        // Use author's metrics when available
        let authorHeight = author.heightCm ?? 0
        let authorBody = author.bodyBuild ?? .average

        let review = FitReviewModel(
            authorId: try author.requireID(),
            productId: try product.requireID(),
            authorHeightCm: authorHeight,
            authorBodyBuild: authorBody,
            sizeValue: dto.sizeValue,
            genderCategory: product.genderCategory,
            sizeRegion: product.originRegion,
            widthFit: dto.widthFit,
            lengthFit: dto.lengthFit,
            fitIntent: dto.fitIntent,
            imageKeys: dto.imageKeys
        )

        try await review.save(on: req.db)
        let authorPublic = try author.toPublicDTO()
        return try review.toPublicDTO(authorPublic: authorPublic)
    }
}
