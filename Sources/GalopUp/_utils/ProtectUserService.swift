//
//  ProtectUserService.swift
//  GalopUp
//
//  Created by Emma on 28/09/2026.
//

import Vapor
import Fluent


struct ProtectService {
    
    func protect(req: Request, roles: [UserRoleEnum]) async throws -> User{
        let payload = try req.auth.require(UserPayload.self)

        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "USER_NOT_FOUND")
        }
        
        guard roles.contains(user.role) else {
            throw Abort(.forbidden, reason: "NOT_ENOUGH_PERMISSION")
        }
        
        return user
    }
}
