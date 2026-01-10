import Vapor
import Fluent
import SwiftSoup // 1. Need this to parse HTML
import Models
import Logic     // 2. Need this for ProductDetector & GenderDetector

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
        guard let id = req.parameters.get("productID", as: UUID.self),
              let product = try await ProductModel.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return try product.toPublicDTO()
    }

    // 🚀 THE REAL IMPLEMENTATION
    func create(req: Request) async throws -> ProductDTOs.Public {
        // 1. Decode the URL from the request
        let dto = try req.content.decode(ProductDTOs.Create.self)
        let url = dto.url

        // 2. Fetch the HTML (Using Vapor's non-blocking Client)
        let response = try await req.client.get(URI(string: url.absoluteString))
        guard let body = response.body, let htmlString = body.getString(at: 0, length: body.readableBytes) else {
            throw Abort(.badRequest, reason: "Could not fetch HTML from URL")
        }
        
        // 3. Parse HTML
        let doc = try SwiftSoup.parse(htmlString)

        // 4. Run the "Brain" (Shared Logic)
        let store = ProductDetector.detectStore(from: url)
        let brand = ProductDetector.detectBrand(from: doc, storeName: store)
        let region = RegionDetector.detect(from: url)
        
        // SKU Check
        guard let sku = ProductDetector.detectSKU(from: doc, urlString: url.absoluteString, brandName: brand, storeName: store), !sku.isEmpty else {
            throw Abort(.badRequest, reason: "Could not detect valid SKU. Product verification failed.")
        }
        
        // Demographics
        let rawTitle = try doc.title()
        let name = rawTitle.components(separatedBy: " | ")[0] // Simple cleanup
        let bodyText = (try? doc.body()?.text()) ?? ""
        let breadcrumbs = (try? doc.select(".breadcrumb, .breadcrumbs").text()) ?? ""
        
        let gender = GenderDetector.detectGender(from: url, title: name, bodyText: bodyText, breadcrumbs: breadcrumbs)

        // 5. 🛑 IDEMPOTENCY CHECK (The "Find or Create" Gate)
        // We look for a product that matches THIS Brand and THIS SKU.
        if let existingProduct = try await ProductModel.query(on: req.db)
            .filter(\.$brandName == brand)
            .filter(\.$sku == sku)
            .first() {
            // Found it! Return the existing one. Do not save duplicate.
            return try existingProduct.toPublicDTO()
        }

        // 6. Create New (If it didn't exist)
        let newProduct = ProductModel(
            brandName: brand,
            sku: sku,
            storeName: store,
            name: name,
            genderCategory: gender,
            originRegion: region,
            originalURL: url
        )

        try await newProduct.save(on: req.db)
        return try newProduct.toPublicDTO()
    }
}