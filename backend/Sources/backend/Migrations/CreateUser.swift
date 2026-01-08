import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema)
            .id()
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("height_cm", .int)
            .field("weight_kg", .int)
            .field("body_build", .string)
            .field("market_region", .string, .required)
            .field("profile_image_key", .string)
            .field("is_verified", .bool, .required, .sql(.default(false)))
            .field("created_at", .datetime, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema).delete()
    }
}
