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
    
    let pictureService: PictureService
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("user")
        
        let protectedRoutes = user.grouped(GalopUpMiddleware())
        protectedRoutes.get("me", use: getMyUser)
        protectedRoutes.patch(use: updateUser)
        protectedRoutes.on(.PATCH, body: .collect(maxSize: "15mb"), use: updateUser)

        
        
    }
    
    
    @Sendable
    func getMyUser(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "USER_NOT_FOUND")
        }
        
        try await user.$pictureId.load(on: req.db)

        let url = try await pictureService.getPresignedUrl(key: user.pictureId?.key ?? "")
        return user.toDTO(url: url)
    }
    
    
    @Sendable
    func updateUser(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "USER_NOT_FOUND")
        }
        
        let updatedUser = try req.content.decode(UpdateUserDTO.self)
        
        //vérifier que username est unique. Ici ou via trigger SQL ?
        if let newUsername = updatedUser.username{
            user.username = newUsername
        }
        
        if let newPicture = updatedUser.picture{
            let oldPicture = user.pictureId
            let createPicture = CreatePictureDto(file: newPicture)
            var newKey: String = ""
            
            do{
                
                newKey = try await pictureService.upload(createPictureDto: createPicture)
                let newPictureId = createPicture.toModel(key: newKey)
                try await newPictureId.save(on: req.db)
                user.$pictureId.id = newPictureId.id
            }
            catch{
                if newKey != ""{
                    try await pictureService.delete(key: newKey)
                }
                if let oldPicture{
                    user.$pictureId.id = oldPicture.id

                }
                throw Abort(.badRequest, reason: "ERROR_UPLOADING_PICTURE")
            }
            
            if let oldPicture{
                try await pictureService.delete(key: oldPicture.key)
                try await oldPicture.delete(on: req.db)
            }
            
        }
        
        
        try await user.save(on: req.db)
        try await user.$pictureId.load(on: req.db)

        let url = try await pictureService.getPresignedUrl(key: user.pictureId?.key ?? "")

        return user.toDTO(url: url)
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
