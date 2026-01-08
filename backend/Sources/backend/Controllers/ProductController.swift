import Vapor
import Fluent
import Models

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get(use: index)
        products.post(use: create)
        products.group(":productID") { p in
            p.get(use: getByID)
        }
    }

    func index(req: Request) async throws -> [ProductDTOs.Public] {
        let list = try await ProductModel.query(on: req.db).all()
        return try list.map { try $0.toPublicDTO() }
    }

    func getByID(req: Request) async throws -> ProductDTOs.Public {
        guard let id = req.parameters.get("productID", as: UUID.self), let product = try await ProductModel.find(id, on: req.db) else { throw Abort(.notFound) }
        return try product.toPublicDTO()
    }

    func create(req: Request) async throws -> ProductDTOs.Public {
        let dto = try req.content.decode(ProductDTOs.Create.self)

        // Minimal stub creation: real scraping and verification pipeline should replace this
        let sku = UUID().uuidString
        let host = dto.url.host ?? dto.url.absoluteString

        let product = ProductModel(
            brandName: "Unknown",
            sku: sku,
            storeName: host,
            name: host,
            genderCategory: .unknown,
            originRegion: .us,
            originalURL: dto.url
        )
        try await product.save(on: req.db)
        return try product.toPublicDTO()
    }
}
