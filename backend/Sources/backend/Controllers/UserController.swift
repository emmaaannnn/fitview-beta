import Vapor
import Fluent
import Models

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { u in
            u.get(use: getByID)
            u.put(use: update)
        }
        users.post("login", use: login)
    }

    func index(req: Request) async throws -> [UserDTOs.Public] {
        let users = try await UserModel.query(on: req.db).all()
        return try users.map { try $0.toPublicDTO() }
    }

    func getByID(req: Request) async throws -> UserDTOs.Public {
        guard let id = req.parameters.get("userID", as: UUID.self) else { throw Abort(.badRequest) }
        guard let user = try await UserModel.find(id, on: req.db) else { throw Abort(.notFound) }
        return try user.toPublicDTO()
    }

    func create(req: Request) async throws -> UserDTOs.Public {
        let dto = try req.content.decode(UserDTOs.Create.self)

        // NOTE: Password handling and verification should be implemented in a real app.
        let user = UserModel(
            username: dto.username,
            email: dto.email,
            marketRegion: dto.marketRegion
        )
        try await user.save(on: req.db)
        return try user.toPublicDTO()
    }

    func update(req: Request) async throws -> UserDTOs.Public {
        guard let id = req.parameters.get("userID", as: UUID.self) else { throw Abort(.badRequest) }
        guard var user = try await UserModel.find(id, on: req.db) else { throw Abort(.notFound) }
        let dto = try req.content.decode(UserDTOs.Update.self)

        if let username = dto.username { user.username = username }
        if let height = dto.heightCm { user.heightCm = height }
        if let weight = dto.weightKg { user.weightKg = weight }
        if let body = dto.bodyBuild { user.bodyBuild = body }
        if let region = dto.marketRegion { user.marketRegion = region }

        try await user.save(on: req.db)
        return try user.toPublicDTO()
    }

    func login(req: Request) async throws -> HTTPStatus {
        // MVP placeholder: validates presence of a user with the email and password pair.
        let dto = try req.content.decode(UserDTOs.Login.self)
        guard let user = try await UserModel.query(on: req.db).filter(\.$email == dto.email).first() else {
            throw Abort(.unauthorized)
        }
        // Password verification not implemented in skeleton
        _ = user // suppress unused warning
        return .ok
    }
}
