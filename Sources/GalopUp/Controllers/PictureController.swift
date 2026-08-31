//
//  PictureController.swift
//  GalopUp
//
//  Created by Emma on 11/08/2026.
//

import Vapor
import Fluent

struct PictureController: RouteCollection {
    
    let pictureService: PictureService
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("picture")
        
        let protectedRoutes = user.grouped(GalopUpMiddleware())
        protectedRoutes.get(use: getPictureDefault)
    }
    
    @Sendable
    func getPictureDefault(req: Request) async throws -> [GetPictureDto] {
         try req.auth.require(UserPayload.self)
        
        let pictures = try await Picture.query(on: req.db).filter(\.$isDefault == true).all()
        
        var picturesDto: [GetPictureDto] = []
        for picture in pictures {
            let url = try await pictureService.getPresignedUrl(key: picture.key)
            picturesDto.append(picture.toDTO(url: url))
        }
        
        return picturesDto
    }
    
   
    
    func getPicturesByPostId(postId: UUID, req: Request) async throws -> [GetPictureDto]{
        try req.auth.require(UserPayload.self)
       
        let pictures = try await Picture.query(on: req.db).filter(\.$post.$id == postId).all()
       
       var picturesDto: [GetPictureDto] = []
       for picture in pictures {
           let url = try await pictureService.getPresignedUrl(key: picture.key)
           picturesDto.append(picture.toDTO(url: url))
       }
       
       return picturesDto
    }
}
