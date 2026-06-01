//
//  UserController.swift
//  GalopUp
//
//  Created by Emma on 13/05/2026.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("user")
        
        let protectedRoutes = user.grouped(GalopUpMiddleware())
        protectedRoutes.get("me", use: getMyUser)
        
        
        
    }
    
    
    @Sendable
    func getMyUser(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "USER_NOT_FOUND")
        }
        return user.toDTO()
    }
    
    
    
    
    //MARK: SERVICE FUNCTIONS
    static func verifyEmailUnique(email: String, req: Request) async throws {
        
        let existingEmail = try await User.query(on: req.db)
            .filter(\.$email == email)
            .first()
        
        if existingEmail != nil {
            throw Abort(.badRequest, reason: "EMAIL_ALREADY_EXISTS")
        }
        
    }
    
    
    static func verifyEmailAndUsernameUnique(email: String, username: String, req: Request) async throws {
        let listUser = User.query(on: req.db)
        
        let existingEmail = try await listUser
            .filter(\.$email == email)
            .first()
        
        if existingEmail != nil {
            throw Abort(.badRequest, reason: "EMAIL_ALREADY_EXISTS")
        }
        
        let existingUsername = try await listUser
            .filter(\.$username == username)
            .first()
        
        if existingUsername != nil {
            throw Abort(.badRequest, reason: "USERNAME_ALREADY_EXISTS")
        }
    }
}
