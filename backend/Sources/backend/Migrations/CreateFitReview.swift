import Fluent

struct CreateFitReview: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(FitReviewModel.schema)
            .id()
            .field("author_id", .uuid, .required)
            .field("product_id", .uuid, .required)
            .field("author_height_cm", .int, .required)
            .field("author_body_build", .string, .required)
            .field("size_value", .string, .required)
            .field("gender_category", .string, .required)
            .field("size_region", .string, .required)
            .field("width_fit", .double, .required)
            .field("length_fit", .double, .required)
            .field("fit_intent", .string, .required)
            .field("image_keys", .array(of: .string), .required)
            .field("created_at", .datetime, .required)
            .foreignKey("author_id", references: UserModel.schema, .id, onDelete: .cascade)
            .foreignKey("product_id", references: ProductModel.schema, .id, onDelete: .cascade)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(FitReviewModel.schema).delete()
    }
}
