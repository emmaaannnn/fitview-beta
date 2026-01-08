import Vapor
import Models

extension UserDTOs.Create: Content {}
extension UserDTOs.Public: Content {}
extension UserDTOs.Update: Content {}
extension UserDTOs.Login: Content {}

extension ProductDTOs.Create: Content {}
extension ProductDTOs.Public: Content {}

extension FitReviewDTOs.Create: Content {}
extension FitReviewDTOs.Public: Content {}
