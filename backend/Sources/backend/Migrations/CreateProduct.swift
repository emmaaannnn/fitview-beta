import Fluent

struct CreateProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ProductModel.schema)
            .id()
            .field("brand_name", .string, .required)
            .field("sku", .string, .required)
            .field("store_name", .string, .required)
            .field("name", .string, .required)
            .field("gender_category", .string, .required)
            .field("origin_region", .string, .required)
            .field("original_url", .string, .required)
            .field("created_at", .datetime, .required)
            .unique(on: "brand_name", "sku")
            
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ProductModel.schema).delete()
    }
}
